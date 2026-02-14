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

;; Packages and runtime state stay in AppData/Roaming/.emacs.d/ (the default),
;; not in the repo.

;; Add repo's .emacs.d/ to load-path so (load "base") etc. find config files
(add-to-list 'load-path (concat my-emacs-repo "/.emacs.d"))

;; Load init from repo directly — no symlink needed
(setq user-init-file (concat my-emacs-repo "/.emacs"))
(load user-init-file)
