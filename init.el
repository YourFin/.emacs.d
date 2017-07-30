(setq lisp-dir 
      (expand-file-name "lisp" user-emacs-directory))
(add-to-list 'load-path lisp-dir)

; So I don't get barked at
; (package-initialize)

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
(require 'apperance)

;;; Packages

(use-package markdown-mode :ensure t)
(use-package evil
  :ensure t
  :config (require 'evil-bindings))
(use-package helm :ensure t
  :bind ("M-x" . helm-M-x))
(use-package term :ensure t)
(use-package avy :ensure t)
(use-package projectile :ensure t)
(use-package helm-projectile :ensure t)
(use-package magit :ensure t)

; ace-flyspell
; flyspell
; ycm
; company mode
; ace-jump-mode
; ace-jump-helm-line

(eval-when-compile
  (require 'use-package))

(require 'helm-config)

;;; global keybinds

(try-require 'global-bindings)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum-format (quote dynamic))
 '(package-selected-packages
   (quote
    (avy tangotange-theme use-package tangotango-theme markdown-mode helm evil ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
