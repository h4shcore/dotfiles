#include "helpers.h"

#include <dbus/dbus.h>

#include <errno.h>
#include <stddef.h>

// IWYU pragma: no_include "dbus/dbus-protocol.h"
// IWYU pragma: no_include "dbus/dbus-shared.h"

int
request_property(DBusConnection *conn, const char *busname, const char *busobj,
                 const char *prop, const char *iface, PropHandler handler,
                 void *data)
{
	DBusMessage *msg = NULL;
	DBusPendingCall *pending = NULL;
	int r;

	if (!(msg = dbus_message_new_method_call(busname, busobj,
	                                         DBUS_INTERFACE_PROPERTIES,
	                                         "Get")) ||
	    !dbus_message_append_args(msg, DBUS_TYPE_STRING, &iface,
	                              DBUS_TYPE_STRING, &prop,
	                              DBUS_TYPE_INVALID) ||
	    !dbus_connection_send_with_reply(conn, msg, &pending, -1) ||
	    !dbus_pending_call_set_notify(pending, handler, data, NULL)) {
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
	if (msg)
		dbus_message_unref(msg);
	return r;
}
