{ pkgs }:

{
  compile-mode = import ./compile-mode.nix { inherit pkgs; };
}
