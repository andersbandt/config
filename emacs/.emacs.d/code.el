;;; code.el.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords: Syntax coding with emacs


;; CODING WITH EMACS
(setq c-basic-offset 4)

;; turn on syntax highlighting
;; (global-font-lock-mode 1)
(global-font-lock-mode t) ;; enable syntax highlighting for all modes
(add-to-list 'auto-mode-alist '("\\.bash\\'" . shell-script-mode))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4) ;; set tabs to be 4 spaces wide
(setq c-basic-offset 4) ; this line is critical for C based modes like .c and .php I guess
(setq-default indent-line-function 'insert-tab)

(electric-pair-mode 1)


;; turn on syntax highlighting
(global-font-lock-mode t) ;; enable syntax highlighting for all modes
(dolist (pattern '("\\.bashrc\\'" "\\.bashrc_user\\'" "\\.sh\\'" "\\.bashrc_color\\'"))
  (add-to-list 'auto-mode-alist `(,pattern . shell-script-mode)))



;; file templates
(add-hook 'find-file-hook 'auto-insert)
(add-to-list 'auto-mode-alist '("\\.ino\\'" . c++-mode)) ;; Associate .ino files with c++-mode


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


;; automatic insert Doxygen style header
(defun insert-doxygen-function-header ()
  "Insert a Doxygen function header at the point."
  (interactive)
  (insert "/**\n")
  (insert " * @brief \n")
  (insert " *\n")
  (insert " */\n"))
(global-set-key (kbd "C-c d") 'insert-doxygen-function-header)


;; random solution to multi-line commenting in StackExchange
;; (Doesn't show up when doing M-x) ??
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



;; STARTUP ECHO MESSAGE
(defun display-startup-echo-area-message ()
    (message "Sourced code.el...."))
