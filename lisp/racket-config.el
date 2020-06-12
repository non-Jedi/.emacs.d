;;; racket-config.el --- Configure emacs for use with racket -*- lexical-bindings:t -*-
(straight-use-package 'racket-mode)
(require 'general)

(general-define-key
 :states '(normal visual motion)
 :keymaps 'racket-mode-map
 :prefix ","
 "'"  'racket-repl
 "d"  'racket-describe
 "e"  '(:ignore t :which-key "eval")
 "eb" 'racket-run
 "ed" 'racket-send-definition
 "ep" 'racket-profile
 "er" 'racket-send-region
 "es" 'racket-send-last-sexp
 "E"  '(:ignore t :which-key "edit")
 "Ec" 'racket-check-syntax-mode
 "Eb" 'racket-base-requires
 "Er" 'racket-tidy-requires
 "ER" 'racket-trim-requires
 "h"  'racket-doc
 "i"  '(:ignore t :which-key "insert")
 "il" 'racket-insert-lambda)

(provide 'racket-config)
