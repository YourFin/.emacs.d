
;;----------Various editing tweaks that aren't evil related------------;;

(use-package smartparens
  :config
  ;;taken from http://web.archive.org/web/20170912005704/https://github.com/Fuco1/smartparens/issues/286
  (sp-with-modes sp-lisp-modes
    ;; disable ', it's the quote character!
    (sp-local-pair "'" nil :actions nil)
    ;; also only use the pseudo-quote inside strings where it serve as
    ;; hyperlink.
    (sp-local-pair "`" "'" :when '(sp-in-string-p sp-in-comment-p))
    (sp-local-pair "`" nil
		   :skip-match (lambda (ms mb me)
				 (cond
				  ((equal ms "'")
				   (or (sp--org-skip-markup ms mb me)
				       (not (sp-point-in-string-or-comment))))
				  (t (not (sp-point-in-string-or-comment)))))))
  (add-hook 'prog-mode-hook 'smartparens-mode))

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package flycheck
  :config
  (with-eval-after-load 'flycheck
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
  (global-flycheck-mode))

(add-hook 'prog-mode-hook 'flyspell-prog-mode)
(setq flyspell-prog-text-faces '(font-lock-comment-face font-lock-doc-face))

(use-package swiper)

(use-package hydra)
(use-package yatemplate
  :defer 2
  :config
  (auto-insert-mode)
  (yatemplate-fill-alist))

(defun yf-add-word-to-dictionary ()
  (interactive)
  (let ((current-location (point))
         (word (flyspell-get-word)))
    (when (consp word)    
      (flyspell-do-correct 'save nil (car word) current-location (cadr word) (caddr word) current-location))))

(defhydra yf-spellcheck (:body-pre (flyspell-prog-mode)
	   :post (flyspell-mode-off))
  "Spellchecking!"
  ("n" evil-next-flyspell-error)
  ("N" evil-prev-flyspell-error)
  ("a" yf-add-word-to-dictinary)
  ("c" flyspell-auto-correct-previous-word))

(use-package quickrun)
(use-package iedit)

(provide 'editing-file)
