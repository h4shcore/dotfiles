import ./ryu

xdg.configFile."nvim/lua/palette.lua".text =
  import ../themes/generators/nvim.nix {
    inherit theme;
  };
