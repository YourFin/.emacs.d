;;; Add filetype specific files to load path
(add-to-list 'load-path (file-truename "lisp/majorHooks"))

(defun yf-add-major-hook (REQUIREMENT HOOK)
  "Adds requiring REQUIREMENT to HOOK"
  (add-hook hook (lambda () (try-require requirement))))

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
  (let* ((acting-mode-name (symbol-name mode))
	 (hook-file-symbol-name (concat acting-mode-name "-hook"))
	 (hook-file-symbol-name-file (concat acting-mode-name "-file"))
	 (lisp-dir (file-truename (concat user-emacs-directory "/lisp")))
	 (major-hooks-file (concat lisp-dir "/major-mode-hooks.el"))
	 (hook-file-parent-dir (concat lisp-dir "/majorHooks"))
	 (hook-file-path (concat hook-file-parent-dir "/" hook-file-symbol-name-file ".el")))
    (if (file-exists-p hook-file-path)
	(find-file hook-file-path)
      ;; create the hook file dir if it doesn't exist
      (if (not (file-exists-p hook-file-parent-dir))
	  (make-directory hook-file-parent-dir t))
      (let ((major-mode-hooks-buffer
	     ;; This nonesense is here just to check if
	     ;;The buffer is already open, so it can be
	     ;;closed automatically if it wasn't and
	     ;;and left open if it was.
	     (-some (lambda (acting-buffer)
		      (if (string-equal hook-file-parent-dir
					(buffer-file-name acting-buffer))
			  acting-buffer))
		    (buffer-list)))
	    (insert-hook-require
	     (lambda ()
	       ;; Two movemnts as I'm not entirely sure where
	       ;;the cursor will end up after dumping file
	       ;;contents, and I don't want to figure this
	       ;;out. Forward line will never error out so
	       ;;forcing the cursor to move down too much
	       ;;isn't an issue.
	       (forward-line (count-lines (point-max) (point-min)))
	       (forward-line -3)
	       (insert (concat "(add-hook '" hook-file-symbol-name" (lambda () (require '" hook-file-symbol-name-file ")))\n"))
	       ))
	    (current-buffer (buffer-name)))
	(if (not major-mode-hooks-buffer)
	    (with-temp-buffer
	      (insert-file-contents major-hooks-file)
	      (funcall insert-hook-require)
	      (write-file major-hooks-file))
	  (set-buffer (find-file-existing major-hooks-file))
	  (funcall insert-hook-require)
	  (save-buffer)))
      (find-file hook-file-path)
      (insert (concat
	       ";;;;;;;;;;Automatically generated by yf-edit-major-mode-hook;;;;;;;;;;;\n\n\n(provide '"
	       hook-file-symbol-name-file ")"))
      (forward-line -2)
      (save-buffer))))

;;--------------------------------------------------
;;------------Automatically generated---------------
;;-----------DO NOT EDIT BELOW THIS LINE------------
;;--------------------------------------------------

(add-hook 'python-mode-hook (lambda () (require 'python-mode-file)))
(add-hook 'latex-mode-hook (lambda () (require 'latex-mode-file)))


(provide 'major-mode-hooks)
