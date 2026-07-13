;;; lsp.el --- LSP Configuration -*- lexical-binding: t; -*-

(require 'eglot)
(require 'treesit-auto)

;; ============================
;; Treesitter
;; ============================

(setq treesit-auto-install 'prompt)

(global-treesit-auto-mode)

;; ============================
;; Eglot
;; ============================

(dolist (hook '(c-mode-hook
                c-ts-mode-hook
                c++-mode-hook
                c++-ts-mode-hook
                rust-mode-hook
                rust-ts-mode-hook
                nix-mode-hook
                bash-mode-hook
                bash-ts-mode-hook
                json-mode-hook
                json-ts-mode-hook
                toml-ts-mode-hook
                markdown-mode-hook))
  (add-hook hook #'eglot-ensure))

;; ============================
;; Format on Save
;; ============================

(add-hook 'before-save-hook
          (lambda ()
            (when (eglot-managed-p)
              (eglot-format-buffer))))

(provide 'lsp)
