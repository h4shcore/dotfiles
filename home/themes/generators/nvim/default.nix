{ theme }:

let
  c = theme.colors;
in
''
return {
  background = "${c.background}",
  foreground = "${c.foreground}",

  accent = "${c.accent}",

  black = "${c.black}",
  red = "${c.red}",
  green = "${c.green}",
  yellow = "${c.yellow}",
  blue = "${c.blue}",
  magenta = "${c.magenta}",
  cyan = "${c.cyan}",
  white = "${c.white}",

  brightBlack = "${c.brightBlack}",
  brightRed = "${c.brightRed}",
  brightGreen = "${c.brightGreen}",
  brightYellow = "${c.brightYellow}",
  brightBlue = "${c.brightBlue}",
  brightMagenta = "${c.brightMagenta}",
  brightCyan = "${c.brightCyan}",
  brightWhite = "${c.brightWhite}",
}
''
