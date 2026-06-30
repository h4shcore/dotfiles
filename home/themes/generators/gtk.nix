{ theme }:

let
  c = theme.colors;
in
''
@define-color background ${c.background};
@define-color foreground ${c.foreground};

@define-color black ${c.black};
@define-color red ${c.red};
@define-color green ${c.green};
@define-color yellow ${c.yellow};
@define-color blue ${c.blue};
@define-color magenta ${c.magenta};
@define-color cyan ${c.cyan};
@define-color white ${c.white};

@define-color bright_black ${c.brightBlack};
@define-color bright_red ${c.brightRed};
@define-color bright_green ${c.brightGreen};
@define-color bright_yellow ${c.brightYellow};
@define-color bright_blue ${c.brightBlue};
@define-color bright_magenta ${c.brightMagenta};
@define-color bright_cyan ${c.brightCyan};
@define-color bright_white ${c.brightWhite};

@define-color accent_bg_color @blue;
@define-color accent_fg_color @background;
@define-color accent_color @cyan;

@define-color window_bg_color @background;
@define-color window_fg_color @foreground;

@define-color view_bg_color @black;
@define-color view_fg_color @foreground;

@define-color sidebar_bg_color @black;
@define-color sidebar_fg_color @foreground;

@define-color headerbar_bg_color @background;
@define-color headerbar_fg_color @foreground;

@define-color card_bg_color @background;
@define-color card_fg_color @foreground;

@define-color popover_bg_color @black;
@define-color popover_fg_color @foreground;

@define-color dialog_bg_color @background;
@define-color dialog_fg_color @foreground;

@define-color borders alpha(@foreground, 0.1);
''
