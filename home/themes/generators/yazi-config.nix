{ theme }:

''
[flavor]
dark = "${theme.name}"
light = "${theme.name}"

[[plugin.prepend_fetchers]]
id = "git"
url = "*"
run = "git"
group = "git"

[[plugin.prepend_fetchers]]
id = "git"
url = "*/"
run = "git"
group = "git"
''
