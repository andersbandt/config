
;; author: Anders Bandt
;; version: 1.0
;; title: Ders' Emacs Settings


;; ADDED BY ANDERS FROM EXAMPLE
(desktop-save-mode 1)


(setenv "PATH" (concat (getenv "PATH") ":/usr/bin"))
(setq exec-path (append exec-path '("/usr//bin")))


;; LOAD BASE (DERS) settings
(load "~/.emacs.d/base.el")


;; LOAD CODE SETTINGS
(load "~/.emacs.d/code.el")


;; SET SYSTEM SPECIFIC COMMANDS
;; TODO: I would like to add some system control to change certain things in config
(setq compile-command "/home/anders/ti/ccs1270/ccs/utils/bin/gmake -C /home/anders/Documents/CCS/workspace_WWD/WWD_prog/Debug -k -j 8 all -O")


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages '(magit-todos auto-header)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'scroll-left 'disabled nil)



;; LOAD LSP-MODE settings
(load "~/.emacs.d/lsp.el")


;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
  (message ".emacs is ready to roll!"))



