{ theme }:
let
  c = theme.colors;
in
''
[colors.primary]
background = "${c.background}"
foreground = "${c.foreground}"

[colors.cursor]
text = "${c.background}"
cursor = "${c.cursor}"

[colors.selection]
text = "${c.selectionForeground}"
background = "${c.selectionBackground}"

[colors.normal]
black = "${c.black}"
red = "${c.red}"
green = "${c.green}"
yellow = "${c.yellow}"
blue = "${c.blue}"
magenta = "${c.magenta}"
cyan = "${c.cyan}"
white = "${c.white}"

[colors.bright]
black = "${c.brightBlack}"
red = "${c.brightRed}"
green = "${c.brightGreen}"
yellow = "${c.brightYellow}"
blue = "${c.brightBlue}"
magenta = "${c.brightMagenta}"
cyan = "${c.brightCyan}"
white = "${c.brightWhite}"
''
