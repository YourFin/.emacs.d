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
  ;; "escape" single quotes
  (let ((clip-echo (concat "echo '" (replace-regexp-in-string "'" "'\"'\"'" INPUT-STRING) "' | ")))
    (message clip-echo)
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
	 ;; The -t is VERY NECESSARY and should not be cut.
	 ;; I do not understand why some of the various methods
	 ;; of running shell commands in emacs require this,
	 ;; but I'm not going to argue with it.
	 (concat clip-echo "xclip -selection clipboard -t UTF8_STRING -d '" display "'"))
	)
      )
     ((eq "darwin" system-type)
      (shell-command-to-string (concat clip-echo "pbcopy"))))))

(defun yf-kill-new-second-pos (string)
  "Make STRING the second kill in kill ring. Mainly to
be used in order to redo all of the evil delete commands
such that they don't overwrite what is in the system clipboard,
but are still accessable by `helm-show-kill-ring' and similar commands.

Obviously therefore given the intended use of this function, unlike `kill-new'
it does not worry about whether or not interprogram paste is set or not,
and always acts like it is not.

It also does not change the `kill-ring-yank-pointer', as it is expected that the
paste system clipboard buffer is still intended to be what the user wants
to yank.

Much of the code here is borrowed from `kill-new' in simple.el"

  ;; start stuff that is ripped straight from kill-new
  (unless (and kill-do-not-save-duplicates
	       ;; cadr instead of car
	       (equal-including-properties string (cadr kill-ring)))
    (if (fboundp 'menu-bar-update-yank-menu)
	(menu-bar-update-yank-menu string (and replace (car kill-ring))))
    (setcdr kill-ring (cons string (cdr kill-ring)))
    (if (> (length kill-ring) kill-ring-max)
	(set-cdr (nthcdr (1- kill-ring-max) kill-ring) kill-ring) nil)))

(provide 'shell-stuff)
