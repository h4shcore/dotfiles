{config, ...}: {
  programs.nixvim.plugins.treesitter = {
    enable = true;

    grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
      bash
      c
      cpp
      diff
      git_config
      git_rebase
      gitattributes
      gitcommit
      gitignore
      json
      lua
      markdown
      markdown_inline
      nix
      regex
      rust
      toml
      vim
      vimdoc
      yaml
    ];

    settings = {
      highlight.enable = true;
      indent.enable = true;
    };
  };
}
