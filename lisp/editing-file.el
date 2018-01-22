
;;----This file dedicated to various editing tweaks that aren't evil related----;;

(defvar yf/terminal-command (cond ((eq system-type 'gnu/linux) "xterm")
				 ((eq system-type 'darwin) "echo '
echo '\"'\"'
on run argv
  if length of argv is equal to 0
    set command to \"\"
  else
    set command to item 1 of argv
  end if

  tell application \"Terminal\"
    activate
    set newTab to do script(command)
  end tell
  return newTab
end run
'\"'\"' | osascript - \"$2\" > /dev/null' | sh")
				 ;; Partially stolen from:
				 ;; https://web.archive.org/web/20171029205649/https://stackoverflow.com/questions/4404242/programmatically-launch-terminal-app-with-a-specified-command-and-custom-colors
				 ;; I feel disgusting
				 ;; TODO: figure out how the **** this works on windoze
				   (t "#"))
  "The command called when pulling up an outside terminal. Should not include a -e flag. Used by `yf-run-outside-terminal'")

(defvar yf/default-shell "$(which zsh || which fish || which bash || which sh)" "The default command run for yf-run-outside-terminal")
(defvar yf/run-outside-terminal-default-dir "the default directory for `yf-run-outside-terminal'
In place for buffers that don't have files associated with them, i.e. Messages")
(defvar yf/run-outside-terminal-daemonize t
  "Whether to fork called terminals such that killing emacs will not kill them")

(defun yf-run-outside-terminal (directory &optional external-command)
  "Open a terminal in the directory containing the current buffer.
If EXTERNAL-COMMAND is set, pass that through to the shell with the -e flag. Ignored on windows.
Terminal command is stored in `yf/terminal-command'"
  (interactive (list (let ((open-file (buffer-file-name (current-buffer))))
		       (cond ((not open-file) yf/run-outside-termial-default-dir)
			     ((file-directory-p open-file) open-file)
			     ((file-exists-p open-file)  (file-name-directory open-file))))))
  (let* ((run-command (or external-command yf/default-shell))
	 (bash-command (concat
			"cd " directory " && "
			yf/terminal-command
			" -e " run-command
			(if yf/run-outside-terminal-daemonize "&"))))
    (if yf/run-outside-terminal-daemonize
	(start-process
	 (concat "Terminal--" directory "--" external-command) ;; name the process something reasonable
	 nil;; blackhole output
	 "nohup"
	 "bash"
	 "-c"
	 bash-command)
      (start-process
       (concat "Terminal--" directory "--" external-command)
       nil
       "bash"
       "-c"
       bash-command))))

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

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode 1))
(use-package dtrt-indent
  :config
  (add-hook 'prog-mode-hook #'dtrt-indent-mode))

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package whitespace-cleanup-mode
  :config
  (global-whitespace-cleanup-mode))

(use-package flycheck
  :config
  (with-eval-after-load 'flycheck
    (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))))

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

;; Enable window history
(add-hook 'after-init-hook 'winner-mode)

(defhydra yf-spellcheck (:body-pre (flyspell-prog-mode)
	   :post (flyspell-mode-off))
  "Spellchecking!"
  ("n" evil-next-flyspell-error)
  ("N" evil-prev-flyspell-error)
  ("a" yf-add-word-to-dictinary)
  ("c" flyspell-auto-correct-previous-word))

(use-package undo-tree
  :config
  ;; Persistent undo
  (setq undo-tree-save-history t))

(use-package quickrun
  :config
  (setq quickrun-focus-p nil))

;;; Git
(use-package magit
  :config
  (magit-auto-revert-mode -1)
  (global-auto-revert-mode -1)
  (add-hook 'after-init-hook 'magit-file-mode-turn-on)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))
;;(use-package magithub
;;  :after magit
;;  :config (magithub-feature-autoinject t))

(use-package atomic-chrome
  :config
  (add-hook 'after-init-hook 'atomic-chrome-start-server))

;; Better buffer names
(require 'uniquify)

;;;Variable Sets
;; I'm sorry RMS but you're wrong about this one
(setq sentence-end-double-space nil)

(provide 'editing-file)
