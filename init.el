(setq lisp-dir 
      (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path lisp-dir)

(require 'package-setup)

(defun try-require (name) 
  "Attepts to require a file, but doesn't break
   everything if there's something wrong with the
   file"
   (condition-case nil
                   (require name)
                   (error nil)))

(defvar my-prog-mode-hooks
  '(emacs-lisp-mode-hook)
  "Programming major modes for
 older versions of emacs")
(defun add-prog-hook
    (FUNC)
  "Adds to appopriate programming modes"
  (if (< emacs-version 24.1)
      (mapc (lambda (HOOK) (add-hook HOOK FUNC)) prog-mode-hooks)
      (add-hook 'prog-mode-hook FUNC)))

;;; apperance file
(try-require 'apperance)
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
; ace-flyspell
; flyspell
; ace-jump-mode
; ace-jump-helm-line

(use-package python)
(use-package python-django)
(use-package markdown-mode)

(use-package evil
  :config (require 'evil-bindings))


(eval-when-compile
  (require 'use-package))

(require 'helm-config)

(require 'completion)

;;; global keybinds

(try-require 'global-bindings)

;;; automatically wrap comments around correctly
(auto-fill-mode)
(setq comment-auto-fill-only-comments t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-quickhelp-mode t)
 '(global-ycmd-mode t)
 '(linum-format (quote dynamic))
 '(package-selected-packages
   (quote
    (git-gutter-fringe+ git-gutter sublimity adaptive-wrap ycmd company-ycm evil-magit helm-ag company-quickhelp company-jedi auto-package-update helm-smex smex company-ycmd emacs-ycmd python-django company jinja2-mode python-mode avy tangotange-theme use-package tangotango-theme markdown-mode helm evil ace-jump-mode)))
 '(projectile-mode t nil (projectile)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "ConsolasHacked" :foundry "MS  " :slant normal :weight normal :height 218 :width normal)))))
