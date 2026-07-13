;;; org.el --- Org Configuration -*- lexical-binding: t; -*-

(require 'org)
(require 'org-modern)

;; ============================
;; Directories
;; ============================

(setq org-directory "~/Documents/org")

(setq org-agenda-files
      (list org-directory))

;; ============================
;; Startup
;; ============================

(setq org-startup-indented t)
(setq org-hide-emphasis-markers t)
(setq org-startup-folded 'content)

;; Pretty ellipsis

(setq org-ellipsis " ▾")

;; ============================
;; TODO States
;; ============================

(setq org-todo-keywords
      '((sequence
         "TODO(t)"
         "NEXT(n)"
         "WAIT(w)"
         "|"
         "DONE(d)"
         "CANCELLED(c)")))

;; ============================
;; Logging
;; ============================

(setq org-log-done 'time)

;; ============================
;; Source Blocks
;; ============================

(setq org-src-fontify-natively t)
(setq org-src-tab-acts-natively t)
(setq org-edit-src-content-indentation 0)

;; ============================
;; Org Modern
;; ============================

(global-org-modern-mode)

(provide 'org)
