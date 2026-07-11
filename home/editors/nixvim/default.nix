{ inputs, ... }:

{
  imports = [
    inputs.nixvim.homeModules.nixvim

    ./options.nix
    ./keymaps.nix
    ./colorscheme.nix
    ./plugins
  ];

  programs.nixvim.enable = true;
}
