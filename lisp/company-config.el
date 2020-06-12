;;; company-config.el --- My company config -*- lexical-bindings:t -*-

(require 'straight)

(straight-use-package 'company)
(add-hook 'after-init-hook 'global-company-mode)

(with-eval-after-load 'company
  (define-key company-mode-map [remap indent-for-tab-command]
    'company-indent-or-complete-common)
  (define-key company-active-map [return] 'company-complete-selection)
  (define-key company-active-map (kbd "RET") 'company-complete-selection))

(provide 'company-config)
