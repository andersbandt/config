;;; base.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords:


;; MANAGE PACKAGES
(require 'ido)
(ido-mode t)

;; EDITOR SETTINGS
(line-number-mode 1)
(global-display-line-numbers-mode) ;; this one enables line numbers
(setq-default truncate-lines 1)
(setq warning-minimum-level :error)

;; Set the default font
(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 80)


;; theme settings - THESE DON't WORK IF YOU OVERRIDE THE CONSOLE SETTINGS I GUESS IN CYGWIN
(load-theme 'tango t) ;;pretty good, like a white/gray with green
;;(load-theme 'misterioso t)n


;; turn on syntax highlighting
;; (global-font-lock-mode 1)
(global-font-lock-mode t) ;; enable syntax highlighting for all modes
(dolist (pattern '("\\.bashrc\\'" "\\.bashrc_user\\'" "\\.sh\\'" "\\.bashrc_color\\'"))
  (add-to-list 'auto-mode-alist `(,pattern . shell-script-mode)))


;; WINDOW NAVIGATION
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))




;; BACKUPS
(setq backup-directory-alist '(("." . "~/.emacs.d/.saves"))) ; don't litter fs tree
(setq backup-by-copying t) ; don't clobber symlinks
(setq delete-old-versions t
	  kept-new-versions 6
      kept-old-versions 2
      version-control t) ; use versioned backups


;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
    (message "Let's stroll...."))


