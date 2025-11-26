#ifndef HELPERS_H
#define HELPERS_H

#include <dbus/dbus.h>

typedef void (*PropHandler)(DBusPendingCall *pcall, void *data);

int request_property (DBusConnection *conn, const char *busname,
                      const char *busobj, const char *prop, const char *iface,
                      PropHandler handler, void *data);

#endif /* HELPERS_H */
