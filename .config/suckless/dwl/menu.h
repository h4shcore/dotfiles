#ifndef MENU_H
#define MENU_H

#include <dbus/dbus.h>
#include <wayland-server-core.h>

/* The menu is built on demand and not kept around */
void menu_show (DBusConnection *conn, struct wl_event_loop *loop,
                const char *busname, const char *busobj, const char **menucmd);

#endif /* MENU_H */
