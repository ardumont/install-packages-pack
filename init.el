(require 'package)

;; deactivate any proxy (got some trouble with authentication)
(setq url-proxy-services '(("no_proxy" . "work\\.com")))

(when (< emacs-major-version 24) (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))

;; marmalade as default (not melpa as some deps are unstable)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)

;; (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; when wanting to install from only elpa or marmalade
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")  ("marmalade" . "http://marmalade-repo.org/packages/")))

(defun install-pack (pack &optional init) "A utility function to help in installing emacs package."
  (unless (package-installed-p pack)
          (when init
                (package-refresh-contents)
                (package-initialize))
          (package-install pack)))

(install-pack 'dash 'do-initialize-package-system)

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
