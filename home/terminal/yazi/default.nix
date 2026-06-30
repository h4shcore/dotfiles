{ ... }:

let
  theme = import ../../themes;

  generatedConfig = import ../../themes/generators/yazi-config.nix {
    inherit theme;
  };

  generatedFlavor = import ../../themes/generators/yazi-flavor.nix {
    inherit theme;
  };
in {
  xdg.configFile."yazi/init.lua".source = ./init.lua;

  xdg.configFile."yazi/plugins".source = ./plugins;

  xdg.configFile."yazi/yazi.toml".text = generatedConfig;

  xdg.configFile."yazi/flavors/${theme.name}.yazi/flavor.toml".text =
    generatedFlavor;
}
