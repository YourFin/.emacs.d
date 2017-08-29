
;;; This lisp file handles installing and enabling
;;; various outside completion frameworks that
;;; I do not want installed on machines
;;; that do not need a full IDE. This file should
;;; not load if emacs is accessed through SSH

(use-package company 
  :config
  (add-hook 'prog-mode-hook 'company-mode)
  (setq company-idle-delay 0)
)
(use-package company-quickhelp
  :config
  (company-quickhelp-mode 1)
  (setq company-quickhelp-delay 0.5))


(cond (t
	(use-package ycmd
		     :config
		     (setq ycmd-server-command (concat "python3" (file-truename "~/.emacs.d/frameworks/ycmd/ycmd/"))
		     (add-hook 'after-init-hook 'global-ycmd-mode)))
	(use-package company-ycmd
		     :config (company-ycmd-setup)))
      ;;todo: other systems
      )

(provide 'completion)
