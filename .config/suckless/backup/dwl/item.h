#ifndef ITEM_H
#define ITEM_H

#include "icon.h"
#include "watcher.h"

#include <wayland-util.h>

/*
 * The FDO spec says "org.freedesktop.StatusNotifierItem"[1],
 * but both the client libraries[2,3] actually use "org.kde.StatusNotifierItem"
 *
 * [1] https://www.freedesktop.org/wiki/Specifications/StatusNotifierItem/
 * [2] https://github.com/AyatanaIndicators/libayatana-appindicator-glib
 * [3] https://invent.kde.org/frameworks/kstatusnotifieritem
 *
 */
#define SNI_NAME "org.kde.StatusNotifierItem"
#define SNI_OPATH "/StatusNotifierItem"
#define SNI_IFACE "org.kde.StatusNotifierItem"

typedef struct Item {
	struct wl_list icons;
	char *busname;
	char *busobj;
	char *menu_busobj;
	char *appid;
	Icon *icon;
	FallbackIcon *fallback_icon;

	Watcher *watcher;

	int fgcolor;

	int ready;

	struct wl_list link;
} Item;

Item *createitem (const char *busname, const char *busobj, Watcher *watcher);
void destroyitem (Item *item);

void item_activate (Item *item);
void item_show_menu (Item *item);

#endif /* ITEM_H */
