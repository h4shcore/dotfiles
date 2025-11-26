#include "watcher.h"

#include "item.h"
#include "tray.h"

#include <dbus/dbus.h>
#include <wayland-util.h>

#include <errno.h>
#include <stdio.h>
#include <string.h>

// IWYU pragma: no_include "dbus/dbus-protocol.h"
// IWYU pragma: no_include "dbus/dbus-shared.h"

static const char *const match_rule =
	"type='signal',"
	"interface='" DBUS_INTERFACE_DBUS
	"',"
	"member='NameOwnerChanged'";

static const char *const snw_xml =
	"<!DOCTYPE node PUBLIC \"-//freedesktop//DTD D-BUS Object Introspection 1.0//EN\"\n"
	" \"http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd\">\n"
	"<node>\n"
	"    <interface name=\"" DBUS_INTERFACE_PROPERTIES
	"\">\n"
	"        <method name=\"Get\">\n"
	"            <arg type=\"s\" name=\"interface_name\" direction=\"in\"/>\n"
	"            <arg type=\"s\" name=\"property_name\" direction=\"in\"/>\n"
	"            <arg type=\"v\" name=\"value\" direction=\"out\"/>\n"
	"        </method>\n"
	"        <method name=\"GetAll\">\n"
	"            <arg type=\"s\" name=\"interface_name\" direction=\"in\"/>\n"
	"            <arg type=\"a{sv}\" name=\"properties\" direction=\"out\"/>\n"
	"        </method>\n"
	"        <method name=\"Set\">\n"
	"            <arg type=\"s\" name=\"interface_name\" direction=\"in\"/>\n"
	"            <arg type=\"s\" name=\"property_name\" direction=\"in\"/>\n"
	"            <arg type=\"v\" name=\"value\" direction=\"in\"/>\n"
	"        </method>\n"
	"        <signal name=\"PropertiesChanged\">\n"
	"            <arg type=\"s\" name=\"interface_name\"/>\n"
	"            <arg type=\"a{sv}\" name=\"changed_properties\"/>\n"
	"            <arg type=\"as\" name=\"invalidated_properties\"/>\n"
	"        </signal>\n"
	"    </interface>\n"
	"    <interface name=\"" DBUS_INTERFACE_INTROSPECTABLE
	"\">\n"
	"        <method name=\"Introspect\">\n"
	"            <arg type=\"s\" name=\"xml_data\" direction=\"out\"/>\n"
	"        </method>\n"
	"    </interface>\n"
	"    <interface name=\"" DBUS_INTERFACE_PEER
	"\">\n"
	"        <method name=\"Ping\"/>\n"
	"        <method name=\"GetMachineId\">\n"
	"            <arg type=\"s\" name=\"machine_uuid\" direction=\"out\"/>\n"
	"        </method>\n"
	"    </interface>\n"
	"    <interface name=\"" SNW_IFACE
	"\">\n"
	"        <!-- methods -->\n"
	"        <method name=\"RegisterStatusNotifierItem\">\n"
	"            <arg name=\"service\" type=\"s\" direction=\"in\" />\n"
	"        </method>\n"
	"        <!-- properties -->\n"
	"        <property name=\"IsStatusNotifierHostRegistered\" type=\"b\" access=\"read\" />\n"
	"        <property name=\"ProtocolVersion\" type=\"i\" access=\"read\" />\n"
	"        <property name=\"RegisteredStatusNotifierItems\" type=\"as\" access=\"read\" />\n"
	"        <!-- signals -->\n"
	"        <signal name=\"StatusNotifierHostRegistered\">\n"
	"        </signal>\n"
	"    </interface>\n"
	"</node>\n";

static void
unregister_item(Watcher *watcher, Item *item)
{
	wl_list_remove(&item->link);
	destroyitem(item);

	watcher_update_trays(watcher);
}

static Item *
item_name_to_ptr(const Watcher *watcher, const char *busname)
{
	Item *item;

	wl_list_for_each(item, &watcher->items, link) {
		if (!item || !item->busname)
			return NULL;
		if (strcmp(item->busname, busname) == 0)
			return item;
	}

	return NULL;
}

static DBusHandlerResult
handle_nameowner_changed(Watcher *watcher, DBusConnection *conn,
                         DBusMessage *msg)
{
	char *name, *old_owner, *new_owner;
	Item *item;

	if (!dbus_message_get_args(msg, NULL, DBUS_TYPE_STRING, &name,
	                           DBUS_TYPE_STRING, &old_owner,
	                           DBUS_TYPE_STRING, &new_owner,
	                           DBUS_TYPE_INVALID)) {
		return DBUS_HANDLER_RESULT_HANDLED;
	}

	if (*new_owner != '\0' || *name == '\0')
		return DBUS_HANDLER_RESULT_HANDLED;

	item = item_name_to_ptr(watcher, name);
	if (!item)
		return DBUS_HANDLER_RESULT_HANDLED;

	unregister_item(watcher, item);

	return DBUS_HANDLER_RESULT_HANDLED;
}

static DBusHandlerResult
filter_bus(DBusConnection *conn, DBusMessage *msg, void *data)
{
	Watcher *watcher = data;

	if (dbus_message_is_signal(msg, DBUS_INTERFACE_DBUS,
	                           "NameOwnerChanged"))
		return handle_nameowner_changed(watcher, conn, msg);

	else
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
}

static DBusHandlerResult
respond_register_item(Watcher *watcher, DBusConnection *conn, DBusMessage *msg)
{
	DBusHandlerResult res = DBUS_HANDLER_RESULT_HANDLED;

	DBusMessage *reply = NULL;
	Item *item;
	const char *sender, *param, *busobj, *registree_name;

	if (!(sender = dbus_message_get_sender(msg)) ||
	    !dbus_message_get_args(msg, NULL, DBUS_TYPE_STRING, &param,
	                           DBUS_TYPE_INVALID)) {
		reply = dbus_message_new_error(msg, DBUS_ERROR_INVALID_ARGS,
		                               "Malformed message");
		goto send;
	}

	switch (*param) {
	case '/':
		registree_name = sender;
		busobj = param;
		break;
	case ':':
		registree_name = param;
		busobj = SNI_OPATH;
		break;
	default:
		reply = dbus_message_new_error_printf(msg,
		                                      DBUS_ERROR_INVALID_ARGS,
		                                      "Bad argument: \"%s\"",
		                                      param);
		goto send;
	}

	if (*registree_name != ':' ||
	    !dbus_validate_bus_name(registree_name, NULL)) {
		reply = dbus_message_new_error_printf(msg,
		                                      DBUS_ERROR_INVALID_ARGS,
		                                      "Invalid busname %s",
		                                      registree_name);
		goto send;
	}

	if (item_name_to_ptr(watcher, registree_name)) {
		reply = dbus_message_new_error_printf(msg,
		                                      DBUS_ERROR_INVALID_ARGS,
		                                      "%s already tracked",
		                                      registree_name);
		goto send;
	}

	item = createitem(registree_name, busobj, watcher);
	wl_list_insert(&watcher->items, &item->link);
	watcher_update_trays(watcher);

	reply = dbus_message_new_method_return(msg);

send:
	if (!reply || !dbus_connection_send(conn, reply, NULL))
		res = DBUS_HANDLER_RESULT_NEED_MEMORY;

	if (reply)
		dbus_message_unref(reply);
	return res;
}

static int
get_registered_items(const Watcher *watcher, DBusMessageIter *iter)
{
	DBusMessageIter names = DBUS_MESSAGE_ITER_INIT_CLOSED;
	Item *item;
	int r;

	if (!dbus_message_iter_open_container(iter, DBUS_TYPE_ARRAY,
	                                      DBUS_TYPE_STRING_AS_STRING,
	                                      &names)) {
		r = -ENOMEM;
		goto fail;
	}

	wl_list_for_each(item, &watcher->items, link) {
		if (!dbus_message_iter_append_basic(&names, DBUS_TYPE_STRING,
		                                    &item->busname)) {
			r = -ENOMEM;
			goto fail;
		}
	}

	dbus_message_iter_close_container(iter, &names);
	return 0;

fail:
	dbus_message_iter_abandon_container_if_open(iter, &names);
	return r;
}

static int
get_registered_items_variant(const Watcher *watcher, DBusMessageIter *iter)
{
	DBusMessageIter variant = DBUS_MESSAGE_ITER_INIT_CLOSED;
	int r;

	if (!dbus_message_iter_open_container(iter, DBUS_TYPE_VARIANT, "as",
	                                      &variant) ||
	    get_registered_items(watcher, &variant) < 0) {
		r = -ENOMEM;
		goto fail;
	}

	dbus_message_iter_close_container(iter, &variant);
	return 0;

fail:
	dbus_message_iter_abandon_container_if_open(iter, &variant);
	return r;
}

static int
get_isregistered(DBusMessageIter *iter)
{
	DBusMessageIter variant = DBUS_MESSAGE_ITER_INIT_CLOSED;
	dbus_bool_t is_registered = TRUE;
	int r;

	if (!dbus_message_iter_open_container(iter, DBUS_TYPE_VARIANT,
	                                      DBUS_TYPE_BOOLEAN_AS_STRING,
	                                      &variant) ||
	    !dbus_message_iter_append_basic(&variant, DBUS_TYPE_BOOLEAN,
	                                    &is_registered)) {
		r = -ENOMEM;
		goto fail;
	}

	dbus_message_iter_close_container(iter, &variant);
	return 0;

fail:
	dbus_message_iter_abandon_container_if_open(iter, &variant);
	return r;
}

static int
get_version(DBusMessageIter *iter)
{
	DBusMessageIter variant = DBUS_MESSAGE_ITER_INIT_CLOSED;
	dbus_int32_t protovers = 0;
	int r;

	if (!dbus_message_iter_open_container(iter, DBUS_TYPE_VARIANT,
	                                      DBUS_TYPE_INT32_AS_STRING,
	                                      &variant) ||
	    !dbus_message_iter_append_basic(&variant, DBUS_TYPE_INT32,
	                                    &protovers)) {
		r = -ENOMEM;
		goto fail;
	}

	dbus_message_iter_close_container(iter, &variant);
	return 0;

fail:
	dbus_message_iter_abandon_container_if_open(iter, &variant);
	return r;
}

static DBusHandlerResult
respond_get_prop(Watcher *watcher, DBusConnection *conn, DBusMessage *msg)
{
	DBusError err = DBUS_ERROR_INIT;
	DBusMessage *reply = NULL;
	DBusMessageIter iter = DBUS_MESSAGE_ITER_INIT_CLOSED;
	const char *iface, *prop;

	if (!dbus_message_get_args(msg, &err, DBUS_TYPE_STRING, &iface,
	                           DBUS_TYPE_STRING, &prop,
	                           DBUS_TYPE_INVALID)) {
		reply = dbus_message_new_error(msg, err.name, err.message);
		dbus_error_free(&err);
		goto send;
	}

	if (strcmp(iface, SNW_IFACE) != 0) {
		reply = dbus_message_new_error_printf(
			msg, DBUS_ERROR_UNKNOWN_INTERFACE,
			"Unknown interface \"%s\"", iface);
		goto send;
	}

	reply = dbus_message_new_method_return(msg);
	if (!reply)
		goto fail;

	if (strcmp(prop, "ProtocolVersion") == 0) {
		dbus_message_iter_init_append(reply, &iter);
		if (get_version(&iter) < 0)
			goto fail;

	} else if (strcmp(prop, "IsStatusNotifierHostRegistered") == 0) {
		dbus_message_iter_init_append(reply, &iter);
		if (get_isregistered(&iter) < 0)
			goto fail;

	} else if (strcmp(prop, "RegisteredStatusNotifierItems") == 0) {
		dbus_message_iter_init_append(reply, &iter);
		if (get_registered_items_variant(watcher, &iter) < 0)
			goto fail;

	} else {
		dbus_message_unref(reply);
		reply = dbus_message_new_error_printf(
			reply, DBUS_ERROR_UNKNOWN_PROPERTY,
			"Property \"%s\" does not exist", prop);
	}

send:
	if (!reply || !dbus_connection_send(conn, reply, NULL))
		goto fail;

	if (reply)
		dbus_message_unref(reply);
	return DBUS_HANDLER_RESULT_HANDLED;

fail:
	if (reply)
		dbus_message_unref(reply);
	return DBUS_HANDLER_RESULT_NEED_MEMORY;
}

static DBusHandlerResult
respond_all_props(Watcher *watcher, DBusConnection *conn, DBusMessage *msg)
{
	DBusMessage *reply = NULL;
	DBusMessageIter array = DBUS_MESSAGE_ITER_INIT_CLOSED;
	DBusMessageIter dict = DBUS_MESSAGE_ITER_INIT_CLOSED;
	DBusMessageIter iter = DBUS_MESSAGE_ITER_INIT_CLOSED;
	const char *prop;

	reply = dbus_message_new_method_return(msg);
	if (!reply)
		goto fail;
	dbus_message_iter_init_append(reply, &iter);

	if (!dbus_message_iter_open_container(&iter, DBUS_TYPE_ARRAY, "{sv}",
	                                      &array))
		goto fail;

	prop = "ProtocolVersion";
	if (!dbus_message_iter_open_container(&array, DBUS_TYPE_DICT_ENTRY,
	                                      NULL, &dict) ||
	    !dbus_message_iter_append_basic(&dict, DBUS_TYPE_STRING, &prop) ||
	    get_version(&dict) < 0 ||
	    !dbus_message_iter_close_container(&array, &dict)) {
		goto fail;
	}

	prop = "IsStatusNotifierHostRegistered";
	if (!dbus_message_iter_open_container(&array, DBUS_TYPE_DICT_ENTRY,
	                                      NULL, &dict) ||
	    !dbus_message_iter_append_basic(&dict, DBUS_TYPE_STRING, &prop) ||
	    get_isregistered(&dict) < 0 ||
	    !dbus_message_iter_close_container(&array, &dict)) {
		goto fail;
	}

	prop = "RegisteredStatusNotifierItems";
	if (!dbus_message_iter_open_container(&array, DBUS_TYPE_DICT_ENTRY,
	                                      NULL, &dict) ||
	    !dbus_message_iter_append_basic(&dict, DBUS_TYPE_STRING, &prop) ||
	    get_registered_items_variant(watcher, &dict) < 0 ||
	    !dbus_message_iter_close_container(&array, &dict)) {
		goto fail;
	}

	if (!dbus_message_iter_close_container(&iter, &array) ||
	    !dbus_connection_send(conn, reply, NULL)) {
		goto fail;
	}

	dbus_message_unref(reply);
	return DBUS_HANDLER_RESULT_HANDLED;

fail:
	dbus_message_iter_abandon_container_if_open(&array, &dict);
	dbus_message_iter_abandon_container_if_open(&iter, &array);
	if (reply)
		dbus_message_unref(reply);
	return DBUS_HANDLER_RESULT_NEED_MEMORY;
}

static DBusHandlerResult
respond_introspect(DBusConnection *conn, DBusMessage *msg)
{
	DBusMessage *reply = NULL;

	reply = dbus_message_new_method_return(msg);
	if (!reply)
		goto fail;

	if (!dbus_message_append_args(reply, DBUS_TYPE_STRING, &snw_xml,
	                              DBUS_TYPE_INVALID) ||
	    !dbus_connection_send(conn, reply, NULL)) {
		goto fail;
	}

	dbus_message_unref(reply);
	return DBUS_HANDLER_RESULT_HANDLED;

fail:
	if (reply)
		dbus_message_unref(reply);
	return DBUS_HANDLER_RESULT_NEED_MEMORY;
}

static DBusHandlerResult
snw_message_handler(DBusConnection *conn, DBusMessage *msg, void *data)
{
	Watcher *watcher = data;

	if (dbus_message_is_method_call(msg, DBUS_INTERFACE_INTROSPECTABLE,
	                                "Introspect"))
		return respond_introspect(conn, msg);

	else if (dbus_message_is_method_call(msg, DBUS_INTERFACE_PROPERTIES,
	                                     "GetAll"))
		return respond_all_props(watcher, conn, msg);

	else if (dbus_message_is_method_call(msg, DBUS_INTERFACE_PROPERTIES,
	                                     "Get"))
		return respond_get_prop(watcher, conn, msg);

	else if (dbus_message_is_method_call(msg, SNW_IFACE,
	                                     "RegisterStatusNotifierItem"))
		return respond_register_item(watcher, conn, msg);

	else
		return DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
}

static const DBusObjectPathVTable snw_vtable = { .message_function =
	                                                 snw_message_handler };

void
watcher_start(Watcher *watcher, DBusConnection *conn,
              struct wl_event_loop *loop)
{
	DBusError err = DBUS_ERROR_INIT;
	int r, flags;

	wl_list_init(&watcher->items);
	wl_list_init(&watcher->trays);
	watcher->conn = conn;
	watcher->loop = loop;

	flags = DBUS_NAME_FLAG_REPLACE_EXISTING | DBUS_NAME_FLAG_DO_NOT_QUEUE;
	r = dbus_bus_request_name(conn, SNW_NAME,
	                          flags, NULL);
	if (r != DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER)
		goto fail;

	if (!dbus_connection_add_filter(conn, filter_bus, watcher, NULL)) {
		dbus_bus_release_name(conn, SNW_NAME, NULL);
		goto fail;
	}

	dbus_bus_add_match(conn, match_rule, &err);
	if (dbus_error_is_set(&err)) {
		dbus_connection_remove_filter(conn, filter_bus, watcher);
		dbus_bus_release_name(conn, SNW_NAME, NULL);
		goto fail;
	}

	if (!dbus_connection_register_object_path(conn, SNW_OPATH, &snw_vtable,
	                                          watcher)) {
		dbus_bus_remove_match(conn, match_rule, NULL);
		dbus_connection_remove_filter(conn, filter_bus, watcher);
		dbus_bus_release_name(conn, SNW_NAME, NULL);
		goto fail;
	}

	watcher->running = 1;
	return;

fail:
	fprintf(stderr, "Couldn't start watcher, systray not available\n");
	dbus_error_free(&err);
	return;
}

void
watcher_stop(Watcher *watcher)
{
	dbus_connection_unregister_object_path(watcher->conn, SNW_OPATH);
	dbus_bus_remove_match(watcher->conn, match_rule, NULL);
	dbus_connection_remove_filter(watcher->conn, filter_bus, watcher);
	dbus_bus_release_name(watcher->conn, SNW_NAME, NULL);
	watcher->running = 0;
}

int
watcher_get_n_items(const Watcher *watcher)
{
	return wl_list_length(&watcher->items);
}

void
watcher_update_trays(Watcher *watcher)
{
	Tray *tray;

	wl_list_for_each(tray, &watcher->trays, link)
		tray_update(tray);
}
