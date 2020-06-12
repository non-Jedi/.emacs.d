;;; jupyter-config.el --- config emacs-jupyter -*- lexical-bindings:t -*-
;; hack since libzmq won't build properly on void for some reason
(setenv "ZMQ_CFLAGS" "-I/usr/local/include")
(setenv "ZMQ_LIBS" "-L/usr/local/lib")
(straight-use-package '(zmq :type git :host github
                            :repo "dzop/emacs-zmq"
                            :files (:defaults "Makefile" "src" "*.so")))
(straight-use-package 'jupyter)

(straight-use-package 'markdown-mode)

(with-eval-after-load 'org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((jupyter . t))))

  ;; julia src block act like jupyter-julia blocks
(with-eval-after-load 'ob-jupyter
  (setq-default org-babel-default-header-args:julia nil)
  (org-babel-jupyter-override-src-block "julia")
  (defalias 'org-babel-julia-initiate-session
    'org-babel-jupyter-julia-initiate-session))

(provide 'jupyter-config)
