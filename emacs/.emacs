
;; author: Anders Bandt
;; version: 2.0
;; title: Ders' Emacs Settings


(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
;; (package-initialize) ;; getting WARNING on this line about Unnecessary call to ‘package-initialize’ in init file



;; LOAD BASE (DERS) settings
(load "~/.emacs.d/base.el")


;; LOAD Obsidian (Markdown) settings
(load "~/.emacs.d/obsidian.el")


;; LOAD CODE SETTINGS
;; LOAD LSP-MODE settings;
(defun load-my-code-settings ()
  "Load custom settings for coding."
  (load-file "~/.emacs.d/code.el")
  (load "~/.emacs.d/lsp.el")
  )

(add-hook 'python-mode-hook 'load-my-code-settings)
(add-hook 'c-mode-hook 'load-my-code-settings)
(add-hook 'c++-mode-hook 'load-my-code-settings)
(add-hook 'java-mode-hook 'load-my-code-settings)
(add-hook 'js-mode-hook 'load-my-code-settings)
(add-hook 'sh-mode-hook 'load-my-code-settings)

(add-to-list 'auto-mode-alist '(".*bash.*" . shell-script-mode))



;; SET SYSTEM SPECIFIC COMMANDS
(setq compile-command "C:/ti/ccs1200/ccs/utils/bin/gmake.exe -C ./Debug -k -j 8 all -O")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages '(helm-z auto-header)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'scroll-left 'disabled nil)


;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
  (message ".emacs is ready to roll!"))


