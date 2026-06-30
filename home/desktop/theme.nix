{pkgs, ...}: {
  gtk = {
    enable = true;

    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3-dark";
    };

    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = 20;
    };

    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
  };

  xdg.configFile."gtk-3.0/gtk.css".source = ./gtk/gtk.css;
  xdg.configFile."gtk-4.0/gtk.css".source = ./gtk/gtk.css;
}
