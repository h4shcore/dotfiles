;;; git.el --- Git Configuration -*- lexical-binding: t; -*-

(require 'magit)
(require 'diff-hl)

;; Enable diff highlighting

(global-diff-hl-mode 1)

(add-hook 'dired-mode-hook #'diff-hl-dired-mode)

(add-hook 'magit-post-refresh-hook
          #'diff-hl-magit-post-refresh)

;; Magit

(setq magit-display-buffer-function
      #'magit-display-buffer-same-window-except-diff-v1)

(provide 'git)
