{ ... }:

let
  theme = import ../../themes;

  generatedTheme = import ../../themes/generators/dunst.nix {
    inherit theme;
  };
in {
  xdg.configFile."dunst/dunstrc".source = ./dunstrc;

  xdg.configFile."dunst/colors.conf".text = generatedTheme;
}
