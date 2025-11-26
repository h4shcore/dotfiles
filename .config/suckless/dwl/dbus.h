#ifndef DWLDBUS_H
#define DWLDBUS_H

#include <dbus/dbus.h>
#include <wayland-server-core.h>

struct wl_event_source* startbus (DBusConnection *conn, struct wl_event_loop *loop);
void stopbus (DBusConnection *conn, struct wl_event_source *bus_source);

#endif /* DWLDBUS_H */
