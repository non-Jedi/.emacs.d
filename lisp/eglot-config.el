;;; init.el --- My language server config -*- lexical-bindings:t -*-

(require 'straight)

(straight-use-package 'eglot)

(general-define-key
 :states '(normal visual motion)
 :prefix ",m"
 :keymaps 'eglot-mode-map
 "l"   '(:ignore t :which-key "language-server")
 "la"  '(eglot-code-actions :major-modes)
 "ld"  'xref-find-definitions
 "lc"  'eglot-reconnect
 "lf"  'eglot-format
 "lh"  'eglot-help-at-point
 "lr"  'eglot-rename
 "lx"  'eglot-shutdown)

(provide 'eglot-config)
