;;; base.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords:


;; No splash screen please ... jeez
(setq inhibit-startup-message t)



(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))



;; MANAGE PACKAGES
(require 'use-package)


;; Turn off mouse interface early in startup to avoid momentary display

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.

(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; Remove security vulnerability
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; Set path to dependencies
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)

;; SSH
(setq tramp-default-method "sshx")
(setq tramp-verbose 10)

(defun connect-remote()
  "Connect to a remote server via SSH and open a file"
  (interactive)
  (find-file "/ssh:anders@anders-ms-7a70:/home/anders/Documents/CCS/workspace_WWD/WWD_prog/wwd.c")
  (load "~/.emacs.d/code.el")
  (load "~/.emacs.d/lsp.el"))


;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "~/.emacs.d/custom.el" user-emacs-directory))
(load custom-file)

;; Settings for currently logged in user
;; (setq user-settings-dir
;;       (concat user-emacs-directory "~/.emacs.d/users/" user-login-name))
;; (add-to-list 'load-path user-settings-dir)

;; Add external projects to load path
(dolist (project (directory-files site-lisp-dir t "\\w+"))
  (when (file-directory-p project)
    (add-to-list 'load-path project)))

;; BACKUPS
(setq backup-directory-alist '(("." . "~/.emacs.d/.saves"))) ; don't litter fs tree
(setq backup-by-copying t) ; don't clobber symlinks
(setq delete-old-versions t
	  kept-new-versions 6
      kept-old-versions 2
      version-control t) ; use versioned backups


;; Write all autosave files in the tmp dir
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Don't write lock-files, I'm the only one here
(setq create-lockfiles nil)

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Setup packages
;; (require 'setup-package)

;; Edit plists
;; (require 'setup-plist)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(
     elm-mode
     magit
     magit
     markdown-mode
     use-package
     vertico
     wgrep
     whitespace-cleanup-mode
     yasnippet
     zprint-mode
     )))


;; (use-package vertico
;;   :init
;;   (vertico-mode)

;;   (setq minibuffer-prompt-properties
;;         '(read-only t cursor-intangible t face minibuffer-prompt))
;;   (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;;   (setq read-extended-command-predicate
;;         #'command-completion-default-include-p)

;;   (setq enable-recursive-minibuffers t)
;;   )



;; MANAGE FILE COMPLETION
(require 'ido)
(ido-mode t)


;; EDITOR STYLE SETTINGS
(line-number-mode 1)
(global-display-line-numbers-mode) ;; this one enables line numbers
(setq-default truncate-lines 1)
(setq warning-minimum-level :error)


;; Set the default font
(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 80)

;; theme settings - THESE DON't WORK IF YOU OVERRIDE THE CONSOLE SETTINGS I GUESS IN CYGWIN
;; (load-theme 'tango t) ;; light theme. white/gray with green
(load-theme 'misterioso t) ;; dark theme



;; AUTOCOMPLETION MANAGER
(require' helm)
(helm-mode 1) ; facultative
(global-set-key (kbd "M-x") 'helm-M-x)



;; WINDOW NAVIGATION
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))



;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
    (message "Let's stroll...."))

;; PROJECT MANAGEMENT
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
