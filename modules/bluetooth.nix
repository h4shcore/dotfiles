{...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;

    settings = {
      General = {
        Experimental = true; # Battery level, newer features
        FastConnectable = true;
      };

      Policy = {
        AutoEnable = true;
      };
    };
  };

  services.blueman.enable = true; # GUI Bluetooth manager
}
