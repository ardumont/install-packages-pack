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
(mapc 'package-install '(paradox dash names))

(require 'paradox)
(defvar install-packages-pack/paradox-setup-file (expand-file-name "~/.emacs.d/.paradox/setup.el")) ;; token installed manually the first time M-x paradox-list-packages is called

(when (file-exists-p (expand-file-name install-packages-pack/paradox-setup-file))
  (load-file install-packages-pack/paradox-setup-file))

(require 'dash)

(defun install-packages-pack/--filter-repositories (repos archives)
  "Given a list REPOS of couple (repository name, repository url) and a list of ARCHIVES, return the list of not associated entries."
  (--filter (not (assoc-default (car it) archives)) repos))

(defun install-packages-pack/update-repositories-archives! (repos)
  "Given a list of repositories REPOS, update the package-archives if only new repositories are present."
  (package-initialize)
  (-when-let (repos-to-add (install-packages-pack/--filter-repositories repos package-archives))
    (message "Repos to add: %s" repos-to-add)
    ;; we need to add the list of repos to the archives
    (mapc (lambda (repo) (add-to-list 'package-archives repo 'append)) repos-to-add)
    (message "new archive: %s" package-archives)
    ;; we need to refresh the packages index
    (package-refresh-contents)))

(install-packages-pack/update-repositories-archives! '(("org"      . "http://orgmode.org/elpa/")
                                                      ;; ("gnu"       . "http://elpa.gnu.org/packages/")
                                                      ("melpa"     . "http://melpa.milkbox.net/packages/")
                                                      ;; ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")
                                                      ;; ("tromey"    . "http://tromey.com/elpa/")
                                                      ("marmalade" . "http://marmalade-repo.org/packages/")
                                                      ))

(defun install-packages-pack/install-pack (pack)
  "A utility function to help in installing an Emacs package PACK."
  (unless (package-installed-p pack)
    (package-install pack)))

(defun install-packages-pack/install-packs (packs)
  "A utility function to help installing a list PACKS of Emacs packages."
  (->> packs
    (--filter (not (package-installed-p it)))
    (mapc 'install-packages-pack/install-pack)))

(provide 'install-packages-pack)
;;; install-packages-pack.el ends here
