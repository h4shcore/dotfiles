{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    qemu
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    swtpm
    dnsmasq
    bridge-utils
    edk2
  ];

  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
  programs.virt-manager.enable = true;
}
