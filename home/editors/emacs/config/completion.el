;;; completion.el --- Completion -*- lexical-binding: t; -*-

;; ============================
;; Save History
;; ============================

(savehist-mode 1)

;; ============================
;; Vertico
;; ============================

(require 'vertico)

(vertico-mode)

;; ============================
;; Orderless
;; ============================

(require 'orderless)

(setq completion-styles '(orderless basic))
(setq completion-category-defaults nil)

(setq completion-category-overrides
      '((file (styles basic partial-completion))))

;; ============================
;; Marginalia
;; ============================

(require 'marginalia)

(marginalia-mode)

;; ============================
;; Corfu
;; ============================

(require 'corfu)

(setq corfu-auto t)
(setq corfu-auto-delay 0.15)
(setq corfu-auto-prefix 2)

(setq corfu-cycle t)

(global-corfu-mode)

;; ============================
;; Cape
;; ============================

(require 'cape)

(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)

;; ============================
;; Consult
;; ============================

(require 'consult)

;; ============================
;; Embark
;; ============================

(require 'embark)

(setq prefix-help-command #'embark-prefix-help-command)

(require 'embark-consult)

(provide 'completion)
