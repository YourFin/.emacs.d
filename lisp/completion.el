(provide 'completion)

;;; This lisp file handles installing and enabling
;;; various outside completion frameworks that
;;; I do not want installed on machines
;;; that do not need a full IDE. This file should
;;; not load if emacs is accessed through SSH

(use-package company 
  :config (add-hook 'prog-mode-hook 'company-mode))

(use-package emacs-ycmd)
(use-package company-ycmd
  :config (company-ycmd-setup))
