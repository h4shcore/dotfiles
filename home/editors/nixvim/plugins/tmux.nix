{
  programs.nixvim.plugins.tmux-navigator = {
    enable = true;

    settings = {
      # Save the current buffer when switching from nvim to tmux.
      save_on_switch = 1;

      # Keep the current tmux pane zoomed when navigating.
      preserve_zoom = 1;
    };
  };
}
