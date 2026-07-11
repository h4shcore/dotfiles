{
  programs.zellij = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      default_shell = "fish";
      default_layout = "default";
      pane_frames = true;
      simplified_ui = false;
      default_mode = "normal";

      mouse_mode = true;
      copy_on_select = false;

      scroll_buffer_size = 100000;

      session_serialization = true;
      serialize_pane_viewport = true;

      scrollback_editor = "nvim";

      ui = {
        pane_frames = {
          hide_session_name = false;
        };
      };

      theme = "gruvbox-dark";
    };
  };
}
