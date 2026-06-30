let
  theme = import ../../themes;
  generatedTheme = import ../../themes/generators/fuzzel.nix {
    inherit theme;
  };
in {
  xdg.configFile."fuzzel/fuzzel.ini".source = ./fuzzel.ini;
  xdg.configFile."fuzzel/theme.ini".text = generatedTheme;
}
