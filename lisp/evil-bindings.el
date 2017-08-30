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
(use-package ranger
  :config (ranger-override-dired-mode))

;;; for everybody's sanity
(setq evil-want-Y-yank-to-eol t)

;;;; Space bindings
;; unmap normal space
(define-key evil-motion-state-map " " nil)

(defun evil-space-bind (keys command)
  "Throws a space at the front of $keys
   and adds the binding to command to 
   evil-motion-state-map"
  (define-key evil-motion-state-map (kbd (concat "<SPC>" keys)) command))

(evil-space-bind " <SPC>" 'helm-smex)

;;files

(defun yf-switch-buffer ()
  (interactive)
  (if (projectile-project-p)
      (helm-projectile)
    (helm-mini)))

(evil-space-bind "bb" 'save-buffer)
(evil-space-bind "bs" 'yf-switch-buffer)
(evil-space-bind "bS" 'helm-buffers-list)
(evil-space-bind "bo" 'ranger)
(evil-space-bind "bO" 'helm-find-files)
(evil-space-bind "bx" 'kill-buffer)

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
(evil-space-bind "wW" 'evil-window-prev)
(evil-space-bind "wj" 'evil-window-down)
(evil-space-bind "wk" 'evil-window-up)
(evil-space-bind "wl" 'evil-window-right)
(evil-space-bind "wh" 'evil-window-left)
(evil-space-bind "wx" 'evil-window-delete)
(evil-space-bind "wo" 'delete-other-windows)
(evil-space-bind "ws" 'hsplit-recents)
(evil-space-bind "wv" 'vsplit-recents)
(evil-space-bind "wS" 'hsplit-files)
(evil-space-bind "wV" 'vsplit-files)

(evil-space-bind "g" 'magit-status)
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

;; helm kill ring
(evil-space-bind "k" 'helm-show-kill-ring)
;; mark ring
(evil-space-bind "m" 'helm-mark-ring)

;;; misc bindings
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)

;; swap these because i'm weird
(define-key evil-motion-state-map (kbd "g;") 'goto-last-change)
(define-key evil-motion-state-map (kbd "g,") 'goto-next-change)

;; a holdover from my vim days
(define-key evil-normal-state-map (kbd "-j") 'evil-join)

;; avy
(define-key evil-motion-state-map (kbd "J") 'evil-avy-goto-word-or-subword-1)
(define-key evil-motion-state-map (kbd "K") 'evil-avy-goto-char-timer) 
;;(define-key evil-normal-state-map "c" (evil-change 

;;; Multiple cursors
(use-package evil-mc
  :config
  (global-evil-mc-mode 1))

(define-key evil-normal-state-map (kbd "C-S-H")
  (lambda () "Moves the cursor left and adds a cursor" (interactive)
    (evil-backward-char)
    (evil-mc-make-cursor-here)))

(define-key evil-normal-state-map (kbd "C-S-L")
  (lambda () "Moves the cursor right and adds a cursor" (interactive)
    (evil-forward-char)
    (evil-mc-make-cursor-here)))

(define-key evil-normal-state-map (kbd "C-S-J")
  (lambda () "Moves the cursor up and adds a cursor" (interactive)
    (evil-next-line)
    (evil-mc-make-cursor-here)))

(define-key evil-normal-state-map (kbd "C-S-K")
  (lambda () "Moves the cursor down and adds a cursor" (interactive)
    (evil-previous-line)
    (evil-mc-make-cursor-here)))

;;; Helm rebinds
					; make tab completion work normally in helm find files
(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)

(provide 'evil-bindings)
