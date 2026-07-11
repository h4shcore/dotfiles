{pkgs, ...}: {
  home.packages = with pkgs; [
    spotify
    vesktop
    firefox
    qbittorrent
  ];
}
