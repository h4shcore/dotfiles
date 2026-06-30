{ ... }:

let
  theme = import ../../themes;
  generatedTheme = import ../../themes/generators/alacritty.nix {
    inherit theme;
  };
in
{
  xdg.configFile."alacritty/alacritty.toml".source =
    ./alacritty.toml;

  xdg.configFile."alacritty/theme.toml".text =
    generatedTheme;
}
