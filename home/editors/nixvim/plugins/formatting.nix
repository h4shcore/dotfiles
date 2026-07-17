{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra # Nix
    clang-tools # C/C++ (provides clang-format)
    rustfmt # Rust
    stylua # Lua
    prettier # JSON, YAML, Markdown
    shfmt # Shell/Bash
  ];

  programs.nixvim.plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;

      format_on_save = {
        timeout_ms = 500;
        lsp_format = "fallback";
      };

      formatters_by_ft = {
        c = ["clang-format"];
        cpp = ["clang-format"];
        rust = ["rustfmt"];
        nix = ["alejandra"];
        lua = ["stylua"];
        json = ["prettier"];
        yaml = ["prettier"];
        markdown = ["prettier"];
        sh = ["shfmt"];
        bash = ["shfmt"];
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>lua require('conform').format()<CR>";
      options.desc = "Format buffer";
    }
  ];
}
