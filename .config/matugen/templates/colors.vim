" Special
let background="{{ colors.background.default.hex }}"
let foreground="{{ colors.on_surface.default.hex }}"
let cursor="{{ colors.inverse_surface.default.hex }}"

" Colors
let color0  = "{{ colors.surface.default.hex }}"
let color1  = "{{ colors.error.default.hex }}"
let color2  = "{{ colors.primary.default.hex }}"
let color3  = "{{ colors.tertiary.default.hex }}"
let color4  = "{{ colors.on_primary_container.default.hex }}"
let color5  = "{{ colors.on_secondary_container.default.hex }}"
let color6  = "{{ colors.secondary.default.hex }}"
let color7  = "{{ colors.on_surface.default.hex }}"
let color8  = "{{ colors.surface_bright.default.hex }}"
let color9  = "{{ colors.error.default.hex }}"
let color10 = "{{ colors.primary.default.hex }}"
let color11 = "{{ colors.tertiary.default.hex }}"
let color12 = "{{ colors.on_primary_container.default.hex }}"
let color13 = "{{ colors.on_secondary_container.default.hex }}"
let color14 = "{{ colors.secondary.default.hex }}"
let color15 = "{{ colors.on_surface.default.hex }}"

" Apply as a colorscheme
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "matugen"

" Set terminal colors
let g:terminal_color_0  = color0
let g:terminal_color_1  = color1
let g:terminal_color_2  = color2
let g:terminal_color_3  = color3
let g:terminal_color_4  = color4
let g:terminal_color_5  = color5
let g:terminal_color_6  = color6
let g:terminal_color_7  = color7
let g:terminal_color_8  = color8
let g:terminal_color_9  = color9
let g:terminal_color_10 = color10
let g:terminal_color_11 = color11
let g:terminal_color_12 = color12
let g:terminal_color_13 = color13
let g:terminal_color_14 = color14
let g:terminal_color_15 = color15

" Basic highlight groups
"hi Normal       guifg={{ colors.on_surface.default.hex }} guibg={{ colors.background.default.hex }}
"hi Cursor       guifg={{ colors.background.default.hex }} guibg={{ colors.inverse_surface.default.hex }}
"hi LineNr       guifg={{ colors.surface_bright.default.hex }} guibg={{ colors.background.default.hex }}
"hi CursorLineNr guifg={{ colors.on_secondary_container.default.hex }} guibg={{ colors.background.default.hex }}
"hi Comment      guifg={{ colors.secondary.default.hex }} cterm=italic
"hi String       guifg={{ colors.primary.default.hex }}
"hi Keyword      guifg={{ colors.error.default.hex }}
"hi Function     guifg={{ colors.on_secondary_container.default.hex }}
"hi Type         guifg={{ colors.tertiary.default.hex }}
"hi Visual       guibg={{ colors.surface_bright.default.hex }}


" Basic highlight groups
hi Normal       guifg={{ colors.on_surface.default.hex }} guibg=NONE
hi Cursor       guifg={{ colors.background.default.hex }} guibg=NONE
hi LineNr       guifg={{ colors.surface_bright.default.hex }} guibg=NONE
hi CursorLineNr guifg={{ colors.on_secondary_container.default.hex }} guibg=NONE
hi Comment      guifg={{ colors.secondary.default.hex }} cterm=italic guibg=NONE
hi String       guifg={{ colors.primary.default.hex }} guibg=NONE
hi Keyword      guifg={{ colors.error.default.hex }} guibg=NONE
hi Function     guifg={{ colors.on_secondary_container.default.hex }} guibg=NONE
hi Type         guifg={{ colors.tertiary.default.hex }} guibg=NONE
hi Visual       guibg=NONE
