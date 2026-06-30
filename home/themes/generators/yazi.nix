{ theme }:

let
  c = theme.colors;
in
''
[mgr]
cwd = { fg = "${c.foreground}" }

hovered = { fg = "${c.background}", bg = "${c.brightRed}" }
preview_hovered = { fg = "${c.background}", bg = "${c.brightRed}" }

find_keyword = { fg = "${c.brightRed}", bold = true }
find_position = { fg = "${c.yellow}", bold = true }

marker_copied = { fg = "${c.green}", bg = "${c.green}" }
marker_cut = { fg = "${c.red}", bg = "${c.red}" }
marker_marked = { fg = "${c.blue}", bg = "${c.blue}" }
marker_selected = { fg = "${c.magenta}", bg = "${c.magenta}" }

count_copied = { fg = "${c.background}", bg = "${c.green}" }
count_cut = { fg = "${c.background}", bg = "${c.red}" }
count_selected = { fg = "${c.background}", bg = "${c.blue}" }

border_symbol = "│"
border_style = { fg = "${c.brightBlack}" }

[status]
separator_open = ""
separator_close = ""

mode_normal = { fg = "${c.background}", bg = "${c.green}", bold = true }
mode_select = { fg = "${c.background}", bg = "${c.yellow}", bold = true }
mode_unset = { fg = "${c.background}", bg = "${c.red}", bold = true }

progress_label = { fg = "${c.foreground}", bold = true }
progress_normal = { fg = "${c.green}", bg = "${c.brightBlack}" }
progress_error = { fg = "${c.red}", bg = "${c.brightBlack}" }

[which]
cols = 3
mask = { bg = "${c.background}" }
cand = { fg = "${c.blue}" }
rest = { fg = "${c.foreground}" }
desc = { fg = "${c.yellow}" }
separator = " → "
separator_style = { fg = "${c.brightBlack}" }

[confirm]
border = { fg = "${c.brightBlack}" }
title = { fg = "${c.yellow}" }
content = { fg = "${c.foreground}" }
list = { fg = "${c.blue}" }
btn_yes = { fg = "${c.background}", bg = "${c.green}" }
btn_no = { fg = "${c.background}", bg = "${c.red}" }

[input]
border = { fg = "${c.brightBlack}" }
title = { fg = "${c.yellow}" }
value = { fg = "${c.foreground}" }
selected = { fg = "${c.background}", bg = "${c.brightRed}" }

[select]
border = { fg = "${c.brightBlack}" }
active = { fg = "${c.brightRed}", bold = true }
inactive = { fg = "${c.foreground}" }

[tasks]
border = { fg = "${c.brightBlack}" }
title = { fg = "${c.yellow}" }
hovered = { fg = "${c.background}", bg = "${c.brightRed}" }

[help]
border = { fg = "${c.brightBlack}" }
title = { fg = "${c.yellow}" }
value = { fg = "${c.foreground}" }
on = { fg = "${c.green}" }
run = { fg = "${c.blue}" }
desc = { fg = "${c.foreground}" }
hovered = { bg = "${c.brightBlack}" }

[filetype]
rules = [
    { mime = "image/*", fg = "${c.magenta}" },
    { mime = "video/*", fg = "${c.yellow}" },
    { mime = "audio/*", fg = "${c.cyan}" },
    { mime = "application/zip", fg = "${c.red}" },
    { mime = "application/*", fg = "${c.blue}" },
    { name = "*/", fg = "${c.green}" },
]
''
