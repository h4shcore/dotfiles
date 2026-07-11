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
          yamlls.enable = true;

          taplo.enable = true;

          marksman.enable = true;
        };
      };

      lsp-lines.enable = false;
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
