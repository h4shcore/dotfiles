{pkgs, ...}: {
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = [
        "Mononoki Nerd Font"
      ];

      sansSerif = [
        "Mononoki Nerd Font"
      ];

      serif = [
        "Mononoki Nerd Font"
      ];

      emoji = [
        "Noto Color Emoji"
      ];
    };
  };

  home.packages = with pkgs; [
    nerd-fonts.mononoki
    noto-fonts-color-emoji
  ];
}
