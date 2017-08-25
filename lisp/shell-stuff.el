(defun yf-check-command-exists (COMMAND-NAME)
  "Checks whether or not COMMAND-NAME exists as an executable command"
  (interactive "sCommand to check: ")
  (let ((output (eq (call-process (yf-get-shell) nil nil nil "-c" (concat "command -v " COMMAND-NAME)) 0)))
    (if (called-interactively-p 'interactive)
	(message (if output "True" "False"))
      output)))

(defun yf-get-shell ()
  "Returns the shell in $SHELL, or sh if not found.
Assumes a *nix environment"
  (if (eq nil (getenv "SHELL")) "/bin/sh" (getenv "SHELL")))

(defun yf-shell-return-code (COMMAND)
  "Runs COMMAND in the default shell and returns it's return code."
  (call-process (yf-get-shell) nil nil nil "-c" COMMAND))

;;; Clipboard / Register nonsense
(defun yf-sys-clip-get ()
  "System-independent terminal-ready clipboard grabbing function. Does nothing to modify the clipboard"
  (let ((x-clip (lambda ()
		  (if (yf-check-command-exists "xclip")
		      (shell-command-to-string "xclip -o -selection clipboard")
		    nil ;TODO: (if (not (y-or-n-p "Attempt to install xclip locally?"))
		    )))
	)
    (cond ((eq "windows-nt" system-type) (shell-command (expand-file-name "frameworks/paste/paste.exe" user-emacs-directory))) ;untested

	  ;; from https://stackoverflow.com/questions/637005/how-to-check-if-x-server-is-running
	  ((eq 0 (yf-shell-return-code "xset q")) (funcall x-clip))
	  ((eq "darwin" system-type) (shell-command-to-string "pbpaste")))))

(defun yf-sys-clip-set (INPUT-STRING)
  "System-independent terminal-ready clipboard set function. Rather slow, so don't go using it all over the place."
  (redraw-display)
  (let ((clip-echo (concat "echo '" INPUT-STRING "' | ")))
    (cond 
     ;; We're just gonna assume that windows is going to be running the gui version of
     ;; emacs for now, as screw the windows command line.
     ((eq "windows-nt" system-type)
      (if (display-graphic-p)
	  (gui-set-selection 'CLIPBOARD INPUT-STRING)
	(message "Fix paste on windows plz")))
     ((eq 0 (yf-shell-return-code "xset q"))
      (let* ((displays
	      ;; I'm so sorry about this one.
	      ;;
	      ;; The
	      ;; ps aux | grep emacs | grep $(ps u | sed -n '2p' | sed -e 's/\\s.*$//') | awk '{print $2}'
	      ;; part grabs the processs id's of every command who's name contains emacs
	      ;; that the current user is running
	      ;; The for loop part then takes those process ID's, and grabs the display environment variable that they have, and the sort -u removes all duplicates.
	      (split-string (shell-command-to-string
			     "for processid in $(ps aux | grep emacs | grep $(ps u | sed -n '2p' | sed -e 's/\\s.*$//') | awk '{print $2}'); do cat /proc/$processid/environ 2>/dev/null | tr '\\0' '\\n' | grep '^DISPLAY=' | sed 's/^DISPLAY=//' ; done | sort -u")))
	     (display (cond ((eq 1 (length displays)) (car displays))
			    ((not (eq yf-clipboard-display nil)) yf-clipboard-display)
			    (t (set 'yf-clipboard-display
				    (ido-completing-read "Paste display (Local is :0): "
							 displays))
			       (make-variable-frame-local 'yf-clipboard-display)
			       yf-clipboard-display))))
	(call-process-shell-command
	 (concat clip-echo "xclip -selection clipboard -t UTF8_STRING -d '" display "'"))
	)
      )
     ((eq "darwin" system-type)
      (shell-command-to-string (concat clip-echo "pbcopy"))))))

(provide 'shell-stuff)
