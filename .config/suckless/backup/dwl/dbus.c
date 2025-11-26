#include "dbus.h"

#include "util.h"

#include <dbus/dbus.h>
#include <stdlib.h>
#include <wayland-server-core.h>

#include <fcntl.h>
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <unistd.h>

static void
close_pipe(void *data)
{
	int *pipefd = data;

	close(pipefd[0]);
	close(pipefd[1]);
	free(pipefd);
}

static int
dwl_dbus_dispatch(int fd, unsigned int mask, void *data)
{
	DBusConnection *conn = data;

	int pending;
	DBusDispatchStatus oldstatus, newstatus;

	oldstatus = dbus_connection_get_dispatch_status(conn);
	newstatus = dbus_connection_dispatch(conn);

	/* Don't clear pending flag if status didn't change */
	if (oldstatus == newstatus)
		return 0;

	if (read(fd, &pending, sizeof(int)) < 0) {
		perror("read");
		die("Error in dbus dispatch");
	}

	return 0;
}

static int
dwl_dbus_watch_handle(int fd, uint32_t mask, void *data)
{
	DBusWatch *watch = data;

	uint32_t flags = 0;

	if (!dbus_watch_get_enabled(watch))
		return 0;

	if (mask & WL_EVENT_READABLE)
		flags |= DBUS_WATCH_READABLE;
	if (mask & WL_EVENT_WRITABLE)
		flags |= DBUS_WATCH_WRITABLE;
	if (mask & WL_EVENT_HANGUP)
		flags |= DBUS_WATCH_HANGUP;
	if (mask & WL_EVENT_ERROR)
		flags |= DBUS_WATCH_ERROR;

	dbus_watch_handle(watch, flags);

	return 0;
}

static dbus_bool_t
dwl_dbus_add_watch(DBusWatch *watch, void *data)
{
	struct wl_event_loop *loop = data;

	int fd;
	struct wl_event_source *watch_source;
	uint32_t mask = 0, flags;

	if (!dbus_watch_get_enabled(watch))
		return TRUE;

	flags = dbus_watch_get_flags(watch);
	if (flags & DBUS_WATCH_READABLE)
		mask |= WL_EVENT_READABLE;
	if (flags & DBUS_WATCH_WRITABLE)
		mask |= WL_EVENT_WRITABLE;

	fd = dbus_watch_get_unix_fd(watch);
	watch_source = wl_event_loop_add_fd(loop, fd, mask,
	                                    dwl_dbus_watch_handle, watch);

	dbus_watch_set_data(watch, watch_source, NULL);

	return TRUE;
}

static void
dwl_dbus_remove_watch(DBusWatch *watch, void *data)
{
	struct wl_event_source *watch_source = dbus_watch_get_data(watch);

	if (watch_source)
		wl_event_source_remove(watch_source);
}

static int
dwl_dbus_timeout_handle(void *data)
{
	DBusTimeout *timeout = data;

	if (dbus_timeout_get_enabled(timeout))
		dbus_timeout_handle(timeout);

	return 0;
}

static dbus_bool_t
dwl_dbus_add_timeout(DBusTimeout *timeout, void *data)
{
	struct wl_event_loop *loop = data;

	int r, interval;
	struct wl_event_source *timeout_source;

	if (!dbus_timeout_get_enabled(timeout))
		return TRUE;

	interval = dbus_timeout_get_interval(timeout);

	timeout_source =
		wl_event_loop_add_timer(loop, dwl_dbus_timeout_handle, timeout);

	r = wl_event_source_timer_update(timeout_source, interval);
	if (r < 0) {
		wl_event_source_remove(timeout_source);
		return FALSE;
	}

	dbus_timeout_set_data(timeout, timeout_source, NULL);

	return TRUE;
}

static void
dwl_dbus_remove_timeout(DBusTimeout *timeout, void *data)
{
	struct wl_event_source *timeout_source;

	timeout_source = dbus_timeout_get_data(timeout);

	if (timeout_source) {
		wl_event_source_timer_update(timeout_source, 0);
		wl_event_source_remove(timeout_source);
	}
}

static void
dwl_dbus_dispatch_status(DBusConnection *conn, DBusDispatchStatus status,
                         void *data)
{
	int *pipefd = data;

	if (status != DBUS_DISPATCH_COMPLETE) {
		int pending = 1;
		if (write(pipefd[1], &pending, sizeof(int)) < 0) {
			perror("write");
			die("Error in dispatch status");
		}
	}
}

struct wl_event_source *
startbus(DBusConnection *conn, struct wl_event_loop *loop)
{
	int *pipefd;
	int pending = 1, flags;
	struct wl_event_source *bus_source = NULL;

	pipefd = ecalloc(2, sizeof(int));

	/*
	 * Libdbus forbids calling dbus_connection_dipatch from the
	 * DBusDispatchStatusFunction directly. Notify the event loop of
	 * updates via a self-pipe.
	 */
	if (pipe(pipefd) < 0)
		goto fail;
	if (((flags = fcntl(pipefd[0], F_GETFD)) < 0) ||
	    fcntl(pipefd[0], F_SETFD, flags | FD_CLOEXEC) < 0 ||
	    ((flags = fcntl(pipefd[1], F_GETFD)) < 0) ||
	    fcntl(pipefd[1], F_SETFD, flags | FD_CLOEXEC) < 0) {
		goto fail;
	}

	dbus_connection_set_exit_on_disconnect(conn, FALSE);

	bus_source = wl_event_loop_add_fd(loop, pipefd[0], WL_EVENT_READABLE,
	                                  dwl_dbus_dispatch, conn);
	if (!bus_source)
		goto fail;

	dbus_connection_set_dispatch_status_function(conn,
	                                             dwl_dbus_dispatch_status,
	                                             pipefd, close_pipe);
	if (!dbus_connection_set_watch_functions(conn, dwl_dbus_add_watch,
	                                         dwl_dbus_remove_watch, NULL,
	                                         loop, NULL)) {
		goto fail;
	}
	if (!dbus_connection_set_timeout_functions(conn, dwl_dbus_add_timeout,
	                                           dwl_dbus_remove_timeout,
	                                           NULL, loop, NULL)) {
		goto fail;
	}
	if (dbus_connection_get_dispatch_status(conn) != DBUS_DISPATCH_COMPLETE)
		if (write(pipefd[1], &pending, sizeof(int)) < 0)
			goto fail;

	return bus_source;

fail:
	if (bus_source)
		wl_event_source_remove(bus_source);
	dbus_connection_set_timeout_functions(conn, NULL, NULL, NULL, NULL,
	                                      NULL);
	dbus_connection_set_watch_functions(conn, NULL, NULL, NULL, NULL, NULL);
	dbus_connection_set_dispatch_status_function(conn, NULL, NULL, NULL);

	return NULL;
}

void
stopbus(DBusConnection *conn, struct wl_event_source *bus_source)
{
	wl_event_source_remove(bus_source);
	dbus_connection_set_watch_functions(conn, NULL, NULL, NULL, NULL, NULL);
	dbus_connection_set_timeout_functions(conn, NULL, NULL, NULL, NULL,
	                                      NULL);
	dbus_connection_set_dispatch_status_function(conn, NULL, NULL, NULL);
}
