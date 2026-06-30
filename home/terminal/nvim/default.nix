{...}: let
  theme = import ../../themes;
in {
  xdg.configFile."nvim/lua/palette.lua".text = import ../../themes/generators/nvim {
    inherit theme;
  };
}
