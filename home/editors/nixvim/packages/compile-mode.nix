{ pkgs }:

pkgs.vimUtils.buildVimPlugin {
  pname = "compile-mode.nvim";
  version = "unstable";

  src = pkgs.fetchFromGitHub {
    owner = "ej-shafran";
    repo = "compile-mode.nvim";
  };
}
