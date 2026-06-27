{pkgs, ...}: {
  home.username = "daksh";
  home.homeDirectory = "/home/daksh";

  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./git
    ./terminal
    ./desktop
  ];

  home.stateVersion = "26.05";
}
