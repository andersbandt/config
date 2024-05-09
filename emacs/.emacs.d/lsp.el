;;; init.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords: lsp-mode coding


(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))



;; ADDED BY ANDERS FROM EXAMPLE
(desktop-save-mode 1)




;; create compilation window command
(defun my-create-compile-frame ()
  "Create a frame for compiling at the bottom of the screen."
  (interactive)
  (let* ((compile-frame-height 10) ;; Set the height of the compile frame as desired
         (compile-frame-y-pos (- (frame-height) compile-frame-height)))
    (setq compile-frame (make-frame '((name . "Compile")
                                      (height . ,compile-frame-height)
                                      (width . 100)
                                      (top . ,compile-frame-y-pos)
                                      (left . 0))))
    (select-frame-set-input-focus compile-frame)))

;; Bind a key to create the compile frame
(global-set-key (kbd "<f5>") 'my-create-compile-frame)




;; startup echo message
(defun display-startup-echo-area-message ()
    (message "Let's fucking lsp-mode!"))
