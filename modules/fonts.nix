{pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.iosevka
    font-awesome
  ];
}
