{
  programs.nixvim.plugins = {
    mini = {
      enable = true;

      modules = {
        ai = {};

        surround = {};

        pairs = {};

        comment = {};

        move = {};

        splitjoin = {};

        bracketed = {};

        cursorword = {};

        jump = {};

        trailspace = {};
      };
    };
  };
}
