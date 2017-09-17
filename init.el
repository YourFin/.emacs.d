;;; init.el --- Summary:
;; my dog gone init.el file.
;;; Commentary:
;; my dog gone init.el file.  Enough said.
;;; Code:
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
(package-initialize)

(defvar lisp-dir (expand-file-name "lisp" user-emacs-directory) "Lisp file dir.")
(add-to-list 'load-path lisp-dir)

;;; Get packages setup
(require 'package-setup)

;;;No littering!
(use-package no-littering)
(setq auto-save-file-name-transforms
      `((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
(require 'recentf)
(add-to-list 'recentf-exclude no-littering-var-directory)
(add-to-list 'recentf-exclude no-littering-etc-directory)

;;; custom lib
(require 'custom-commands)
;;; apperance file
(require 'apperance)
(use-package auto-package-update
  :config
  (setq auto-package-update-delete-old-versions t
	auto-package-update-interval 4)
  (auto-package-update-maybe))
;;; Packages
(use-package helm
  :config
  (add-hook 'after-init-hook 'helm-mode))
(use-package term)
(use-package avy)
(use-package projectile)
(use-package helm-projectile)
(use-package magit
  :config
  (magit-auto-revert-mode -1)
  (global-auto-revert-mode -1)
  (add-hook 'after-init-hook 'magit-file-mode-turn-on)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
(use-package smex)
(use-package helm-smex
  :config (setq helm-smex-show-bindings t)
  :bind ("M-x" . helm-smex))
;; to add to the pile
;; ace-flyspell
;; flyspell

(use-package python)
(use-package python-django)
(use-package markdown-mode)

(require 'editing-file)

(setq find-function-C-source-directory (concat (getenv "emacs_home") "/path/to/source-dir"))

(use-package evil
  :config (require 'evil-bindings))

(eval-when-compile
  (require 'use-package))

(require 'helm-config)
(require 'completion)
(require 'global-bindings)
(require 'major-mode-hooks)


;; machine specific
(let* ((machine-dir (expand-file-name "lisp/systems/" user-emacs-directory))
       (machine-file (concat machine-dir system-name ".el")))
  (when (file-readable-p machine-file)
    (load-file machine-file)))

;; do not touch
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-mode t)
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(global-ycmd-mode t)
 '(linum-format (quote dynamic))
 '(nyan-mode t)
 '(package-selected-packages
   (quote
    (lua-mode company-math yatemplate iedit YATemplate evil-iedit-state hydra no-littering swiper-helm helm-flycheck xclip flycheck evil-mc smart-mode-line nyan-mode latex-preview-pane smartparens xah-find ranger git-gutter-fringe+ git-gutter sublimity adaptive-wrap ycmd company-ycm evil-magit helm-ag company-quickhelp company-jedi auto-package-update helm-smex smex company-ycmd emacs-ycmd python-django company jinja2-mode python-mode avy tangotange-theme use-package tangotango-theme markdown-mode helm evil ace-jump-mode)))
 '(projectile-mode t nil (projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#2e3434" :foreground "#eeeeec" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 218 :width normal :foundry "nil" :family "ConsolasHacked")))))

(provide 'init)
;;; init.el ends here
