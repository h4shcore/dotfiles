{ ... }:

let
  theme = import ../../themes;

  generatedTheme = import ../../themes/generators/yazi.nix {
    inherit theme;
  };
in {
  xdg.configFile."yazi/init.lua".source = ./init.lua;
  xdg.configFile."yazi/yazi.toml".source = ./yazi.toml;
  xdg.configFile."yazi/plugins".source = ./plugins;
  xdg.configFile."yazi/theme.toml".text = generatedTheme;
}
