{pkgs, ...}: {
  home.packages = with pkgs; [
    awww
    playerctl
    brightnessctl
    dunst
    fuzzel
    waybar
    cliphist
    wl-clipboard
    pavucontrol
    xwayland-satellite
  ];

  imports = [
    ./theme.nix
  ];

  xdg.configFile."niri".source = ./niri;
  xdg.configFile."waybar".source = ./waybar;
  xdg.configFile."fuzzel".source = ./fuzzel;
  xdg.configFile."dunst".source = ./dunst;
}
