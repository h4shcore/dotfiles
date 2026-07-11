{
  programs.nixvim = {
    plugins.gitsigns = {
      enable = true;

      settings = {
        currentLineBlame = true;

        signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
          topdelete.text = "‾";
          changedelete.text = "~";
          untracked.text = "┆";
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "]h";
        action = "<cmd>Gitsigns next_hunk<CR>";
        options.desc = "Next hunk";
      }

      {
        mode = "n";
        key = "[h";
        action = "<cmd>Gitsigns prev_hunk<CR>";
        options.desc = "Previous hunk";
      }

      {
        mode = "n";
        key = "<leader>hs";
        action = "<cmd>Gitsigns stage_hunk<CR>";
        options.desc = "Stage hunk";
      }

      {
        mode = "n";
        key = "<leader>hr";
        action = "<cmd>Gitsigns reset_hunk<CR>";
        options.desc = "Reset hunk";
      }

      {
        mode = "n";
        key = "<leader>hp";
        action = "<cmd>Gitsigns preview_hunk<CR>";
        options.desc = "Preview hunk";
      }

      {
        mode = "n";
        key = "<leader>hb";
        action = "<cmd>Gitsigns blame_line<CR>";
        options.desc = "Blame line";
      }
    ];
  };
}
