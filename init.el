;;; init.el --- My emacs config -*- lexical-bindings:t -*-

;; bootstrap straight.el
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
    (url-retrieve-synchronously
    "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
    'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Need to set path since emacs daemon launched where PATH not set
;; ---------------------------------------------------------------
(setenv "PATH" (concat
                "/opt/texlive/2020/bin/x86_64-linux" path-separator
                (getenv "HOME") "/.local/bin" path-separator
                "/usr/bin" path-separator
                (getenv "PATH")))
(setenv "TEXMFHOME" "/home/adam/.local/share/texlive/2020")
(setenv "EDITOR" "emacsclient")
(add-to-list 'exec-path "/opt/texlive/2020/bin/x86_64-linux")
(add-to-list 'exec-path (concat (getenv "HOME") "/.local/bin"))

;; general appearance and behavior customization
(straight-use-package 'mixed-pitch)

(defun my/frame-setup (&optional frame)
  (when frame (select-frame frame))
  (when (window-system)
    (set-face-attribute 'default nil :family "Iosevka" :height 80)
    (set-face-attribute 'variable-pitch nil :family "Vollkorn" :height 95)
    ;; Force Symbola for "Mathematical Alphanumeric Symbols" unicode block
    (set-fontset-font t '(?𝐀 . ?𝔇) "Symbola")
    (set-fontset-font t '(?⬀ . ?⯯) "Symbola")))
(if (daemonp)
    (add-hook 'after-make-frame-functions #'my/frame-setup)
  (my/frame-setup))

;; Don't litter everywhere with backup files
(setq backup-directory-alist
      (list (cons "." (expand-file-name "saves" user-emacs-directory)))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; theme
(straight-use-package 'clues-theme)
(straight-use-package 'paper-theme)
(load-theme 'paper t)
(custom-theme-set-faces
 'paper
 (list 'font-lock-preprocessor-face paper-magenta-on-paper-face))

;; counsel/ivy
(straight-use-package 'counsel)
(ivy-mode 1)
(counsel-mode 1)

;; Enable jumping around buffer
(straight-use-package 'avy)

;; general/which-key keybindings
(straight-use-package 'general)
(setq general-override-states '(insert
                                emacs
                                hybrid
                                normal
                                visual
                                motion
                                operator
                                replace))
(require 'general)
(general-auto-unbind-keys)
(straight-use-package 'which-key)
(which-key-mode)

(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 :prefix ","
 "m" '(:ignore t :which-key "minor modes"))

(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 :prefix "SPC"
 ""    nil
 "SPC" 'counsel-M-x

 "a"    '(:ignore t :which-key "applications")
 "aj"   '(:ignore t :which-key "jupyter")
 "aj'"  'jupyter-run-repl
 "aja"  'jupyter-repl-associate-buffer
 "ajc"  'jupyter-connect-repl
 "aje"  '(:ignore t :which-key "jupyter")
 "ajeb" 'jupyter-eval-buffer
 "ajer" 'jupyter-eval-line-or-region
 "ajes" 'jupyter-eval-string
 "aji"  'jupyter-inspect-at-point
 "ajr"  'jupyter-repl-restart-kernel
 "ajs"  'jupyter-repl-interrupt-kernel

 "b"   '(:ignore t :which-key "buffers")
 "bd"  'kill-current-buffer
 "bb"  'ivy-switch-buffer

 "f"   '(:ignore t :which-key "files")
 "ff"  'counsel-find-file
 "fl"  'counsel-find-library
 "fr"  '((lambda () (interactive) (load-file user-init-file))
         :which-key "reload init")
 "fs"  'save-buffer

 "F"   '(:ignore t :which-key "Frame")
 "Fd"  'delete-frame

 "h"   '(:ignore t :which-key "help")
 "hd"  '(:ignore t :which-key "describe")
 "hda" 'counsel-apropos
 "hdb" 'counsel-descbinds
 "hdc" 'describe-char
 "hdf" 'counsel-describe-function
 "hdF" 'counsel-describe-face
 "hdk" 'describe-key
 "hdm" 'describe-mode
 "hdp" 'describe-package
 "hdv" 'counsel-describe-variable
 "hi"   '(:ignore t :which-key "info")
 "hia"  'info-apropos
 "hii"  'info
 "his"  'counsel-info-lookup-symbol
 "hl"   '(:ignore t :which-key "list")
 "hlF"  'counsel-faces

 "i"   '(:ignore t :which-key "insert")
 "iu"  'counsel-unicode-char

 "j"   '(:ignore t :which-key "jump to")
 "jc"  'avy-goto-char-2
 "je"  'avy-goto-end-of-line
 "ji"  'counsel-imenu
 "jl"  'avy-goto-line
 "jw"  'avy-goto-word-1
 "jW"  'avy-goto-whitespace-end

 "q"   '(:ignore t :which-key "quit")
 "qQ"  'kill-emacs
 "qs"  'save-buffers-kill-emacs

 "t"   '(:ignore t :which-key "toggle")
 "tj"  '(:ignore t :which-key "jupyter")
 "tjc" '((lambda () (interactive)
           (setq completion-at-point-functions
                 (delq 'jupyter-completion-at-point
                       completion-at-point-functions)))
         :which-key "jupyter-completion-at-point")
 "td"  'toggle-debug-on-error
 "tF"  'auto-fill-mode
 "tn"   '((lambda () (interactive) (setq-local display-line-numbers
                                               (if display-line-numbers nil
                                                 'relative)))
          :which-key "toggle line-numbers")
 "to"  'outshine-mode
 "tp"  'electric-pair-local-mode
 "tP"  'show-paren-mode
 "ts"  'flyspell-mode
 "tt"  'toggle-truncate-lines
 "tv"  'mixed-pitch-mode

 "u"   'universal-argument

 "w"   '(:ignore t :which-key "windows")
 "wd"  'delete-window
 "wm"  'delete-other-windows
 "w/"  'split-window-right
 "w-"  'split-window-below

 "x"   '(:ignore t :which-key "xref")
 "xd"  'xref-find-definitions
 "xr"  'xref-find-references)

;; External config files
(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'mode-line-config)
(require 'evil-config)
(require 'org-config)
(require 'jupyter-config)
(require 'company-config)
(require 'eglot-config)
(require 'julia-config)
(require 'doc-config)
(require 'git-config)
(require 'haskell-config)
(require 'racket-config)
(require 'dired-config)

;; miscellaneous un-configured packages
(straight-use-package 'fish-mode)
(straight-use-package 'yaml-mode)
(straight-use-package 'chapel-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-default-style (quote ((c-mode . "stroustrup") (other . "stroustrup"))))
 '(custom-safe-themes
   (quote
    ("c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "09c6d2f5114b42dc9522856de47d9dc331acd051011e451c8402ea2174d22d56" "ed91d4e59412defda16b551eb705213773531f30eb95b69319ecd142fab118ca" default)))
 '(describe-char-unidata-list
   (quote
    (name old-name general-category canonical-combining-class decomposition numeric-value)))
 '(display-line-numbers (quote relative))
 '(electric-pair-mode t)
 '(enable-recursive-minibuffers t)
 '(global-whitespace-mode t)
 '(global-whitespace-newline-mode t)
 '(indent-tabs-mode nil)
 '(ivy-do-completion-in-region nil)
 '(ivy-use-virtual-buffers t)
 '(julia-force-tab-complete nil)
 '(menu-bar-mode nil)
 '(org-image-actual-width nil)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-eww org-gnus org-info org-irc org-mhe org-rmail org-tempo org-w3m)))
 '(pdf-misc-print-programm "/usr/bin/lpr")
 '(reb-re-syntax (quote rx))
 '(show-paren-mode t)
 '(tab-always-indent (quote complete))
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(whitespace-style (quote (face trailing tabs empty tab-mark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#FAFAFA" :foreground "#070A01" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 70 :width normal :foundry "CTDB" :family "Fira Code")))))
