{
  programs.nixvim.plugins.conform-nvim = {
    enable = true;

    settings = {
      notifyOnError = true;

      formatOnSave = {
        timeoutMs = 500;
        lspFallback = true;
      };

      formattersByFt = {
        c = [ "clang_format" ];
        cpp = [ "clang_format" ];

        rust = [ "rustfmt" ];

        nix = [ "alejandra" ];

        lua = [ "stylua" ];

        json = [ "prettier" ];
        yaml = [ "prettier" ];
        markdown = [ "prettier" ];

        sh = [ "shfmt" ];
        bash = [ "shfmt" ];
      };
    };
  };

  programs.nixvim.keymaps = [
    {
      mode = "n";
      key = "<leader>cf";
      action = "<cmd>Format<CR>";
      options.desc = "Format buffer";
    }
  ];
}
