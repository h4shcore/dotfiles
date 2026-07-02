{theme}: let
  c = theme.colors;
in ''
  layout {
      focus-ring {
          active-color "${c.accent}"
          inactive-color "${c.brightBlack}"
      }

      border {
          active-color "${c.accent}"
          inactive-color "${c.brightBlack}"
      }

      shadow {
          color "${c.background}cc"
      }

      tab-indicator {
          active-color "${c.accent}"
          inactive-color "${c.brightBlack}"
      }

      insert-hint {
          color "${c.green}dd"
      }
  }

  overview {
      backdrop-color "${c.background}cc"
  }

  hotkey-overlay {
      skip-at-startup
  }
''
