;;; julia-config.el --- My julia config -*- lexical-bindings:t -*-

(require 'straight)
(require 'general)
(require 'cl-generic)

(straight-override-recipe
 '(julia-mode :type git :host github :repo "non-Jedi/julia-emacs" :branch "devel"))
(straight-use-package 'julia-mode)
(add-hook 'julia-mode-hook #'(lambda () (abbrev-mode 1)))

(straight-use-package
 '(eglot-jl :type git :host github :repo "non-Jedi/eglot-jl" :files ("*.el" "*.jl" "*.toml")))

(with-eval-after-load 'eglot
  (eglot-jl-init))

(provide 'julia-config)
