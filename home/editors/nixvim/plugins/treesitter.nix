{
  programs.nixvim.plugins.treesitter = {
    enable = true;

    settings = {
      highlight.enable = true;
      indent.enable = true;

      ensureInstalled = [
        "bash"
        "c"
        "cpp"
        "css"
        "diff"
        "dockerfile"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "go"
        "html"
        "javascript"
        "json"
        "lua"
        "markdown"
        "markdown_inline"
        "nix"
        "python"
        "regex"
        "rust"
        "toml"
        "vim"
        "vimdoc"
        "yaml"
      ];
    };
  };
}
