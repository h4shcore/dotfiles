{ theme }:

let
  c = theme.colors;
in
''
[global]
mouse_left_click = do_action
mouse_middle_click = close_all
mouse_right_click = close_current

frame_color = "${c.accent}"
frame_width = 2
separator_color = frame
highlight = "${c.accent}"

font = Iosevka Nerd Font 10
origin = bottom-right
shrink = true
word_wrap = yes
padding = 10
horizontal_padding = 10
show_indicators = no
offset = (10, 10)

[urgency_low]
background = "${c.background}"
foreground = "${c.foreground}"
frame_color = "${c.brightBlack}"
highlight = "${c.green}"
timeout = 3

[urgency_normal]
background = "${c.background}"
foreground = "${c.foreground}"
frame_color = "${c.accent}"
highlight = "${c.accent}"
timeout = 3

[urgency_critical]
background = "${c.red}"
foreground = "${c.foreground}"
frame_color = "${c.red}"
highlight = "${c.red}"
timeout = 0
''
