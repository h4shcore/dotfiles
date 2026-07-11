{
  programs.zellij = {
    enable = true;

    enableFishIntegration = true;

    settings = {
      default_shell = "fish";
      default_mode = "normal";

      mouse_mode = true;
      pane_frames = false;

      simplified_ui = true;

      show_startup_tips = false;
      show_release_notes = false;

      copy_on_select = false;

      scroll_buffer_size = 10000;

      scrollback_editor = "nvim";

      session_serialization = true;
      serialize_pane_viewport = true;

      ui = {
        pane_frames = {
          hide_session_name = true;
        };
      };
    };
  };
}
