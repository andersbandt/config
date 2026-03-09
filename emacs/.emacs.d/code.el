;;; code.el.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords: Syntax coding with emacs



;; Customize font-lock mode for c++-mode (following stuff is for Arduino files I think)
(defun my-c++-mode-hook ()
  (font-lock-add-keywords
   nil
   '(("\\<\\(HIGH\\|LOW\\|OUTPUT\\|INPUT\\|INPUT_PULLUP\\|byte\\|bool\\|int\\|char\\|long\\|unsigned\\|float\\|double\\|string\\|void\\|setup\\|loop\\|if\\|else\\|while\\|for\\|switch\\|case\\|break\\|continue\\|return\\|class\\|struct\\|public\\|private\\|protected\\|static\\|const\\|volatile\\|typedef\\)\\>"
      . font-lock-keyword-face)
     ("\\<\\(Serial\\|Wire\\|pinMode\\|digitalWrite\\|digitalRead\\|analogWrite\\|analogRead\\|delay\\|millis\\|micros\\|pinMode\\|digitalWrite\\|digitalRead\\|analogWrite\\|analogRead\\|attachInterrupt\\|detachInterrupt\\|interrupts\\|noInterrupts\\|EEPROM\\)\\>"
      . font-lock-builtin-face)))
  )

(add-hook 'c++-mode-hook 'my-c++-mode-hook)




;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MAIN SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; handle certain per file extension type
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode)) ;; Associate .ino files with c++-mode
(add-to-list 'auto-mode-alist '("\\.bash\\'" . shell-script-mode))
(dolist (pattern '("\\.bashrc\\'" "\\.bashrc_user\\'" "\\.sh\\'" "\\.bashrc_color\\'"))
  (add-to-list 'auto-mode-alist `(,pattern . shell-script-mode)))

;; turn on syntax highlighting
(global-font-lock-mode t) ;; enable syntax highlighting for all modes

;; automaticaly handles () and {}
(electric-pair-mode 1)

;; set up code folding
(hs-minor-mode)
;; Fold keybindings: C-c f 0 = fold all, C-c f j = unfold all
(global-set-key (kbd "C-c f 0") 'hs-hide-all)
(global-set-key (kbd "C-c f j") 'hs-show-all)


;; tabs and spacing rules
(setq-default indent-tabs-mode nil)
(setq-default indent-line-function 'insert-tab)

(setq-default tab-width 4) ;; set tabs to be 4 spaces wide
(setq c-basic-offset 4) ; this line is critical for C based modes like .c and .php I guess



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; COMPILATION SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; SET SYSTEM SPECIFIC COMMANDS
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
(setq compile-command "/home/anders/ti/ccs1270/ccs/utils/bin/gmake -C /home/anders/Documents/CCS/workspace_WWD/WWD_prog/Debug -k -j 8 all -O")



;; compilation window settings
(defun my-compilation-hook ()
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")
          (shrink-window (- h compilation-window-height)))))))

(add-hook 'compilation-mode-hook 'my-compilation-hook)

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



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TEMPLATES and STRING INSERTION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; file templates with find-file I guess ? used  auto-insert?
(add-hook 'find-file-hook 'auto-insert)


;; automatic insert Doxygen style header
(defun insert-doxygen-function-header ()
  "Insert a Doxygen function header at the point."
  (interactive)
  (insert "/**\n")
  (insert " * @brief \n")
  (insert " *\n")
  (insert " */\n"))
(global-set-key (kbd "C-c d") 'insert-doxygen-function-header)


;; Make RET inside block comments auto-continue with * and auto-close */
(defun my-c-comment-ret-setup ()
  (local-set-key (kbd "RET") 'c-context-line-break))
(add-hook 'c-mode-common-hook 'my-c-comment-ret-setup)

;; Advice to auto-close */ and insert * when pressing Enter after /*
(defun my-prettify-c-block-comment (orig-fun &rest args)
  (let* ((first-comment-line (looking-back "/\\*\\s-*.*"))
         (star-col-num (when first-comment-line
                         (save-excursion
                           (re-search-backward "/\\*")
                           (1+ (current-column))))))
    (apply orig-fun args)
    (when first-comment-line
      (save-excursion
        (newline)
        (dotimes (cnt star-col-num)
          (insert " "))
        (move-to-column star-col-num)
        (insert "*/"))
      (move-to-column star-col-num) ; comment this line if using bsd style
      (insert "*") ; comment this line if using bsd style
     ))
  ;; Ensure one space between the asterisk and the comment
  (when (not (looking-back " "))
    (insert " ")))
(advice-add 'c-indent-new-comment-line :around #'my-prettify-c-block-comment)
;; (advice-remove 'c-indent-new-comment-line #'my-prettify-c-block-comment)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; LSP MODE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TODO: figure out how to only load this section if we want "full"" startup?


;; Set lsp-mode specific packages
;;     company - this is the the autocompletion frontend
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))


(which-key-mode)
(add-hook 'python-mode-hook
	  (lambda ()
	    (auto-complete-mode 1)))
	  
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


