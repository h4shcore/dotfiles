#ifndef ICON_H
#define ICON_H

#include <fcft/fcft.h>
#include <pixman.h>

#include <stddef.h>
#include <stdint.h>

typedef const struct fcft_glyph FallbackIcon;

typedef struct {
	pixman_image_t *img;
	uint32_t *buf_pixman;
	uint8_t *buf_orig;
	size_t size_orig;
	size_t size_pixman;
} Icon;

Icon *createicon (const uint8_t *buf, int width, int height, int size);
FallbackIcon *createfallbackicon (const char *appname, int fgcolor,
                                  struct fcft_font *font);
void destroyicon (Icon *icon);
int resize_image (pixman_image_t *orig, int new_width, int new_height);

#endif /* ICON_H */
