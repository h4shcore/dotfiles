{
  programs.nixvim.keymaps = [
    # Better window navigation
    {
      mode = "n";
      key = "<C-h>";
      action = "<C-w>h";
      options.desc = "Move to left window";
    }
    {
      mode = "n";
      key = "<C-j>";
      action = "<C-w>j";
      options.desc = "Move to lower window";
    }
    {
      mode = "n";
      key = "<C-k>";
      action = "<C-w>k";
      options.desc = "Move to upper window";
    }
    {
      mode = "n";
      key = "<C-l>";
      action = "<C-w>l";
      options.desc = "Move to right window";
    }

    # Better indenting
    {
      mode = "v";
      key = "<";
      action = "<gv";
      options.desc = "Indent left";
    }
    {
      mode = "v";
      key = ">";
      action = ">gv";
      options.desc = "Indent right";
    }

    # Move selected lines
    {
      mode = "v";
      key = "J";
      action = ":m '>+1<CR>gv=gv";
      options.desc = "Move selection down";
    }
    {
      mode = "v";
      key = "K";
      action = ":m '<-2<CR>gv=gv";
      options.desc = "Move selection up";
    }

    # Clear search highlight
    {
      mode = "n";
      key = "<Esc>";
      action = "<cmd>nohlsearch<CR>";
      options.desc = "Clear search highlight";
    }

    # Better paste (don't overwrite clipboard)
    {
      mode = "x";
      key = "<leader>p";
      action = "\"_dP";
      options.desc = "Paste without yanking";
    }

    # Delete without yanking
    {
      mode = ["n" "v"];
      key = "<leader>d";
      action = "\"_d";
      options.desc = "Delete without yanking";
    }

    # Save
    {
      mode = "n";
      key = "<leader>w";
      action = "<cmd>w<CR>";
      options.desc = "Save file";
    }

    # Quit
    {
      mode = "n";
      key = "<leader>q";
      action = "<cmd>q<CR>";
      options.desc = "Quit";
    }

    # Force quit
    {
      mode = "n";
      key = "<leader>Q";
      action = "<cmd>q!<CR>";
      options.desc = "Force quit";
    }

    # Select all
    {
      mode = "n";
      key = "<leader>a";
      action = "ggVG";
      options.desc = "Select all";
    }
  ];
}
