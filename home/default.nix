{pkgs, ...}: {
  home.username = "daksh";
  home.homeDirectory = "/home/daksh";

  programs.home-manager.enable = true;

  imports = [
    ./desktop
    ./editors
    ./fonts
    ./git
    ./terminal
    ./gaming

    ./packages.nix
    ./session.nix
  ];

  home.stateVersion = "26.05";
}
