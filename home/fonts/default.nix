{ pkgs, ... }:

{
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = [
        "Iosevka Nerd Font"
      ];

      sansSerif = [
        "Iosevka Nerd Font"
      ];

      serif = [
        "Iosevka Nerd Font"
      ];

      emoji = [
        "Noto Color Emoji"
      ];
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.iosevka
    noto-fonts-color-emoji
  ];
}
