;; windows-appdata-init.el
;; Place this file at C:\Users\<you>\AppData\Roaming\.emacs
;;
;; PURPOSE: Bootstrap for native Windows Emacs. Loads config directly from
;; the git repo, bypassing HOME symlinks (Cygwin symlinks are not readable
;; by native Windows Emacs).
;;
;; SETUP: Update my-emacs-repo below to match your repo location, then
;; run setup.sh from Cygwin — it will copy this file to AppData/Roaming/.emacs.

(defconst my-emacs-repo "C:/Users/ander/Documents/GitHub/config/emacs")

(setenv "HOME" "C:/Users/ander/")
(setq default-directory "C:/Users/ander/")

;; Setting HOME above causes ~/ to resolve to C:/Users/ander/, which would break
;; the default user-emacs-directory. Pin it explicitly so packages stay in AppData.
(setq user-emacs-directory "C:/Users/ander/AppData/Roaming/.emacs.d/")

;; Add repo's .emacs.d/ to load-path so (load "base") etc. find config files
(add-to-list 'load-path (concat my-emacs-repo "/.emacs.d"))

;; Load init from repo directly — no symlink needed
(setq user-init-file (concat my-emacs-repo "/.emacs"))
(load user-init-file)
