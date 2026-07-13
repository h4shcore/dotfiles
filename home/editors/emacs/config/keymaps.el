;;; keymaps.el --- Keybindings -*- lexical-binding: t; -*-

(require 'general)
(require 'consult)

;; ============================
;; Leader Key
;; ============================

(general-create-definer leader
  :states '(normal visual motion)
  :keymaps 'override
  :prefix "SPC"
  :global-prefix "C-SPC")

;; ============================
;; Files
;; ============================

(leader
  "f"  '(:ignore t :which-key "Files")
  "ff" '(find-file :which-key "Find File")
  "fr" '(consult-recent-file :which-key "Recent Files")
  "fs" '(save-buffer :which-key "Save File"))

;; ============================
;; Buffers
;; ============================

(leader
  "b"  '(:ignore t :which-key "Buffers")
  "bb" '(consult-buffer :which-key "Switch Buffer")
  "bd" '(kill-current-buffer :which-key "Delete Buffer")
  "bn" '(next-buffer :which-key "Next Buffer")
  "bp" '(previous-buffer :which-key "Previous Buffer"))

;; ============================
;; Search
;; ============================

(leader
  "s"  '(:ignore t :which-key "Search")
  "sg" '(consult-ripgrep :which-key "Ripgrep")
  "sl" '(consult-line :which-key "Current Buffer")
  "si" '(consult-imenu :which-key "Symbols"))

;; ============================
;; Windows
;; ============================

(leader
  "w"  '(:ignore t :which-key "Windows")
  "wv" '(split-window-right :which-key "Vertical Split")
  "wh" '(split-window-below :which-key "Horizontal Split")
  "wd" '(delete-window :which-key "Delete Window")
  "wo" '(delete-other-windows :which-key "Only Window"))

;; ============================
;; Quit
;; ============================

(leader
  "q"  '(:ignore t :which-key "Quit")
  "qq" '(save-buffers-kill-terminal :which-key "Quit Emacs"))

;; ============================
;; Git
;; ============================

(leader
  "g" '(:ignore t :which-key "Git")

  "gs" '(magit-status :which-key "Status")
  "gb" '(magit-blame-addition :which-key "Blame")
  "gc" '(magit-commit-create :which-key "Commit")
  "gp" '(magit-push-current-to-pushremote :which-key "Push")
  "gl" '(magit-log-current :which-key "Log"))

;; ============================
;; Org
;; ============================

(leader
  "o" '(:ignore t :which-key "Org")

  "oa" '(org-agenda :which-key "Agenda")
  "oc" '(org-capture :which-key "Capture")
  "ot" '(org-todo-list :which-key "Todos"))

;; ============================
;; Code / LSP
;; ============================

(leader
  "c" '(:ignore t :which-key "Code")
  "ca" '(eglot-code-actions :which-key "Code Action")
  "cr" '(eglot-rename :which-key "Rename")
  "cf" '(eglot-format-buffer :which-key "Format"))

(general-define-key
 :states '(normal)

 "gd" #'xref-find-definitions
 "gr" #'xref-find-references
 "gi" #'eglot-find-implementation
 "K"  #'eldoc)

(provide 'keymaps)
