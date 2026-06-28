{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    spotify
    vesktop
    firefox
    qbittorrent
  ];
}
