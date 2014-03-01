;;; install-packages-pack.el --- Install routine

;;; Commentary:

;;; Code:

(require 'package)

;; deactivate any proxy (got some trouble with authentication)
(defvar url-proxy-services '(("no_proxy" . "work\\.com")))

(setq package-archives '(;; ("org"       . "http://orgmode.org/elpa/")
                         ("gnu"       . "http://elpa.gnu.org/packages/")
                         ("melpa"     . "http://melpa.milkbox.net/packages/")
                         ;; ("tromey"    . "http://tromey.com/elpa/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")))

(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(defun install-pack (pack) "A utility function to help in installing emacs package."
  (unless (package-installed-p pack)
          (package-install pack)))

(install-pack 'dash)
(require 'dash)

(defun install-packs (packs)
  "A utility function to help installing emacs packages."
  (->> packs
       (--filter (not (package-installed-p it)))
       (mapc 'install-pack)))

;;; install-packages-pack.el ends here
