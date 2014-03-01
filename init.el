;;; install-packages-pack.el --- Install routine

;;; Commentary:

;;; Code:

(require 'package)
(require 'dash)

;; deactivate any proxy (got some trouble with authentication)
(defvar url-proxy-services '(("no_proxy" . "work\\.com")))

(defun --filter-repositories (repos archives) "Given a list of couple repository name, repository url, return the list of not associated entries."
  (--filter (not (assoc-default (car it) archives)) repos))

(defun update-repositories-archives! (repos)
  (package-initialize)
  "Given a list of repositories, update the package-archives if only new repositories are present"
  (-when-let (repos-to-add (--filter-repositories repos package-archives))
    (message "Repos to add: %s" repos-to-add)
    ;; we need to add the list of repos to the archives
    (--map (add-to-list 'package-archives it) repos-to-add)
    (message "new archive: %s" package-archives)
    ;; we need to refresh the packages index
    (package-refresh-contents)))

(update-repositories-archives! '(;; ("org"      . "http://orgmode.org/elpa/")
                                 ("gnu"       . "http://elpa.gnu.org/packages/")
                                 ("melpa"     . "http://melpa.milkbox.net/packages/")
                                 ;; ("tromey"    . "http://tromey.com/elpa/")
                                 ("marmalade" . "http://marmalade-repo.org/packages/")))

(defun install-pack (pack) "A utility function to help in installing emacs package."
  (unless (package-installed-p pack)
          (package-install pack)))

(defun install-packs (packs)
  "A utility function to help installing emacs packages."
  (->> packs
       (--filter (not (package-installed-p it)))
       (mapc 'install-pack)))

;;; install-packages-pack.el ends here
