;;; evil-config.el --- Configure evil-mode -*- lexical-bindings:t -*-

(require 'general)
(require 'swiper)

(setq evil-want-integration t
      evil-want-keybinding nil)
(straight-use-package 'evil)
(evil-mode 1)

(straight-use-package 'evil-collection)
(evil-collection-init)

(evil-global-set-key 'normal " " nil)
(evil-global-set-key 'visual " " nil)
(evil-global-set-key 'motion " " nil)
(evil-global-set-key 'normal "," nil)
(evil-global-set-key 'visual "," nil)
(evil-global-set-key 'motion "," nil)
(evil-global-set-key 'normal "/" #'swiper)
(evil-global-set-key 'visual "/" #'swiper)
(evil-global-set-key 'motion "/" #'swiper)

(general-define-key
 :states '(normal visual motion)
 :keymaps 'override
 :prefix "SPC"
 "wj" 'evil-window-down
 "wk" 'evil-window-up
 "wh" 'evil-window-left
 "wl" 'evil-window-right)

(provide 'evil-config)
