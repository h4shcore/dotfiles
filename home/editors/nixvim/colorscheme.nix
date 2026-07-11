{
  programs.nixvim = {
    colorschemes.gruvbox = {
      enable = true;

      settings = {
        contrast = "hard";

        transparent_mode = true;

        italic = {
          strings = false;
          emphasis = true;
          comments = true;
          operators = false;
          folds = true;
        };

        bold = true;
        underline = true;
        inverse = true;
      };
    };
  };
}
