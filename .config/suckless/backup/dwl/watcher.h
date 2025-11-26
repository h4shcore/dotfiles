#ifndef WATCHER_H
#define WATCHER_H

#include <dbus/dbus.h>
#include <wayland-server-core.h>
#include <wayland-util.h>

/*
 * The FDO spec says "org.freedesktop.StatusNotifierWatcher"[1],
 * but both the client libraries[2,3] actually use "org.kde.StatusNotifierWatcher"
 *
 * [1] https://www.freedesktop.org/wiki/Specifications/StatusNotifierItem/
 * [2] https://github.com/AyatanaIndicators/libayatana-appindicator-glib
 * [3] https://invent.kde.org/frameworks/kstatusnotifieritem
 */
#define SNW_NAME "org.kde.StatusNotifierWatcher"
#define SNW_OPATH "/StatusNotifierWatcher"
#define SNW_IFACE "org.kde.StatusNotifierWatcher"

typedef struct {
	struct wl_list items;
	struct wl_list trays;
	struct wl_event_loop *loop;
	DBusConnection *conn;
	int running;
} Watcher;

void watcher_start (Watcher *watcher, DBusConnection *conn,
                   struct wl_event_loop *loop);
void watcher_stop (Watcher *watcher);

int watcher_get_n_items (const Watcher *watcher);
void watcher_update_trays (Watcher *watcher);

#endif /* WATCHER_H */
