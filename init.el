;;; install-packages-pack.el --- Install routine

;;; Commentary:

;;; Code:

(require 'package)

;; deactivate any proxy (got some trouble with authentication)
(defvar url-proxy-services '(("no_proxy" . "work\\.com")))


;; marmalade as default (not melpa as some deps are unstable)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; when wanting to install from only elpa or marmalade
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")  ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
(package-refresh-contents)

(defun install-pack (pack) "A utility function to help in installing emacs package."
  (unless (package-installed-p pack)
          (package-install pack)))

(install-pack 'dash)
(require 'dash)

(defvar *INSTALL-PACKAGES-PACK-BACKUP* nil)

(defun install-packages-pack/--install-temporary-package-archives (pack-archives) "When you need to install some dependencies from another repository you do not want as default (for example melpa)"
  (setq *INSTALL-PACKAGES-PACK-BACKUP* package-archives)
  (setq package-archives pack-archives)
  (package-refresh-contents))

(defun install-packages-pack/--reset-temporary-package-archives () "Reset to normal repo archives"
  (setq package-archives *INSTALL-PACKAGES-PACK-BACKUP*)
  (package-refresh-contents))

(defun install-packages-pack/--filter-packs-to-install (pack-archives) "Is there any pack from the list already installed?"
  (-filter (lambda (pack) (not (package-installed-p pack))) pack-archives))

(defun install-packs (packs &optional pack-archives) "A utility function to help in installing emacs packages."
  (-when-let (new-packs (install-packages-pack/--filter-packs-to-install packs))
             (let ((install-temporary-packages-p (and new-packs pack-archives)))
               (when install-temporary-packages-p (install-packages-pack/--install-temporary-package-archives pack-archives))
               (unless package-archive-contents (package-refresh-contents))
               (dolist (p new-packs) (install-pack p))
               (when install-temporary-packages-p (install-packages-pack/--reset-temporary-package-archives)))))

;;; install-packages-pack.el ends here
