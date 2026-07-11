{...}: {
  xdg.configFile."alacritty/alacritty.toml".source =
    ./alacritty.toml;

  xdg.configFile."alacritty/theme.toml".source =
    ./theme.toml;
}
