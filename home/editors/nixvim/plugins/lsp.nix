{
  programs.nixvim = {
    plugins = {
      lsp = {
        enable = true;

        servers = {
          clangd.enable = true;
          rust_analyzer.enable = true;
          nil_ls.enable = true;

          bashls.enable = true;

          jsonls.enable = true;
          yamlls.enable = true;

          taplo.enable = true;

          marksman.enable = true;
        };
      };

      lsp-lines.enable = false;
    };

    diagnostics = {
      virtual_text = true;
      underline = true;
      update_in_insert = false;
      severity_sort = true;
    };
  };
}

# Language	Server
# -------------------------
# C/C++		clangd
# Rust		rust-analyzer
# Nix		nil_ls
# Bash		bashls
# JSON		jsonls
# YAML		yamlls
# TOML		taplo
# Markdown	marksman
