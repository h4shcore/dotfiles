{pkgs, ...}: {
  home.username = "daksh";
  home.homeDirectory = "/home/daksh";

  programs.home-manager.enable = true;

  imports = [
    ./packages.nix
    ./git
    ./terminal
    ./desktop
    ./fonts
  ];

  home.stateVersion = "26.05";
}
