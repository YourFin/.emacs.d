(provide 'completion)

;;; This lisp file handles installing and enabling
;;; various outside completion frameworks that
;;; I do not want installed on machines
;;; that do not need a full IDE. This file should
;;; not load if emacs is accessed through SSH

;; check to make sure that git is installed. If not,
;; install it locally
(let ((frameworks-dir (concat user-emacs-directory "frameworks/"))) 
  (unless (executable-find "git")
    (condition-case nil ; we don't care what throws an error in here
	(cond [(eq system-type 'darwin) ]
	      [(or (eq system-type 'ms-dos) (eq system-type windows-nt)) ]
					;[(eq system-type 'cygwin) ] TODO: implemnt cygwin
	      [t 
					; we're going to assume that if it isn't a
					; M$ or apple machine that 
					; the standard linux installation will work
					; and we can succsessfully install it
					; from source
	       (let ([git-install-dir-parent (concat user-emacs-directory "frameworks/")])
		 (shell-command (concat "cd " git-install-dir-parent))
		 (cond [(executable-find "curl")
			(shell-command "curl https://www.kernel.org/pub/software/scm/git/git-2.9.4.tar.xz > git.tar.xz")]
		       [(executable-find "wget")
			(shell-command "wget https://www.kernel.org/pub/software/scm/git/git-2.9.4.tar.xz -O git.tar.xz")]
		       [t (error "could not find download program")]
		       )
		 (shell-command "tar -zxf git.tar.gz")
		 (shell-command "cd ./git/")
		 (shell-command "./configure --prefix ~/.emacs.d/frameworks/git"))])
      ('error (message "Install git you numnut") (error "git not successfully installed"))))

  (unless (file-exists-p (concat frameworks-dir "ycmd/"))
    (shell-command (concat "git clone https://github.com/Valloric/ycmd " frameworks-dir))
    (shell-command (concat "cd " frameworks-dir "ycmd/"))
    ;; Instructions from https://github.com/Valloric/ycmd/README.md
    (shell-command "git submodule update --init --recursive")
    (let* ((config-command "./configure.py --clang-completer")
	  (config-add-if (lambda (command option-to-add)
			   (when (executable-find command)
			     (setq config-command (concat
						   config-command
						   option-to-add)))))
	  )
      (config-add-if "rustc" " --racer-completer")
      (config-add-if "go" " --gocode-completer")
      (config-add-if "npm" " --tern-completer")
      (config-add-if "mono" " --omnisharp-completer")
      (shell-command config-command)))
      
   )) 
