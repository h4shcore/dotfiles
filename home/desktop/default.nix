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
    ./matugen
    ./niri
  ];

  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
}
