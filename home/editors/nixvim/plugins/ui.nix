{
  programs.nixvim = {
    plugins = {
      lualine = {
        enable = true;

        settings = {
          options = {
            theme = "gruvbox";
            globalstatus = true;
            iconsEnabled = true;

            componentSeparators = {
              left = "│";
              right = "│";
            };

            sectionSeparators = {
              left = "";
              right = "";
            };
          };
        };
      };

      web-devicons.enable = true;

      which-key = {
        enable = true;

        settings = {
          preset = "modern";
          delay = 300;
          notify = false;
        };
      };

      indent-blankline = {
        enable = true;

        settings = {
          indent.char = "│";
        };
      };
    };
  };
}
