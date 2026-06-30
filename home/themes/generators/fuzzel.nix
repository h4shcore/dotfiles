{ theme }:

let
  c = theme.colors;
in
''
[colors]
background=${c.background}ff
text=${c.foreground}ff
match=${c.accent}ff
selection=${c.accent}ff
selection-text=${c.foreground}ff
selection-match=${c.background}ff
border=${c.brightBlack}ff
''
