{ config, ... }:

let
  theme = import ../../themes;
  themeToml = import ../../themes/generators/alacritty.nix {
    inherit theme;
  };
in
{
  xdg.configFile."alacritty/theme.toml".text = themeToml;
}
