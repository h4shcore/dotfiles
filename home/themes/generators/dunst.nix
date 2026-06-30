{ theme }:

let
  c = theme.colors;
in
''
[urgency_low]
background = "${c.background}"
foreground = "${c.foreground}"
frame_color = "${c.brightBlack}"
highlight = "${c.green}"

[urgency_normal]
background = "${c.background}"
foreground = "${c.foreground}"
frame_color = "${c.accent}"
highlight = "${c.accent}"

[urgency_critical]
background = "${c.background}"
foreground = "${c.foreground}"
frame_color = "${c.red}"
highlight = "${c.red}"
''
