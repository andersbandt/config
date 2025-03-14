
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


;; LOAD LSP-MODE settings
(load "~/.emacs.d/lsp.el")


;; SET SYSTEM SPECIFIC COMMANDS
;; TODO: I would like to add some system control to change certain things in config
(cond
 ((eq system-name 'ANDERS-LAPTOP)
  (progn
    (setq compile-command "/home/anders/ti/ccs1270/ccs/utils/bin/gmake -C /home/anders/Documents/CCS/workspace_WWD/WWD_prog/Debug -k -j 8 all -O")
    (message "System: [ANDERS-LAPTOP]")))
 ((eq system-name 'darwin)
  (progn
    (message "Mac OS X")))
 ((eq system-name 'gnu/linux)
  (progn
    (message "Linux"))))



;; (custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(inhibit-startup-screen t)
 ;; '(package-selected-packages '(helm-z auto-header)))
;; (custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
;; (put 'scroll-left 'disabled nil)


;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
  (message ".emacs is ready to roll!"))


;; set up code folding
(hs-minor-mode)


