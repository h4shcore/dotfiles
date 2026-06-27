{...}: {
  services = {
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
}
