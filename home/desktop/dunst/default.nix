{...}: let
  theme = import ../../themes;

  generatedDunst = import ../../themes/generators/dunst.nix {
    inherit theme;
  };
in {
  xdg.configFile."dunst/dunstrc".text = generatedDunst;
}
