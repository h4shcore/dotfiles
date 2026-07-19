{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.osu-lazer-bin
  ];
}
