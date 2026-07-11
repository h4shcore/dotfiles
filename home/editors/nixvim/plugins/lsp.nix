{
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
      };

      lsp-lines.enable = false;
    };

    keymaps = [
      # =====================
      # LSP Navigation
      # =====================
      {
        mode = "n";
        key = "gd";
        action.__raw = "vim.lsp.buf.definition";
        options.desc = "Goto Definition";
      }

      {
        mode = "n";
        key = "gD";
        action.__raw = "vim.lsp.buf.declaration";
        options.desc = "Goto Declaration";
      }

      {
        mode = "n";
        key = "gr";
        action.__raw = "vim.lsp.buf.references";
        options.desc = "References";
      }

      {
        mode = "n";
        key = "gi";
        action.__raw = "vim.lsp.buf.implementation";
        options.desc = "Goto Implementation";
      }

      {
        mode = "n";
        key = "gt";
        action.__raw = "vim.lsp.buf.type_definition";
        options.desc = "Goto Type Definition";
      }

      # =====================
      # Documentation
      # =====================
      {
        mode = "n";
        key = "K";
        action.__raw = "vim.lsp.buf.hover";
        options.desc = "Hover Documentation";
      }

      {
        mode = "n";
        key = "<C-k>";
        action.__raw = "vim.lsp.buf.signature_help";
        options.desc = "Signature Help";
      }

      # =====================
      # Refactoring
      # =====================
      {
        mode = "n";
        key = "<leader>rn";
        action.__raw = "vim.lsp.buf.rename";
        options.desc = "Rename Symbol";
      }

      {
        mode = "n";
        key = "<leader>ca";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Code Action";
      }

      {
        mode = "n";
        key = "<leader>f";
        action.__raw = "vim.lsp.buf.format";
        options.desc = "Format Buffer";
      }

      # =====================
      # Diagnostics
      # =====================
      {
        mode = "n";
        key = "[d";
        action.__raw = "vim.diagnostic.goto_prev";
        options.desc = "Previous Diagnostic";
      }

      {
        mode = "n";
        key = "]d";
        action.__raw = "vim.diagnostic.goto_next";
        options.desc = "Next Diagnostic";
      }

      {
        mode = "n";
        key = "<leader>e";
        action.__raw = "vim.diagnostic.open_float";
        options.desc = "Line Diagnostics";
      }

      {
        mode = "n";
        key = "<leader>q";
        action.__raw = "vim.diagnostic.setloclist";
        options.desc = "Diagnostics List";
      }
    ];
  };
}
