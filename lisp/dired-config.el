;;; dired-config.el --- config dired -*- lexical-bindings:t -*-

(straight-use-package 'dired-subtree)
(straight-use-package 'dired-open)

(with-eval-after-load 'dired
  ;; Replace dired-find-file with dired-open-file
  (require 'dired-open)
  ;; Evil automaticall collection binds TAB to toggle subtrees
  (require 'dired-subtree))

(provide 'dired-config)
