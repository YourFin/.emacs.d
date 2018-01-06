;; Turn on evil for the love of god
(evil-mode 1)

;; jumping around
(use-package evil-anzu)
(use-package evil-ediff)
;; change terminal
(use-package evil-terminal-cursor-changer
  :if (not (display-graphic-p))
  :config (evil-terminal-cursor-changer-activate))
(use-package evil-indent-textobject)
(use-package evil-magit)

;; It's vim-surround but so much better!
(use-package evil-embrace
  :config
  (evil-embrace-enable-evil-surround-integration))

;; Our lord and savior-cleverparens
(use-package evil-cleverparens
  :config
  (require 'evil-cleverparens-text-objects)
  ;; TODO: move this to a lispy-mode file
  (mapc (lambda (lisp) (add-hook (intern lisp) #'evil-cleverparens-mode))
	'("clojure-mode-hook" "emacs-lisp-mode-hook" "scheme-mode-hook" "lisp-mode-hook")))

(use-package evil-iedit-state)
(use-package evil-matchit
  :config (global-evil-matchit-mode 1))

					; ----------- Space binds ------------ ;
;; unmap normal space
(define-key evil-motion-state-map " " nil)

(defun evil-space-bind (keys command)
  "Throws a space at the front of $keys
   and adds the binding to command to 
   evil-motion-state-map"
  (define-key evil-motion-state-map (kbd (concat "<SPC>" keys)) command))

(evil-space-bind " <SPC>" 'helm-smex)

;;files

(evil-space-bind "bb" 'save-buffer)
(evil-space-bind "bs" 'yf-switch-buffer)
(evil-space-bind "bS" 'helm-mini)
(evil-space-bind "bo" 'ranger)
(evil-space-bind "bO" 'helm-find-files)
(evil-space-bind "bx" 'kill-this-buffer)
(evil-space-bind "bX" 'kill-buffer)
(evil-space-bind "bl" 'evil-switch-to-windows-last-buffer)

;; Windows
(defun hsplit-recents ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-split)
  (evil-window-next 1)
  (yf-switch-buffer))

(defun vsplit-recents ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-vsplit)
  (evil-window-next 1)
  (yf-switch-buffer))

(defun hsplit-files ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-split)
  (evil-window-next 1)
  (ranger))

(defun vsplit-files ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-vsplit)
  (evil-window-next 1)
  (ranger))

(evil-space-bind "ww" 'evil-window-next)
(evil-space-bind "wj" 'evil-window-down)
(evil-space-bind "wk" 'evil-window-up)
(evil-space-bind "wl" 'evil-window-right)
(evil-space-bind "wh" 'evil-window-left)
(evil-space-bind "wx" 'evil-window-delete)
(evil-space-bind "wo" 'delete-other-windows)

(defvar yf/evilwin-hydra-stack nil)

(defun yf--evilwin-hydra-push (expr)
  (push `(lambda () ,expr) yf/evilwin-hydra-stack))

(defun yf--evilwin-hydra-pop ()
  (interactive)
  (let ((x (pop yf/evilwin-hydra-stack)))
    (when x
      (funcall x))))

(defhydra yf-evil-windows (:hint nil
				 :pre (winner-mode 1)
				 :post (redraw-display))
  "
Movement & RESIZE^^^^  
^ ^ _k_ ^ ^       _o__O_pen File  _C-o_nly win
_h_ ^✜^ _l_       _b__B_ Sw-Buffer  _x_ Delete this win
^ ^ _j_ ^ ^       _u_ _C-r_ undo    _s_plit _v_ertically"   

  ;; For some reason the evil
  ;; commands behave better than
  ;; the emacs ones
  ("j" evil-window-down)
  ("k" evil-window-up)
  ("l" evil-window-right)
  ("h" evil-window-left)
  ("J" evil-window-increase-height)
  ("K" evil-window-decrease-height)
  ("L" evil-window-increase-width)
  ("H" evil-window-decrease-width)
  ("u" winner-undo)
  ("C-r" (progn (winner-undo) (setq this-command 'winner-undo)))
  ("o" ranger  :color blue)
  ("O" helm-find-files)
  ("b" yf-switch-buffer  :color blue)
  ("B" yf-switch-buffer)
  ("C-o" delete-other-windows :color blue)
  ("x" delete-window)
  ("s" split-window-horizontally)
  ("v" split-window-vertically)
  ("SPC" nil  :color blue))

(define-key evil-normal-state-map (kbd "C-w") nil)
(define-key evil-motion-state-map (kbd "C-w") nil)
(define-key evil-insert-state-map (kbd "C-w") nil)
;; I'm sorry emacs users, but I can't not being
;; able to get to this from everywhere
(global-set-key (kbd "C-w") 'yf-evil-windows/body)

(evil-space-bind "g" 'magit-status)
;; Make finishing commits faster
(evil-define-minor-mode-key 'normal 'git-commit-mode
  "q" 'with-editor-finish
  "z" 'with-editor-cancel)

;; Projectile
(evil-space-bind "pa" 'helm-projectile-ag)
(evil-space-bind "ps" 'helm-projectile-switch-project)

;; Random utilities
(evil-space-bind "uc" 'helm-calcul-expression)
(evil-space-bind "ua" 'helm-apropos)
(evil-space-bind "ub" 'describe-key)
(evil-space-bind "uu" 'undo-tree-visualize)
(evil-space-bind "ur" 'redraw-display)
(evil-space-bind "ut" 'yf-run-outside-terminal)

;; helm kill ring
(evil-space-bind "k" 'helm-show-kill-ring)
;; mark ring
(evil-space-bind "m" 'helm-global-mark-ring)
(evil-space-bind "M" 'helm-mark-ring)
;; quickrun
(evil-space-bind "r" 'quickrun)


;; ---------- Misc Bindings ----------- ;

;; for everybody's sanity
(setq evil-want-Y-yank-to-eol t)

(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
;; As these binds make zero sense in visual line mode:
(evil-define-motion yf-visual-j (count)
  "Wrapper for `evil-next-visual-line' ignores the visual in visual-line mode"
  :type line
  (if (eq (evil-visual-type) 'line)
      (evil-next-line count)
    (evil-next-visual-line count))
  )
(evil-define-motion yf-visual-k (count)
  "Wrapper for `evil-previous-visual-line' ignores the visual in visual-line mode"
  :type line
  (if (eq (evil-visual-type) 'line)
      (evil-previous-line count)
    (evil-previous-visual-line count))
  )
(define-key evil-visual-state-map "j" 'yf-visual-j)
(define-key evil-visual-state-map "k" 'yf-visual-k)

(define-key evil-insert-state-map (kbd "M-j") 'evil-next-visual-line)
(define-key evil-insert-state-map (kbd "M-k") 'evil-previous-visual-line)
(define-key evil-insert-state-map (kbd "M-h") 'evil-backward-char)
(define-key evil-insert-state-map (kbd "M-l") 'evil-forward-char)
(define-key evil-insert-state-map (kbd "M-w") 'evil-forward-word)

;; swap these because I'm weird
(define-key evil-motion-state-map (kbd ",") 'goto-last-change)
(define-key evil-motion-state-map (kbd "g,") 'goto-last-change-reverse)
(define-key evil-motion-state-map (kbd ";") 'evil-repeat-find-char)
(define-key evil-motion-state-map (kbd "g;") 'evil-repeat-find-char-reverse)

(define-key evil-visual-state-map (kbd "<SPC>r") 'quickrun-region)

;; a holdover from my vim days
(define-key evil-normal-state-map (kbd "-j") 'evil-join)

;;; better search: Swiper!
;; Make swiper act like evil in terms
;; of where it leaves the cursor
(defun yf--swiper-advice (&rest r)
  (evil-search-previous))
(advice-add 'swiper :after #'yf--swiper-advice)
(define-key evil-motion-state-map (kbd "/") 'swiper)
(define-key swiper-map (kbd "C-j") 'down)
(defun yf-swipe-selection (start end)
  "Calls swiper with the text from START to END in the current buffer
Returns the current selection if called interactively"
  (interactive "r")
  (let ((selection (buffer-substring-no-properties start end)))
    (evil-exit-visual-state)
    (swiper selection)))
(define-key evil-visual-state-map (kbd "*") 'yf-swipe-selection)

(define-key swiper-map (kbd "M-j") 'ivy-next-line)
(define-key swiper-map (kbd "M-k") 'ivy-previous-line)
(define-key swiper-map (kbd "C-v") 'yank)
(define-key swiper-map (kbd "C-c") 'minibuffer-keyboard-quit)

(define-key evil-insert-state-map (kbd "C-y") 'yas-expand)

;; avy
(define-key evil-motion-state-map (kbd "J") 'evil-avy-goto-word-or-subword-1)
(define-key evil-normal-state-map (kbd "J") 'evil-avy-goto-word-or-subword-1)
(define-key evil-motion-state-map (kbd "K") 'evil-avy-goto-char-timer) 

;; Undo-tree
(defun yf--undo-tree-visualizer-advice (&rest r)
  (evil-local-mode 1))
(advice-add 'undo-tree-visualize :after #'yf--undo-tree-visualizer-advice)
(evil-define-key 'motion undo-tree-visualizer-mode-map (kbd "j") 'undo-tree-visualize-redo)
(evil-define-key 'motion undo-tree-visualizer-mode-map (kbd "k") 'undo-tree-visualize-undo)

;; Multiple cursors
(use-package evil-mc
  :config
  (global-evil-mc-mode 1))

;;;evil-delete stuff
(require 'evil-custom-reg)

;(define-key evil-normal-state-map (kbd "C-S-H")
;  (lambda () "Moves the cursor left and adds a cursor" (interactive)
;    (evil-backward-char)
;    (evil-mc-make-cursor-here)))
;
;(define-key evil-normal-state-map (kbd "C-S-L")
;  (lambda () "Moves the cursor right and adds a cursor" (interactive)
;    (evil-forward-char)
;    (evil-mc-make-cursor-here)))
;
;(define-key evil-normal-state-map (kbd "C-S-J")
;  (lambda () "Moves the cursor up and adds a cursor" (interactive)
;    (evil-next-line)
;    (evil-mc-make-cursor-here)))
;
;(define-key evil-normal-state-map (kbd "C-S-K")
;  (lambda () "Moves the cursor down and adds a cursor" (interactive)
;    (evil-previous-line)
;    (evil-mc-make-cursor-here)))

;;; Helm rebinds
(define-key helm-map (kbd "M-j") 'helm-next-line)
(define-key helm-map (kbd "M-k") 'helm-previous-line)
(define-key helm-map (kbd "M-l") 'helm-next-source)
(define-key helm-map (kbd "M-h") 'helm-previous-source)
(define-key helm-map (kbd "C-r") 'yank)
(define-key helm-map (kbd "C-l") 'helm-minibuffer-history)
(define-key helm-minibuffer-history-map (kbd "C-l") 'helm-keyboard-quit)

;;; Ranger
(defun yf--magit-clone-ranger (repository directory)
  "Closes magit if `yf/magit-clone-ranger' is non-nil
Intended to stop the magit window from appearing after
calling magit-clone from ranger."
  (interactive
   (let ((url (magit-read-string-ns "Clone repository")))
     (list url (read-directory-name
                "Clone to: " nil nil nil
                (and (string-match "\\([^/:]+?\\)\\(/?\\.git\\)?$" url)
                     (match-string 1 url))))))
  (magit-clone repository directory)
  (magit-mode-bury-buffer t))

(use-package ranger
  :config
  (ranger-override-dired-mode)
  (define-key ranger-normal-mode-map (kbd "+") 'dired-create-directory)
  (define-key ranger-normal-mode-map (kbd "c") 'yf--magit-clone-ranger)
  )

(provide 'evil-bindings)
