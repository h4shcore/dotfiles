{pkgs, ...}: {
  home.packages = with pkgs; [
    awww
    dunst
    fuzzel
    waybar
    cliphist
    wl-clipboard
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
