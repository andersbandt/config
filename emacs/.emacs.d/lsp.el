;;; ilsp.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords: lsp-mode coding


;; LOAD CODE SETTINGS
(load "code")


;; Set lsp-mode specific packages
;;     company - this is the the autocompletion frontend
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))


(which-key-mode)

;; On Windows, pylsp lives in the Python Scripts folder which isn't on Emacs's PATH.
;; Set the full path here. Find it with: where pylsp (in cmd/powershell)
(when (eq system-type 'windows-nt)
  (setq lsp-pylsp-server-command
        '("C:/Users/ander/AppData/Local/Programs/Python/Python312/Scripts/pylsp.exe"))



(add-hook 'python-mode-hook 'lsp)
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
  (add-hook 'lsp-mode-hook #'company-mode)
  (require 'dap-cpptools)
  (yas-global-mode))



;; startup echo message
(defun display-startup-echo-area-message ()
    (message "Let's fucking lsp-mode!"))
