
;; author: Anders Bandt
;; version: 1.0
;; title: Ders' Emacs Settings


;; ADDED BY ANDERS FROM EXAMPLE
(desktop-save-mode 1)


;; (setenv "PATH" (concat (getenv "PATH") ":/usr/bin"))
(setq exec-path (append exec-path '("/usr//bin")))


;; LOAD BASE (DERS) settings
(load "~/.emacs.d/base.el")


;; LOAD CODE SETTINGS
(load "~/.emacs.d/code.el")


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

 (put 'scroll-left 'disabled nil)
 )


;; STARTUP ECHO MESSAGE
(message ".emacs is ready to roll!")

;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
    (message ".emacs is INITIALIZED! Lucky bastard."))


