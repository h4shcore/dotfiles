{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    luarocks
    spotify
    vesktop
    firefox
    qbittorrent
  ];
}
