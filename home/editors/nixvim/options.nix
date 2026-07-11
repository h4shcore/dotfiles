{
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    opts = {
      # Line numbers
      number = true;
      relativenumber = true;

      # Indentation
      tabstop = 4;
      shiftwidth = 4;
      softtabstop = 4;
      expandtab = true;
      smartindent = true;

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;

      # Appearance
      termguicolors = true;
      cursorline = true;
      signcolumn = "yes";
      wrap = false;
      scrolloff = 8;
      sidescrolloff = 8;
      numberwidth = 4;

      # Splits
      splitbelow = true;
      splitright = true;

      # Mouse
      mouse = "a";

      # Clipboard
      clipboard = "unnamedplus";

      # Undo
      undofile = true;

      # Performance
      updatetime = 200;
      timeoutlen = 300;

      # Better completion
      completeopt = "menu,menuone,noselect";

      # Misc
      hidden = true;
      swapfile = false;
      backup = false;
      writebackup = false;
    };
  };
}
