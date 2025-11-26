#include "menu.h"

#include <dbus/dbus.h>
#include <wayland-server-core.h>
#include <wayland-util.h>

#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

// IWYU pragma: no_include "dbus/dbus-protocol.h"
// IWYU pragma: no_include "dbus/dbus-shared.h"

#define DBUSMENU_IFACE "com.canonical.dbusmenu"
#define BUFSIZE 512
#define LABEL_MAX 64

typedef struct {
	struct wl_array layout;
	DBusConnection *conn;
	struct wl_event_loop *loop;
	char *busname;
	char *busobj;
	const char **menucmd;
} Menu;

typedef struct {
	char label[LABEL_MAX];
	dbus_int32_t id;
	struct wl_array submenu;
	int has_submenu;
} MenuItem;

typedef struct {
	struct wl_event_loop *loop;
	struct wl_event_source *fd_source;
	struct wl_array *layout_node;
	Menu *menu;
	pid_t menu_pid;
	int fd;
} MenuShowContext;

static int extract_menu (DBusMessageIter *av, struct wl_array *menu);
static int real_show_menu (Menu *menu, struct wl_array *m);
static void submenus_destroy_recursive (struct wl_array *m);

static void
menuitem_init(MenuItem *mi)
{
	wl_array_init(&mi->submenu);
	mi->id = -1;
	*mi->label = '\0';
	mi->has_submenu = 0;
}

static void
submenus_destroy_recursive(struct wl_array *layout_node)
{
	MenuItem *mi;

	wl_array_for_each(mi, layout_node) {
		if (mi->has_submenu) {
			submenus_destroy_recursive(&mi->submenu);
			wl_array_release(&mi->submenu);
		}
	}
}

static void
menu_destroy(Menu *menu)
{
	submenus_destroy_recursive(&menu->layout);
	wl_array_release(&menu->layout);
	free(menu->busname);
	free(menu->busobj);
	free(menu);
}

static void
menu_show_ctx_finalize(MenuShowContext *ctx, int error)
{
	if (ctx->fd_source)
		wl_event_source_remove(ctx->fd_source);

	if (ctx->fd >= 0)
		close(ctx->fd);

	if (ctx->menu_pid >= 0) {
		if (waitpid(ctx->menu_pid, NULL, WNOHANG) == 0)
			kill(ctx->menu_pid, SIGTERM);
	}

	if (error)
		menu_destroy(ctx->menu);

	free(ctx);
}

static void
remove_newline(char *buf)
{
	size_t len;

	len = strlen(buf);
	if (len > 0 && buf[len - 1] == '\n')
		buf[len - 1] = '\0';
}

static void
send_clicked(const char *busname, const char *busobj, int itemid,
             DBusConnection *conn)
{
	DBusMessage *msg = NULL;
	DBusMessageIter iter = DBUS_MESSAGE_ITER_INIT_CLOSED;
	DBusMessageIter sub = DBUS_MESSAGE_ITER_INIT_CLOSED;
	const char *data = "";
	const char *eventid = "clicked";
	time_t timestamp;

	timestamp = time(NULL);

	msg = dbus_message_new_method_call(busname, busobj, DBUSMENU_IFACE,
	                                   "Event");
	if (!msg)
		goto fail;

	dbus_message_iter_init_append(msg, &iter);
	if (!dbus_message_iter_append_basic(&iter, DBUS_TYPE_INT32, &itemid) ||
	    !dbus_message_iter_append_basic(&iter, DBUS_TYPE_STRING,
	                                    &eventid) ||
	    !dbus_message_iter_open_container(&iter, DBUS_TYPE_VARIANT,
	                                      DBUS_TYPE_STRING_AS_STRING,
	                                      &sub) ||
	    !dbus_message_iter_append_basic(&sub, DBUS_TYPE_STRING, &data) ||
	    !dbus_message_iter_close_container(&iter, &sub) ||
	    !dbus_message_iter_append_basic(&iter, DBUS_TYPE_UINT32,
	                                    &timestamp)) {
		goto fail;
	}

	if (!dbus_connection_send_with_reply(conn, msg, NULL, -1))
		goto fail;

	dbus_message_unref(msg);
	return;

fail:
	dbus_message_iter_abandon_container_if_open(&iter, &sub);
	if (msg)
		dbus_message_unref(msg);
}

static void
menuitem_selected(const char *label, struct wl_array *m, Menu *menu)
{
	MenuItem *mi;

	wl_array_for_each(mi, m) {
		if (strcmp(mi->label, label) == 0) {
			if (mi->has_submenu) {
				real_show_menu(menu, &mi->submenu);

			} else {
				send_clicked(menu->busname, menu->busobj,
				             mi->id, menu->conn);
				menu_destroy(menu);
			}

			return;
		}
	}
}

static int
read_pipe(int fd, uint32_t mask, void *data)
{
	MenuShowContext *ctx = data;

	char buf[BUFSIZE];
	ssize_t bytes_read;

	bytes_read = read(fd, buf, BUFSIZE);
	/* 0 == Got EOF, menu program closed without writing to stdout */
	if (bytes_read <= 0)
		goto fail;

	buf[bytes_read] = '\0';
	remove_newline(buf);

	menuitem_selected(buf, ctx->layout_node, ctx->menu);
	menu_show_ctx_finalize(ctx, 0);
	return 0;

fail:
	menu_show_ctx_finalize(ctx, 1);
	return 0;
}

static MenuShowContext *
prepare_show_ctx(struct wl_event_loop *loop, int monitor_fd, int dmenu_pid,
                 struct wl_array *layout_node, Menu *menu)
{
	MenuShowContext *ctx = NULL;
	struct wl_event_source *fd_src = NULL;

	ctx = calloc(1, sizeof(MenuShowContext));
	if (!ctx)
		goto fail;

	fd_src = wl_event_loop_add_fd(menu->loop, monitor_fd, WL_EVENT_READABLE,
	                              read_pipe, ctx);
	if (!fd_src)
		goto fail;

	ctx->fd_source = fd_src;
	ctx->fd = monitor_fd;
	ctx->menu_pid = dmenu_pid;
	ctx->layout_node = layout_node;
	ctx->menu = menu;

	return ctx;

fail:
	if (fd_src)
		wl_event_source_remove(fd_src);
	free(ctx);
	return NULL;
}

static int
write_dmenu_buf(char *buf, struct wl_array *layout_node)
{
	MenuItem *mi;
	int r;
	size_t curlen = 0;

	*buf = '\0';

	wl_array_for_each(mi, layout_node) {
		curlen += strlen(mi->label) +
		          2; /* +2 is newline + nul terminator */
		if (curlen + 1 > BUFSIZE) {
			r = -1;
			goto fail;
		}

		strcat(buf, mi->label);
		strcat(buf, "\n");
	}
	remove_newline(buf);

	return 0;

fail:
	fprintf(stderr, "Failed to construct dmenu input\n");
	return r;
}

static int
real_show_menu(Menu *menu, struct wl_array *layout_node)
{
	MenuShowContext *ctx = NULL;
	char buf[BUFSIZE];
	int to_pipe[2], from_pipe[2];
	pid_t pid;

	if (pipe(to_pipe) < 0 || pipe(from_pipe) < 0)
		goto fail;

	pid = fork();
	if (pid < 0) {
		goto fail;
	} else if (pid == 0) {
		dup2(to_pipe[0], STDIN_FILENO);
		dup2(from_pipe[1], STDOUT_FILENO);

		close(to_pipe[0]);
		close(to_pipe[1]);
		close(from_pipe[1]);
		close(from_pipe[0]);

		if (execvp(menu->menucmd[0], (char *const *)menu->menucmd)) {
			perror("Error spawning menu program");
			exit(EXIT_FAILURE);
		}
	}

	ctx = prepare_show_ctx(menu->loop, from_pipe[0], pid, layout_node,
	                       menu);
	if (!ctx)
		goto fail;

	if (write_dmenu_buf(buf, layout_node) < 0 ||
	    write(to_pipe[1], buf, strlen(buf)) < 0) {
		goto fail;
	}

	close(to_pipe[0]);
	close(to_pipe[1]);
	close(from_pipe[1]);
	return 0;

fail:
	close(to_pipe[0]);
	close(to_pipe[1]);
	close(from_pipe[1]);
	menu_show_ctx_finalize(ctx, 1);
	return -1;
}

static void
createmenuitem(MenuItem *mi, dbus_int32_t id, const char *label,
               int toggle_state, int has_submenu)
{
	char *tok;
	char temp[LABEL_MAX];

	if (toggle_state == 0)
		strcpy(mi->label, "☐ ");
	else if (toggle_state == 1)
		strcpy(mi->label, "✓ ");
	else
		strcpy(mi->label, "  ");

	/* Remove "mnemonics" (underscores which mark keyboard shortcuts) */
	strcpy(temp, label);
	tok = strtok(temp, "_");
	do {
		strcat(mi->label, tok);
	} while ((tok = strtok(NULL, "_")));

	if (has_submenu) {
		mi->has_submenu = 1;
		strcat(mi->label, " →");
	}

	mi->id = id;
}

/**
 * Populates the passed in menuitem based on the dictionary contents.
 *
 * @param[in] dict
 * @param[in] itemid
 * @param[in] mi
 * @param[out] has_submenu
 * @param[out] status <0 on error, 0 on success, >0 if menuitem was skipped
 */
static int
read_dict(DBusMessageIter *dict, dbus_int32_t itemid, MenuItem *mi,
          int *has_submenu)
{
	DBusMessageIter member, val;
	const char *children_display = NULL, *label = NULL, *toggle_type = NULL;
	const char *key;
	dbus_bool_t visible = TRUE, enabled = TRUE;
	dbus_int32_t toggle_state = 1;
	int r;

	do {
		dbus_message_iter_recurse(dict, &member);
		if (dbus_message_iter_get_arg_type(&member) !=
		    DBUS_TYPE_STRING) {
			r = -1;
			goto fail;
		}
		dbus_message_iter_get_basic(&member, &key);

		dbus_message_iter_next(&member);
		if (dbus_message_iter_get_arg_type(&member) !=
		    DBUS_TYPE_VARIANT) {
			r = -1;
			goto fail;
		}
		dbus_message_iter_recurse(&member, &val);

		if (strcmp(key, "visible") == 0) {
			if (dbus_message_iter_get_arg_type(&val) !=
			    DBUS_TYPE_BOOLEAN) {
				r = -1;
				goto fail;
			}
			dbus_message_iter_get_basic(&val, &visible);

		} else if (strcmp(key, "enabled") == 0) {
			if (dbus_message_iter_get_arg_type(&val) !=
			    DBUS_TYPE_BOOLEAN) {
				r = -1;
				goto fail;
			}
			dbus_message_iter_get_basic(&val, &enabled);

		} else if (strcmp(key, "toggle-type") == 0) {
			if (dbus_message_iter_get_arg_type(&val) !=
			    DBUS_TYPE_STRING) {
				r = -1;
				goto fail;
			}
			dbus_message_iter_get_basic(&val, &toggle_type);

		} else if (strcmp(key, "toggle-state") == 0) {
			if (dbus_message_iter_get_arg_type(&val) !=
			    DBUS_TYPE_INT32) {
				r = -1;
				goto fail;
			}
			dbus_message_iter_get_basic(&val, &toggle_state);

		} else if (strcmp(key, "children-display") == 0) {
			if (dbus_message_iter_get_arg_type(&val) !=
			    DBUS_TYPE_STRING) {
				r = -1;
				goto fail;
			}
			dbus_message_iter_get_basic(&val, &children_display);

			if (strcmp(children_display, "submenu") == 0)
				*has_submenu = 1;

		} else if (strcmp(key, "label") == 0) {
			if (dbus_message_iter_get_arg_type(&val) !=
			    DBUS_TYPE_STRING) {
				r = -1;
				goto fail;
			}
			dbus_message_iter_get_basic(&val, &label);
		}
	} while (dbus_message_iter_next(dict));

	/* Skip hidden etc items */
	if (!label || !visible || !enabled)
		return 1;

	/*
	 * 4 characters for checkmark and submenu indicator,
	 * 1 for nul terminator
	 */
	if (strlen(label) + 5 > LABEL_MAX) {
		fprintf(stderr, "Too long menu entry label: %s! Skipping...\n",
		        label);
		return 1;
	}

	if (toggle_type && strcmp(toggle_type, "checkmark") == 0)
		createmenuitem(mi, itemid, label, toggle_state, *has_submenu);
	else
		createmenuitem(mi, itemid, label, -1, *has_submenu);

	return 0;

fail:
	fprintf(stderr, "Error parsing menu data\n");
	return r;
}

/**
 * Extracts a menuitem from a DBusMessage
 *
 * @param[in] strct
 * @param[in] mi
 * @param[out] status <0 on error, 0 on success, >0 if menuitem was skipped
 */
static int
extract_menuitem(DBusMessageIter *strct, MenuItem *mi)
{
	DBusMessageIter val, dict;
	dbus_int32_t itemid;
	int has_submenu = 0;
	int r;

	dbus_message_iter_recurse(strct, &val);
	if (dbus_message_iter_get_arg_type(&val) != DBUS_TYPE_INT32) {
		r = -1;
		goto fail;
	}
	dbus_message_iter_get_basic(&val, &itemid);

	if (!dbus_message_iter_next(&val) ||
	    dbus_message_iter_get_arg_type(&val) != DBUS_TYPE_ARRAY) {
		r = -1;
		goto fail;
	}
	dbus_message_iter_recurse(&val, &dict);
	if (dbus_message_iter_get_arg_type(&dict) != DBUS_TYPE_DICT_ENTRY) {
		r = -1;
		goto fail;
	}

	r = read_dict(&dict, itemid, mi, &has_submenu);
	if (r < 0) {
		goto fail;

	} else if (r == 0 && has_submenu) {
		dbus_message_iter_next(&val);
		if (dbus_message_iter_get_arg_type(&val) != DBUS_TYPE_ARRAY)
			goto fail;
		r = extract_menu(&val, &mi->submenu);
		if (r < 0)
			goto fail;
	}

	return r;

fail:
	return r;
}

static int
extract_menu(DBusMessageIter *av, struct wl_array *layout_node)
{
	DBusMessageIter variant, menuitem;
	MenuItem *mi;
	int r;

	dbus_message_iter_recurse(av, &variant);
	if (dbus_message_iter_get_arg_type(&variant) != DBUS_TYPE_VARIANT) {
		r = -1;
		goto fail;
	}

	mi = wl_array_add(layout_node, sizeof(MenuItem));
	if (!mi) {
		r = -ENOMEM;
		goto fail;
	}
	menuitem_init(mi);

	do {
		dbus_message_iter_recurse(&variant, &menuitem);
		if (dbus_message_iter_get_arg_type(&menuitem) !=
		    DBUS_TYPE_STRUCT) {
			r = -1;
			goto fail;
		}

		r = extract_menuitem(&menuitem, mi);
		if (r < 0)
			goto fail;
		else if (r == 0) {
			mi = wl_array_add(layout_node, sizeof(MenuItem));
			if (!mi) {
				r = -ENOMEM;
				goto fail;
			}
			menuitem_init(mi);
		}
		/* r > 0: no action was performed on mi */
	} while (dbus_message_iter_next(&variant));

	return 0;

fail:
	return r;
}

static void
layout_ready(DBusPendingCall *pending, void *data)
{
	Menu *menu = data;

	DBusMessage *reply = NULL;
	DBusMessageIter iter, strct;
	dbus_uint32_t revision;
	int r;

	reply = dbus_pending_call_steal_reply(pending);
	if (!reply || dbus_message_get_type(reply) == DBUS_MESSAGE_TYPE_ERROR) {
		r = -1;
		goto fail;
	}

	dbus_message_iter_init(reply, &iter);
	if (dbus_message_iter_get_arg_type(&iter) != DBUS_TYPE_UINT32) {
		r = -1;
		goto fail;
	}
	dbus_message_iter_get_basic(&iter, &revision);

	if (!dbus_message_iter_next(&iter) ||
	    dbus_message_iter_get_arg_type(&iter) != DBUS_TYPE_STRUCT) {
		r = -1;
		goto fail;
	}
	dbus_message_iter_recurse(&iter, &strct);

	/*
	 * id 0 is the root, which contains nothing of interest.
	 * Traverse past it.
	 */
	if (dbus_message_iter_get_arg_type(&strct) != DBUS_TYPE_INT32 ||
	    !dbus_message_iter_next(&strct) ||
	    dbus_message_iter_get_arg_type(&strct) != DBUS_TYPE_ARRAY ||
	    !dbus_message_iter_next(&strct) ||
	    dbus_message_iter_get_arg_type(&strct) != DBUS_TYPE_ARRAY) {
		r = -1;
		goto fail;
	}

	/* Root traversed over, extract the menu */
	wl_array_init(&menu->layout);
	r = extract_menu(&strct, &menu->layout);
	if (r < 0)
		goto fail;

	r = real_show_menu(menu, &menu->layout);
	if (r < 0)
		goto fail;

	dbus_message_unref(reply);
	dbus_pending_call_unref(pending);
	return;

fail:
	menu_destroy(menu);
	if (reply)
		dbus_message_unref(reply);
	if (pending)
		dbus_pending_call_unref(pending);
}

static int
request_layout(Menu *menu)
{
	DBusMessage *msg = NULL;
	DBusMessageIter iter = DBUS_MESSAGE_ITER_INIT_CLOSED;
	DBusMessageIter strings = DBUS_MESSAGE_ITER_INIT_CLOSED;
	DBusPendingCall *pending = NULL;
	dbus_int32_t parentid, depth;
	int r;

	parentid = 0;
	depth = -1;

	/* menu busobj request answer didn't arrive yet. */
	if (!menu->busobj) {
		r = -1;
		goto fail;
	}

	msg = dbus_message_new_method_call(menu->busname, menu->busobj,
	                                   DBUSMENU_IFACE, "GetLayout");
	if (!msg) {
		r = -ENOMEM;
		goto fail;
	}

	dbus_message_iter_init_append(msg, &iter);
	if (!dbus_message_iter_append_basic(&iter, DBUS_TYPE_INT32,
	                                    &parentid) ||
	    !dbus_message_iter_append_basic(&iter, DBUS_TYPE_INT32, &depth) ||
	    !dbus_message_iter_open_container(&iter, DBUS_TYPE_ARRAY,
	                                      DBUS_TYPE_STRING_AS_STRING,
	                                      &strings) ||
	    !dbus_message_iter_close_container(&iter, &strings)) {
		r = -ENOMEM;
		goto fail;
	}

	if (!dbus_connection_send_with_reply(menu->conn, msg, &pending, -1) ||
	    !dbus_pending_call_set_notify(pending, layout_ready, menu, NULL)) {
		r = -ENOMEM;
		goto fail;
	}

	dbus_message_unref(msg);
	return 0;

fail:
	if (pending) {
		dbus_pending_call_cancel(pending);
		dbus_pending_call_unref(pending);
	}
	dbus_message_iter_abandon_container_if_open(&iter, &strings);
	if (msg)
		dbus_message_unref(msg);
	menu_destroy(menu);
	return r;
}

static void
about_to_show_handle(DBusPendingCall *pending, void *data)
{
	Menu *menu = data;

	DBusMessage *reply = NULL;

	reply = dbus_pending_call_steal_reply(pending);
	if (!reply)
		goto fail;

	if (request_layout(menu) < 0)
		goto fail;

	dbus_message_unref(reply);
	dbus_pending_call_unref(pending);
	return;

fail:
	if (reply)
		dbus_message_unref(reply);
	if (pending)
		dbus_pending_call_unref(pending);
	menu_destroy(menu);
}

void
menu_show(DBusConnection *conn, struct wl_event_loop *loop, const char *busname,
          const char *busobj, const char **menucmd)
{
	DBusMessage *msg = NULL;
	DBusPendingCall *pending = NULL;
	Menu *menu = NULL;
	char *busname_dup = NULL, *busobj_dup = NULL;
	dbus_int32_t parentid = 0;

	menu = calloc(1, sizeof(Menu));
	busname_dup = strdup(busname);
	busobj_dup = strdup(busobj);
	if (!menu || !busname_dup || !busobj_dup)
		goto fail;

	menu->conn = conn;
	menu->loop = loop;
	menu->busname = busname_dup;
	menu->busobj = busobj_dup;
	menu->menucmd = menucmd;

	msg = dbus_message_new_method_call(menu->busname, menu->busobj,
	                                   DBUSMENU_IFACE, "AboutToShow");
	if (!msg)
		goto fail;

	if (!dbus_message_append_args(msg, DBUS_TYPE_INT32, &parentid,
	                              DBUS_TYPE_INVALID) ||
	    !dbus_connection_send_with_reply(menu->conn, msg, &pending, -1) ||
	    !dbus_pending_call_set_notify(pending, about_to_show_handle, menu,
	                                  NULL)) {
		goto fail;
	}

	dbus_message_unref(msg);
	return;

fail:
	if (pending)
		dbus_pending_call_unref(pending);
	if (msg)
		dbus_message_unref(msg);
	free(menu);
}
