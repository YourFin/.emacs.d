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

;;; apperance file
(require 'apperance)

;;; Packages

(use-package markdown-mode :ensure t)
(use-package evil
  :ensure t
  :config (require 'evil-bindings))
(use-package helm :ensure t)
(use-package term :ensure t)
(use-package ace-jump-mode :ensure t)
(use-package projectile :ensure t)
(use-package helm-projectile :ensure t)
(use-package magit :ensure t)

; ace-flyspell
; flyspell
; ycm
; company mode
; ace-jump-mode
; ace-jump-helm-line

;(unless (package-installed-p 'use-package)
;  (package-refresh-contents)
;  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(require 'helm-config)

;;; global keybinds

(try-require 'global-bindings)

;;; Evil related stuff

;;; Themeing


(menu-bar-mode -1)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (tangotange-theme use-package tangotango-theme markdown-mode helm evil ace-jump-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
