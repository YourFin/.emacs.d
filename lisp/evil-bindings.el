(provide 'evil-bindings)

(evil-mode 1)

(use-package evil-anzu)
(use-package evil-ediff)
(use-package evil-terminal-cursor-changer
 
  :if (not 'display-graphic-p)
  :config (evil-terminal-cursor-changer-activate))
(use-package evil-indent-textobject)

;;; sanity check
(setq evil-want-Y-yank-to-eol t)

;;;; Space bindings
;; unmap normal space
(define-key evil-motion-state-map " " nil)

(defun evil-space-bind (keys command)
  "Throws a space at the front of $keys
   and adds the binding to command to 
   evil-motion-state-map"
  (define-key evil-motion-state-map (kbd (concat "<SPC>" keys)) command))

(evil-space-bind " <SPC>" 'helm-M-x)

;;files
(evil-space-bind "ff" 'helm-find-files)

;; Buffers
(evil-space-bind "bb" 'save-buffer)
(evil-space-bind "bs" 'helm-buffers-list)
(evil-space-bind "bo" 'helm-find-files)
(evil-space-bind "bx" 'kill-buffer)

;; Windows
(defun hsplit-recents ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-split)
  (evil-window-next 1)
  (helm-mini))

(defun vsplit-recents ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-vsplit)
  (evil-window-next 1)
  (helm-mini))

(defun hsplit-files ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-split)
  (evil-window-next 1)
  (helm-find-files t))

(defun vsplit-files ()
  "splits the current window horizontally
and opens up helm switch buffer"
  (interactive)
  (evil-window-vsplit)
  (evil-window-next 1)
  (helm-find-files t))

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


;; Magit
(evil-space-bind "gw" (lambda () "stage current file"
			(interactive)
			(save-buffer)
			(magit-stage-file buffer-file-name)))
(evil-space-bind "go" (lambda () "commit and push to default branch"
			(interactive)
			(magit-commit)
			(magit-push-current)))

;; Random utilities
(evil-space-bind "uc" 'helm-calcul-expression)
(evil-space-bind "ua" 'helm-apropos)

;; helm kill ring
(evil-space-bind "k" 'helm-show-kill-ring)

;;; misc bindings
(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)
(define-key evil-normal-state-map (kbd "J") nil)
;; a holdover from my vim days
(define-key evil-normal-state-map (kbd "-j") 'evil-join)
(define-key evil-motion-state-map (kbd "J") 'evil-avy-goto-word-or-subword-1)
(define-key evil-motion-state-map (kbd "K") 'evil-avy-goto-char-timer) 
;;(define-key evil-normal-state-map "c" (evil-change 

;;; Multiple cursors
;; enable
(use-package evil-mc)
(global-evil-mc-mode 1)

(define-key evil-normal-state-map (kbd "C-H")
  (lambda () "Moves the cursor left and adds a cursor" (interactive)
    (evil-backward-char)
    (evil-mc-make-cursor-here)))

(define-key evil-normal-state-map (kbd "C-L")
  (lambda () "Moves the cursor right and adds a cursor" (interactive)
    (evil-forward-char)
    (evil-mc-make-cursor-here)))

(define-key evil-normal-state-map (kbd "C-J")
  (lambda () "Moves the cursor up and adds a cursor" (interactive)
    (evil-next-line)
     (evil-mc-make-cursor-here)))

(define-key evil-normal-state-map (kbd "C-K")
  (lambda () "Moves the cursor down and adds a cursor" (interactive)
    (evil-previous-line)
    (evil-mc-make-cursor-here)))

;;; Helm rebinds
; make tab completion work normally in helm find files
(define-key helm-find-files-map "\t" 'helm-execute-persistent-action)
