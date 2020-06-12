(straight-use-package 'nov)

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))

(setq nov-text-width 80)

(straight-use-package 'pdf-tools)
(pdf-loader-install)

(provide 'doc-config)
