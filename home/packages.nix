{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
    vesktop
    firefox
    brave
    qbittorrent
  ];
}
