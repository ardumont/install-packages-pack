(require 'package)

;; inactivate any proxy (got some trouble with authentication)
(setq url-proxy-services '(("no_proxy" . "work\\.com")))

(add-to-list 'package-archives
             '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

;; when wanting to install from only elpa or marmalade
;; (setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")  ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)

;; a utility function to help in installing emacs packages
(defun install-packs (packs)
  (unless package-archive-contents
          (package-refresh-contents))
  (dolist (p packs)
    (unless (package-installed-p p)
            (package-install p))))
