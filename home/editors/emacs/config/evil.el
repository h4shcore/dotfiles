;;; evil.el --- Vim Emulation -*- lexical-binding: t; -*-

;; Configure BEFORE loading Evil

(setq evil-want-keybinding nil)
(setq evil-want-C-u-scroll t)
(setq evil-want-C-i-jump nil)

(setq evil-vsplit-window-right t)
(setq evil-split-window-below t)

(setq evil-undo-system 'undo-redo)

;; Load packages

(require 'evil)
(require 'evil-collection)
(require 'evil-surround)

;; Enable

(evil-mode 1)

(evil-collection-init)

(global-evil-surround-mode 1)

(provide 'evil)
