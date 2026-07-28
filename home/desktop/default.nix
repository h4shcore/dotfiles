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
    pywalfox-native
  ];

  imports = [
    ./theme.nix

    ./fuzzel
    ./niri
  ];

  xdg.configFile."waybar/config.jsonc".source = ./waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ./waybar/style.css;
  xdg.configFile."matugen".source = ./matugen;
}
