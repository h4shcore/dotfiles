{
  programs.nixvim.plugins = {
    blink-cmp = {
      enable = true;

      settings = {
        keymap = {
          preset = "default";
        };

        appearance = {
          nerd_font_variant = "mono";
        };

        completion = {
          documentation = {
            auto_show = true;
            auto_show_delay_ms = 200;
          };
        };

        signature = {
          enabled = true;
        };

        sources = {
          default = [
            "lsp"
            "path"
            "buffer"
          ];
        };

        fuzzy = {
          implementation = "prefer_rust";
        };
      };
    };

    friendly-snippets.enable = true;
    luasnip.enable = true;
  };
}
