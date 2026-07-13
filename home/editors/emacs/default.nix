{ pkgs, ... }:

{
  imports = [
    ./packages.nix
  ];

  programs.emacs = {
    enable = true;
    package = pkgs.emacs30-pgtk;
  };

  xdg.configFile."emacs/init.el".source = ./init.el;
  xdg.configFile."emacs/early-init.el".source = ./early-init.el;
  xdg.configFile."emacs/config".source = ./config;
}
