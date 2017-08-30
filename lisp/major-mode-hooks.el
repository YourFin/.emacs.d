;;; Add filetype specific files to load path
(add-to-list 'load-path (file-truename "lisp/majorHooks"))

(defun yf-add-major-hook (REQUIREMENT HOOK)
  "Adds requiring REQUIREMENT to HOOK"
  (add-hook hook (lambda () (try-require requirement))))

(use-package xah-find)

;; symbol-name converts symbol to string nitwit
(defun yf-edit-major-mode-hook (&optional mode)
  "Edit the hook file for the MODE major mode. 
Current major mode if called by default or
if called interactively

If the file does not already exist, create it, add a
requirement statement to major-mode-hooks.el and 
create the file with a newline followed by an appropriate 
provide statement. 

The files take the form {name of MODE (sans -mode)}-hook.el
in .emacs.d/lisp/majorHooks

Note that this function does not check for the existance
of require statements in major-mode-hooks.el"
  (interactive (list major-mode))
  (let* ((hook-file-symbol-name (concat (symbol-name mode) "-hook"))
	 (hook-file-symbol (intern hook-file-symbol-name))
	 (hook-file-parent-dir ())
	 (hook-file-path (file-truename (concat "lisp/majorHooks/" hook-file-symbol-name ".el"))))
    (if (file-exists-p hook-file-path)
	(find-file hook-file-path)
      ;; This is very much a hack way to do this,
      ;;but it will work on windows, and I'm too
      ;;lazy to parse the source for xah-find-replace-text
      (xah-find-replace-text "\n(provide 'major-mode-hooks)"
			     (concat "(require '"
				     hook-file-symbol-name
				     ")\n\n(provide 'major-mode-hooks)")
			     
      (write-region
  
								  

(provide 'major-mode-hooks)
