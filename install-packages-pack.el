;;; install-packages-pack.el --- Install routine
;;
;; Copyright 2014 Antoine R. Dumont
;;
;; Author: Antoine R. Dumont <eniotna.t AT gmail.com>
;; URL: https://github.com/ardumont/install-packages-pack
;; Version: 0.0.1
;; Package-Requires: ((dash "2.6.0"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;; Installation:
;;
;; (progn
;;   (switch-to-buffer
;;    (url-retrieve-synchronously
;;     "https://raw.githubusercontent.com/ardumont/install-packages-pack/master/install-packages-pack.el"))
;;   (package-install-from-buffer))
;;; Code:

(require 'package)

(mapc (lambda (repo) (add-to-list 'package-archives repo))
      '(("org"      . "http://orgmode.org/elpa/")
        ;; ("gnu"       . "http://elpa.gnu.org/packages/")
        ("melpa"     . "http://melpa.milkbox.net/packages/")
        ;; ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
        ;; ("tromey"    . "http://tromey.com/elpa/")
        ("marmalade" . "https://marmalade-repo.org/packages/")))

(eval-when-compile (unless package--initialized (package-initialize)))

;;;###autoload
(defun install-packages-pack/install-pack (pack)
  "A utility function to help in installing an Emacs package PACK."
  (let* ((pack-archives (if (null package-archive-contents)
                            (progn (package-refresh-contents)
                                   package-archive-contents)
                          package-archive-contents))
         (pack-available-p (assoc pack pack-archives)))
    (when (and pack-available-p (not (package-installed-p pack)))
      (package-install pack))))

;;;###autoload
(defun install-packages-pack/install-packs (packs)
  "A utility function to help installing a list PACKS of Emacs packages."
  (mapc #'install-packages-pack/install-pack packs))

(provide 'install-packages-pack)
;;; install-packages-pack.el ends here
