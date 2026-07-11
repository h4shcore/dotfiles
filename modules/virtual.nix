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

  virtualisation.libvirtd.enable = true;

  programs.virt-manager.enable = true;

  users.groups.libvirtd.members = ["daksh"];
}
