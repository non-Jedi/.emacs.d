;;; mode-line.el --- mode-line configuration -*- lexical-bindings:t -*-

(setq line-number-mode t
      column-number-mode t
      column-number-indicator-zero-based nil
      size-indication-mode t)
(setq-default mode-line-format '("%e" mode-line-front-space
                                 mode-line-modified mode-line-remote
                                 "  %b"
                                 "  Mode:%m"
                                 evil-mode-line-tag
                                 "  " mode-line-position
                                 mode-line-end-spaces))

(provide 'mode-line-config)
