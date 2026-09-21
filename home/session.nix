{...}: {
  home.sessionVariables = {
    EDITOR = "hx";
    TERMINAL = "foot";
  };
  services.udiskie = {
    enable = true;
    tray = "auto";
  };
}
