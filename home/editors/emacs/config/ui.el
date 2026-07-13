;;; ui.el --- User Interface -*- lexical-binding: t; -*-

;; Disable GUI
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(tooltip-mode -1)

;; Startup
(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Bell
(setq ring-bell-function #'ignore)

;; Cursor
(blink-cursor-mode -1)

;; Line numbers
(global-display-line-numbers-mode 1)
(column-number-mode 1)

;; Highlight current line
(global-hl-line-mode 1)

;; Parentheses
(show-paren-mode 1)

;; Relative line numbers
(setq display-line-numbers-type 'relative)

(defun my-post-text-scale-callback ()
  "Dynamically scale line numbers alongside buffer text zoom."
  (let ((new-size (floor (* (face-attribute 'default :height)
                            (expt text-scale-mode-step text-scale-mode-amount)))))
    (set-face-attribute 'line-number nil :height new-size)
    (set-face-attribute 'line-number-current-line nil :height new-size)))

(add-hook 'text-scale-mode-hook #'my-post-text-scale-callback)

(set-face-attribute 'default nil
                    :family "Iosevka Nerd Font"
                    :height 140)

(set-face-attribute 'fixed-pitch nil
                    :family "Iosevka Nerd Font"
                    :height 140)

;; Theme
(require 'gruvbox-theme)
(load-theme 'gruvbox-dark-hard t)

;; Doom Modeline
(require 'doom-modeline)
(doom-modeline-mode 1)

(setq doom-modeline-height 30)
(setq doom-modeline-icon t)

;; Which Key
(require 'which-key)
(which-key-mode 1)

(setq which-key-idle-delay 0.4)

(provide 'ui)
