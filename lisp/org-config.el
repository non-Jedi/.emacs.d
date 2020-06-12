;;; org-config.el --- My org-mode config -*- lexical-bindings:t -*-

(require 'general)
(require 'straight)
(require 'evil)
(require 'cl-lib)
(require 'find-lisp)

;; still running into https://github.com/raxod502/straight.el/issues/211
(straight-use-package 'org-plus-contrib)

(straight-use-package 'evil-org)
(add-hook 'org-mode-hook 'evil-org-mode)
(add-hook 'evil-org-mode-hook 'evil-org-set-key-theme)

(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 :prefix "SPC"
 "o"    '(:ignore t :which-key "org")
 "oa"   'org-agenda
 "ot"   'org-todo-list
 )

(general-define-key
 :states '(normal visual motion)
 :prefix ","
 :keymaps 'org-mode-map
 "RET" 'org-open-at-point
 "'"   'org-edit-special
 ","   'org-ctrl-c-ctrl-c
 "b"   '(:ignore t :which-key "babel")
 "bz"  'org-babel-switch-to-session
 "bt"  'org-babel-tangle
 "c"   '(:ignore t :which-key "timestamps")
 "ci"  'org-time-stamp
 "cI"  'org-time-stamp-inactive
 "d"   '(:ignore t :which-key "todo")
 "dd"  'org-todo
 "di"  '(:ignore t :which-key "insert")
 "did" 'org-deadline
 "dis" 'org-schedule
 "dl"  'org-todo-list
 "e"   '(:ignore t :which-key "export")
 "ee"  'org-export-dispatch
 "i"   '(:ignore t :which-key "insert")
 "id"  'org-insert-todo-heading
 "iD"  'org-insert-todo-subheading
 "if"  'org-footnote-new
 "ih"  'org-insert-heading
 "iH"  'org-insert-heading-after-current
 "il"  'org-insert-link
 "ip"  'org-set-property
 "is"  'org-insert-subheading
 "it"  'org-set-tags-command
 "p"   '(:ignore t :which-key "pictures")
 "pl"  'org-latex-preview
 "s"   '(:ignore t :which-key "subtree")
 "sb"  'org-tree-to-indirect-buffer
 "t"   '(:ignore t :which-key "toggle")
 "tc"  'org-toggle-checkbox
 "tl"  'org-toggle-link-display
 "tp"  'org-toggle-inline-images
 "tx"  'org-latex-preview)

(general-define-key
 :states '(normal visual motion)
 :prefix ",m"
 :keymaps 'org-src-mode-map
 "," 'org-edit-src-exit
 "k" 'org-edit-src-abort)

;; custom org-export latex template
(with-eval-after-load 'ox-latex
  (add-to-list 'org-latex-classes
               '("amsart" "\\documentclass[11pt]{amsart}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))
  (add-to-list 'org-latex-classes
               '("extarticle" "\\documentclass{extarticle}"
                 ("\\section{%s}" . "\\section*{%s}")
                 ("\\subsection{%s}" . "\\subsection*{%s}")
                 ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
                 ("\\paragraph{%s}" . "\\paragraph*{%s}")
                 ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

(straight-use-package 'org-pdfview)

(with-eval-after-load 'org
  (setq org-adapt-indentation nil
        org-startup-indented nil
        org-startup-folded t
        org-pretty-entities t)
  (setq org-preview-latex-default-process 'imagemagick
        org-confirm-babel-evaluate nil)
  ;; Allow opening org links to pdfs
  (require 'org-pdfview)
  (add-to-list 'org-file-apps
               '("\\.pdf::[:digit:]+\\'" . (lambda (file link)
                                             (org-pdfview-open-link))))
  ;; Setup syntax highlighting in org exports
  (setq org-latex-listings 'minted
        org-latex-minted-options
        '(("frame" "lines")
          ("bgcolor" "light-gray"))
        org-latex-pdf-process
        '("%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "bibtex %b"
          "makeindex %b"
          "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"
          "%latex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (add-to-list 'org-latex-packages-alist '("" "xcolor"))
  (add-to-list 'org-latex-packages-alist "\\definecolor{light-gray}{gray}{0.9}" t)
  ;; Enable Tikz
  ;; add-to-list inserts at top of list; commands from packages must come after
  (add-to-list 'org-latex-packages-alist '("" "fontspec"))
  (add-to-list 'org-latex-packages-alist '("" "newunicodechar"))
  (add-to-list 'org-latex-packages-alist "\\setmainfont{Vollkorn}" t)
  (add-to-list 'org-latex-packages-alist "\\setmonofont[Scale=0.8]{Fira Code}" t)
  (add-to-list 'org-latex-packages-alist
               "\\newfontfamily{\\fallbackfont}{Symbola}[Scale=MathLowercase]" t)
  (add-to-list 'org-latex-packages-alist
               "\\DeclareTextFontCommand{\\textfallback}{\\fallbackfont}" t)
  (add-to-list 'org-latex-packages-alist
               "\\newunicodechar{𝐋}{\\textfallback{𝐋}}" t)
  (add-to-list 'org-latex-packages-alist
               "\\newunicodechar{𝐌}{\\textfallback{𝐌}}" t)
  (add-to-list 'org-latex-packages-alist
               "\\newunicodechar{𝐓}{\\textfallback{𝐓}}" t)
  ;; configure evil integration
  (require 'evil-org)
  (evil-org-set-key-theme '(navigation insert textobjects additional calendar))
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  ;; configure todo functionality
  (setq org-log-done 'time
        org-enforce-todo-dependencies t
        org-enforce-todo-checkbox-dependencies t
        ;; everything in ~/org is my agenda
        org-agenda-files (find-lisp-find-files org-directory "\.org$")
        org-agenda-hide-tags-regexp "drill"))

(straight-use-package 'org-ref)

(setq org-ref-default-bibliography '("~/org/references.bib")
    reftex-default-bibliography '("~/org/references.bib")
    org-ref-bibliography-notes "~/org/references_notes.org"
    org-ref-pdf-directory "~/org/papers/")

;; outshine provides an org-like experience in non-org buffers
(straight-use-package 'outshine)
(straight-use-package 'outorg)

(evil-declare-motion 'outline-next-visible-heading)
(evil-declare-motion 'outline-previous-visible-heading)
(evil-declare-motion 'outline-forward-same-level)
(evil-declare-motion 'outline-backward-same-level)
(evil-declare-motion 'outline-up-heading)
(evil-declare-motion 'outshine-cycle)

(evil-define-key '(normal visual motion) outshine-mode-map
  (kbd "<tab>") 'outshine-cycle)
(evil-define-key '(normal visual motion) outshine-mode-map
  (kbd "gh") 'outline-up-heading)
(evil-define-key '(normal visual motion) outshine-mode-map
  (kbd "gk") 'outline-backward-same-level)
(evil-define-key '(normal visual motion) outshine-mode-map
  (kbd "gj") 'outline-forward-same-level)

(general-define-key
 :states '(normal visual motion)
 :prefix ","
 :keymaps 'outshine-mode-map
 "mo"   '(:ignore t :which-key "outshine")
 "mo'"  'outorg-edit-as-org
 "moi"  '(:ignore t :which-key "insert")
 "moid" 'outshine-insert-drawer
 "moih" 'outshine-insert-heading
 "moil" 'outshine-insert-link
 "moip" 'outshine-set-property
 "moit" 'outshine-set-tags-command
 "moT"  '(:ignore t :which-key "toggle")
 "moTc" 'outshine-toggle-checkbox)

(defun outorg-transform-active-source-block-headers-i ()
  (interactive)
  (outorg-transform-active-source-block-headers))

(general-define-key
 :states '(normal visual motion)
 :prefix ","
 :keymaps 'outorg-edit-minor-mode-map
 "mo"   '(:ignore t :which-key "outorg")
 "moh"  '(outorg-transform-active-source-block-headers-i
          :which-key "outorg transform headers"))

(add-hook 'outshine-mode-hook #'evil-normalize-keymaps)

(provide 'org-config)
