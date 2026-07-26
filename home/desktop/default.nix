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

    ./fuzzel
    ./niri
  ];

  # xdg.configFile."niri".source = ./niri;
  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
}
