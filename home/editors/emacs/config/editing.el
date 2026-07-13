;;; editing.el --- Editing -*- lexical-binding: t; -*-

;; UTF-8 everywhere
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Delete selected text when typing
(delete-selection-mode 1)

;; Auto close brackets
(electric-pair-mode 1)

;; Highlight matching parentheses
(show-paren-mode 1)

;; Auto reload changed files
(global-auto-revert-mode 1)

;; Remember cursor position
(save-place-mode 1)

;; Save minibuffer history
(savehist-mode 1)

;; Recent files
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Short answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Remove trailing whitespace on save
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Make scripts executable if they start with a shebang
(add-hook 'after-save-hook
          #'executable-make-buffer-file-executable-if-script-p)

;; Keep backups in one place
(setq backup-directory-alist
      `(("." . "~/.local/share/emacs/backups")))

(setq auto-save-file-name-transforms
      `((".*" "~/.local/share/emacs/auto-save/" t)))

;; Smooth scrolling
(setq scroll-conservatively 101)
(setq scroll-margin 8)
(setq scroll-step 1)

;; Clipboard
(setq select-enable-clipboard t)

(provide 'editing)
