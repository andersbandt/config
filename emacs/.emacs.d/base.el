;;; base.el ---                                      -*- lexical-binding: t; -*-

;; Copyright (C) 2024  U-DESKTOP-F81D59A\ander

;; Author: U-DESKTOP-F81D59A\ander <ander@DESKTOP-F81D59A>
;; Keywords:


;; No splash screen please ... jeez
;; (setq inhibit-startup-message t)



;; Keep emacs Custom-settings in separate file
;; NOTE: must be set before package-initialize so Emacs knows where to
;; persist package-selected-packages (avoids "temporarily" warning).
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;; Comment/uncomment this line to enable MELPA Stable if desired.  See `package-archive-priorities`
;; and `package-pinned-packages`. Most users will not need or want to do this.
;;(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)
;; If there are no archived package contents, refresh them
(when (not package-archive-contents)
  (package-refresh-contents))

;; Auto-install missing packages on startup
(defvar my-required-packages
  '(;; General
    elm-mode
    helm
    magit
    markdown-mode
    projectile
    use-package
    vertico
    wgrep
    whitespace-cleanup-mode
    yasnippet
    zprint-mode
    ;; LSP / completion
    lsp-mode
    lsp-treemacs
    helm-lsp
    company
    flycheck
    which-key
    dap-mode))

(defvar my--packages-refreshed nil
  "Non-nil if package archives have been refreshed this session.")

(dolist (pkg my-required-packages)
  (unless (package-installed-p pkg)
    (condition-case _err
        (package-install pkg)
      (file-error
       ;; Stale cache — refresh once and retry
       (unless my--packages-refreshed
         (package-refresh-contents)
         (setq my--packages-refreshed t))
       (package-install pkg)))))

(require 'use-package)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GENERAL SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Turn off mouse interface early in startup to avoid momentary display
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))


;; Remove security vulnerability
(eval-after-load "enriched"
  '(defun enriched-decode-display-prop (start end &optional param)
     (list start end)))


;; Set path to dependencies
(setq site-lisp-dir
      (expand-file-name "site-lisp" user-emacs-directory))

(setq settings-dir
      (expand-file-name "settings" user-emacs-directory))

;; Set up load path
(add-to-list 'load-path settings-dir)
(add-to-list 'load-path site-lisp-dir)


;; Add external projects to load path
(when (file-directory-p site-lisp-dir)
  (dolist (project (directory-files site-lisp-dir t "\\w+"))
    (when (file-directory-p project)
      (add-to-list 'load-path project))))


;; BACKUPS
(setq backup-directory-alist `(("." . ,(expand-file-name ".saves" user-emacs-directory)))) ; don't litter fs tree
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
;;(set-face-attribute 'default nil :font "DejaVu Sans Mono" :height 80)

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

;; PROJECT MANAGEMENT
(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; MARKDOWN SETTINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Hide URLs in links so [text](url) shows just "text"
(setq markdown-hide-urls t)

;; Enable LaTeX math rendering: $inline$ and $$display$$ get fontified
;; TODO: Install LaTeX (MiKTeX or texlive) + dvipng, then add texfrag-mode
;;       for actual rendered math overlays in GUI Emacs. Currently just
;;       syntax-highlights math fragments.
(setq markdown-enable-math t)

;; Use nicer unicode bullets for list items instead of plain dashes
;; TODO: NOT WORKING as of Apr 2026 — bullets still render as dashes.
;;       May need font support or a display-table approach instead.
(setq markdown-list-item-bullets '("●" "○" "◆" "◇"))

;; Style tweaks for markdown faces (on top of misterioso theme)
(custom-set-faces
 ;; HR: use overline + extend to span the full window width
 ;; TODO: NOT WORKING as of Apr 2026 — HR line still does not extend across
 ;;       the whole page. The :extend t flag and :overline approach didn't help.
 ;;       May need a different approach (e.g., overlay with display property).
 '(markdown-hr-face ((t (:foreground "gray50" :overline "gray50" :height 0.1 :extend t))))
 ;; ==highlight== markup (custom face, see font-lock rule below)
 '(markdown-highlight-face ((t (:background "yellow" :foreground "black"))))
 ;; Bold: salmon
 '(markdown-bold-face ((t (:inherit bold :foreground "salmon"))))
 ;; Italic: super-light salmon (softer tint, paired with bold's salmon)
 '(markdown-italic-face ((t (:slant italic :foreground "misty rose"))))
 ;; Inline `code`: subtle lighter background so it pops from prose
 '(markdown-inline-code-face ((t (:background "#3a4654" :foreground "#d6e0eb"))))
 ;; Fenced code blocks: slightly recessed background
 '(markdown-pre-face ((t (:background "#252d36" :foreground "#d6e0eb"))))
 ;; ```lang fence tag
 '(markdown-language-keyword-face ((t (:foreground "light steel blue" :slant italic))))
 ;; Links: sky blue, underlined (URL is hidden via markdown-hide-urls)
 '(markdown-link-face ((t (:foreground "light sky blue" :underline t))))
 '(markdown-url-face ((t (:foreground "gray55"))))
 ;; Blockquotes: italic, muted gray
 '(markdown-blockquote-face ((t (:slant italic :foreground "gray70"))))
 ;; Headers: rainbow by level (H1 red → H6 purple)
 '(markdown-header-face-1 ((t (:inherit markdown-header-face :foreground "red"))))
 '(markdown-header-face-2 ((t (:inherit markdown-header-face :foreground "orange"))))
 '(markdown-header-face-3 ((t (:inherit markdown-header-face :foreground "khaki"))))
 '(markdown-header-face-4 ((t (:inherit markdown-header-face :foreground "dark sea green"))))
 '(markdown-header-face-5 ((t (:inherit markdown-header-face :foreground "deep sky blue"))))
 '(markdown-header-face-6 ((t (:inherit markdown-header-face :foreground "medium purple")))))

;; Add ==highlight== syntax support (not built into markdown-mode)
(defface markdown-highlight-face
  '((t (:background "yellow" :foreground "black")))
  "Face for ==highlighted== text in markdown.")

(defun my-markdown-add-highlight-font-lock ()
  "Add font-lock rule for ==highlighted== text in markdown."
  (font-lock-add-keywords nil
    '(("==\\([^=\n]+\\)==" 0 'markdown-highlight-face prepend))))

(add-hook 'markdown-mode-hook #'my-markdown-add-highlight-font-lock)

;; ---------------------------------------------------------------------------
;; Ordered list: auto-convert numbers <-> letters when indenting/outdenting
;; ---------------------------------------------------------------------------
;; Convention: top-level = 1. 2. 3.  |  nested = a. b. c.
;; Deeper nesting alternates: even depth = numbers, odd depth = letters.
;;
;; Key bindings (set at the bottom of this block):
;;   Tab       — on a list item: indent (demote) + convert marker
;;   Shift-Tab — on a list item: outdent (promote) + convert marker
;;   M-RET     — insert new list item (built-in), then convert if needed

(defun my-markdown--nesting-depth ()
  "Return the nesting depth of the list item at point (0 = top-level)."
  (let ((bounds (markdown-cur-list-item-bounds)))
    (if bounds
        (/ (nth 2 bounds) markdown-list-indent-width)
      0)))

(defun my-markdown--number-to-letter (n)
  "Convert number N (1-26) to lowercase letter string."
  (char-to-string (+ ?a (1- (min n 26)))))

(defun my-markdown--letter-to-number (letter)
  "Convert lowercase LETTER string to number (1-26)."
  (1+ (- (string-to-char letter) ?a)))

(defun my-markdown--count-previous-siblings ()
  "Count how many siblings exist before the current list item at the same indent.
Returns 0 if this is the first item at this indent level."
  (let* ((bounds (markdown-cur-list-item-bounds))
         (cur-indent (and bounds (nth 2 bounds)))
         (count 0))
    (when cur-indent
      (save-excursion
        (forward-line -1)
        (while (not (bobp))
          (let ((b (markdown-cur-list-item-bounds)))
            (cond
             ;; Same indent = a sibling, count it
             ((and b (= (nth 2 b) cur-indent))
              (setq count (1+ count))
              (forward-line -1))
             ;; Less indent = parent, stop
             ((and b (< (nth 2 b) cur-indent))
              (goto-char (point-min)))  ; break
             ;; More indent or blank line = child/gap, skip
             (t (forward-line -1)))))))
    count))

(defun my-markdown--convert-marker-on-line ()
  "Convert the list marker on the current line based on nesting depth.
Even depth -> numbers, odd depth -> letters.
The value is determined by counting previous siblings, not by the
existing marker number (which may be wrong after indent/outdent)."
  (let ((depth (my-markdown--nesting-depth)))
    (save-excursion
      (beginning-of-line)
      (cond
       ;; Odd depth: should be a letter — convert if currently a number
       ((and (cl-oddp depth)
             (looking-at "^\\([ \t]*\\)\\([0-9]+\\)\\(\\.[ \t]\\)"))
        (let* ((pos (1+ (my-markdown--count-previous-siblings)))
               (letter (my-markdown--number-to-letter pos)))
          (replace-match (concat (match-string 1) letter (match-string 3)))))
       ;; Even depth: should be a number — convert if currently a letter
       ((and (cl-evenp depth)
             (looking-at "^\\([ \t]*\\)\\([a-z]\\)\\(\\.[ \t]\\)"))
        (let* ((pos (1+ (my-markdown--count-previous-siblings))))
          (replace-match (concat (match-string 1)
                                 (number-to-string pos)
                                 (match-string 3)))))))))

;; Advice on the low-level demote/promote functions so conversion fires
;; regardless of how they're invoked (Tab, C-c <right>, etc.)
(defun my-markdown--after-demote (&rest _)
  "After indenting a list item, convert its marker."
  (my-markdown--convert-marker-on-line))

(defun my-markdown--after-promote (&rest _)
  "After outdenting a list item, convert its marker."
  (my-markdown--convert-marker-on-line))

(advice-add 'markdown-demote-list-item :after #'my-markdown--after-demote)
(advice-add 'markdown-promote-list-item :after #'my-markdown--after-promote)

;; After M-RET inserts a new list item, convert if at odd depth.
;; markdown-insert-list-item only knows about numeric markers, so a new
;; item after "a. foo" gets "1. " or "2. " — we convert to the right letter.
(defun my-markdown--after-insert-list-item (&rest _)
  "After inserting a new list item, convert to letter if at odd nesting depth."
  (my-markdown--convert-marker-on-line))

(advice-add 'markdown-insert-list-item :after #'my-markdown--after-insert-list-item)

;; Tab: indent list item (calls markdown-demote-list-item which triggers
;; the advice above), or fall back to default markdown-cycle behavior.
(defun my-markdown-indent-list-item-or-cycle ()
  "On a list item, indent it. Otherwise do the normal Tab action."
  (interactive)
  (if (markdown-cur-list-item-bounds)
      (markdown-demote-list-item)
    (markdown-cycle)))

;; Shift-Tab: outdent list item, or fall back to default shifttab behavior.
(defun my-markdown-unindent-list-item-or-shifttab ()
  "On a list item, outdent it. Otherwise do the normal Shift-Tab action."
  (interactive)
  (if (markdown-cur-list-item-bounds)
      (markdown-promote-list-item)
    (markdown-shifttab)))

(with-eval-after-load 'markdown-mode
  (define-key markdown-mode-map (kbd "TAB") #'my-markdown-indent-list-item-or-cycle)
  (define-key markdown-mode-map (kbd "<tab>") #'my-markdown-indent-list-item-or-cycle)
  (define-key markdown-mode-map (kbd "<S-tab>") #'my-markdown-unindent-list-item-or-shifttab)
  (define-key markdown-mode-map (kbd "<backtab>") #'my-markdown-unindent-list-item-or-shifttab))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; DAILY NOTES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar my-daily-notes-dir "~/Notes/daily/"
  "Directory for daily notes.")

(defun my-open-daily-note ()
  "Open (or create) today's daily note."
  (interactive)
  (let ((filepath (expand-file-name
                   (format-time-string "%Y-%m-%d.md") my-daily-notes-dir)))
    (unless (file-directory-p my-daily-notes-dir)
      (make-directory my-daily-notes-dir t))
    (find-file filepath)
    (when (= (buffer-size) 0)
      (insert (format-time-string "# %Y-%m-%d\n\n")))))

(global-set-key (kbd "C-c n d") 'my-open-daily-note)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; WINDOW MANAGEMENT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Vertical shrink window (complement to C-x ^ for enlarge)
(global-set-key (kbd "C-x _") 'shrink-window)
