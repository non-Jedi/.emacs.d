;;; git-config.el --- Configure magit -*- lexical-bindings:t -*-

(require 'general)

(straight-use-package 'magit)
(straight-use-package 'forge)
(straight-use-package 'evil-magit)

(setq vc-handled-backends nil)

(defun git-toggle-ssh-socks ()
  "Toggle whether to tunnel git traffic through a socks5 proxy on port 4711."
  (interactive)
  (cond
   ((getenv "GIT_SSH_COMMAND")
    (setenv "GIT_SSH_COMMAND")
    (message "Not using proxy for git"))
   (t
    (setenv "GIT_SSH_COMMAND"
            "ssh -o ProxyCommand=\"/usr/bin/openbsd-nc -X 5 -x localhost:4711 %h %p\"")
    (message "Using proxy for git"))))

(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 :prefix "SPC"
 "g"   '(:ignore t :which-key "git")
 "g'"  'magit-status
 "gb"  'magit-blame
 "gc"  'magit-commit
 "gd"  'magit-diff-buffer-file

 "gf"  '(:ignore t :which-key "file")
 "gfc" 'magit-file-checkout
 "gfd" 'magit-file-delete
 "gfr" 'magit-file-rename
 "gfs" 'magit-stage-file
 "gfu" 'magit-unstage-file

 "gg"  'magit-dispatch

 "gh"  '(:ignore t :which-key "hub")
 "ghn" 'forge-list-notifications
 "ghr" 'forge-list-repositories
 "ghy" 'forge-pull

 "gl"  'magit-log-buffer-file

 "gt"  '(:ignore t :which-key "toggle")
 "gtp" 'git-toggle-ssh-socks)

(with-eval-after-load 'magit
  (require 'evil-magit)
  (require 'forge))

(provide 'git-config)
