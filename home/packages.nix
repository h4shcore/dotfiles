{pkgs, ...}: {
  home.packages = with pkgs; [
    neovim
    yazi
    fastfetch
    alacritty
    ripgrep
    fuzzel
    playerctl
    brightnessctl
    spotify
    vesktop
    pavucontrol
    firefox
    fish
    starship
    yazi
    kitty
    foot
    eza
    qbittorrent
  ];
}
