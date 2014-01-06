(require 'package)

;; deactivate any proxy (got some trouble with authentication)
(setq url-proxy-services '(("no_proxy" . "work\\.com")))

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; marmalade as default (not melpa as some deps are unstable)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
;; (add-to-list 'package-archives
;;              '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; when wanting to install from only elpa or marmalade
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")  ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)

(defvar *INSTALL-PACKAGES-PACK-BACKUP* nil)

(defun install-packages-pack/--install-package-archives (pack-archives)
  (setq *INSTALL-PACKAGES-PACK-BACKUP* package-archives)
  (setq package-archives pack-archives)
  (package-refresh-contents))

(defun install-packages-pack/--reset-package-archives ()
  (setq package-archives *INSTALL-PACKAGES-PACK-BACKUP*)
  (package-refresh-contents))

(defun install-pack (p) "A utility function to help in installing emacs package."
  (unless (package-installed-p p) (package-install p)))

(defun install-packs (packs &optional pack-archives) "A utility function to help in installing emacs packages."
  (when pack-archives (install-packages-pack/--install-package-archives pack-archives))
  (unless package-archive-contents (package-refresh-contents))
  (dolist (p packs) (install-pack p))
  (when pack-archives (install-packages-pack/--reset-package-archives)))
