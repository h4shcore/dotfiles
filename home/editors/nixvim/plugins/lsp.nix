{...}: {
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          clangd.enable = true;
          rust_analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };
          nil_ls.enable = true;
          bashls.enable = true;
          jsonls.enable = true;
          taplo.enable = true;
          marksman.enable = true;
        };

        keymaps = {
          lspBuf = {
            gd = "definition";
            gD = "declaration";
            gr = "references";
            gi = "implementation";
            gt = "type_definition";
            K = "hover";
            "<C-k>" = "signature_help";
            "<leader>rn" = "rename";
            "<leader>ca" = "code_action";
            "<leader>f" = "format";
          };
          diagnostic = {
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<leader>e" = "open_float";
            "<leader>q" = "setloclist";
          };
        };
      };

      lsp-lines.enable = false;
    };
  };
}
