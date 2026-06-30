{...}: let
  theme = import ../../themes;

  generatedTheme = import ../../themes/generators/niri.nix {
    inherit theme;
  };
in {
  xdg.configFile."niri/config.kdl".source = ./config.kdl;
  xdg.configFile."niri/colors.kdl".text = generatedTheme;
}
