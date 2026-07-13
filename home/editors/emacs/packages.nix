{ ... }:

{
  programs.emacs = {
    extraPackages = epkgs: with epkgs; [
      # UI
      gruvbox-theme
      doom-modeline
      nerd-icons
      which-key

      # Vim
      evil
      evil-collection
      evil-surround
      evil-commentary
      general

      # Completion
      vertico
      consult
      orderless
      marginalia
      corfu
      cape
      embark
      embark-consult

      # LSP
      eglot
      treesit-auto

      # Git
      magit
      diff-hl

      # Terminal
      vterm

      # Org
      org-modern
    ];
  };
}
