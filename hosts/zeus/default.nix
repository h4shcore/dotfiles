{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/desktop.nix
    ../../modules/gaming.nix
    ../../modules/graphics.nix
    ../../modules/locale.nix
    ../../modules/nh.nix
    ../../modules/packages.nix
    ../../modules/services.nix
    ../../modules/users.nix
    ../../modules/virtual.nix
  ];

  # Enable experimental features
  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "26.05"; # Did you read the comment?
}
