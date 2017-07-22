(provide 'evil-bindings)

(evil-mode 1)

(use-package evil-anzu :ensure t)
(use-package evil-ediff :ensure t)
(use-package evil-terminal-cursor-changer
  :ensure t
  :if (not 'display-graphic-p)
  :config (evil-terminal-cursor-changer-activate))
(use-package evil-indent-textobject :ensure t)

(define-key evil-motion-state-map "K" 'ace-jump-mode)

;;; Space bindings
; unmap normal space
(define-key evil-motion-state-map " " nil)

(defun evil-space-bind (keys command)
  "Throws a space at the front of $keys
   and adds the binding to command to 
   evil-motion-state-map"
  (define-key evil-motion-state-map (kbd (concat "<SPC>" keys)) command))

(evil-space-bind " <SPC>" 'helm-M-x)

;files
(evil-space-bind "ff" 'helm-find-files)

; Buffers
(evil-space-bind "Bb" 'save-buffer)
(evil-space-bind "Bs" 'helm-buffers-list)
(evil-space-bind "Bw" 'save-buffer)
(evil-space-bind "Bx" 'kill-buffer)

; Windows
(evil-space-bind "ww" 'evil-window-next)
(evil-space-bind "w S-W" 'evil-window-prev)
(evil-space-bind "wj" 'evil-window-down)
(evil-space-bind "wk" 'evil-window-up)
(evil-space-bind "wl" 'evil-window-right)
(evil-space-bind "wh" 'evil-window-left)
(evil-space-bind "wc" 'evil-window-delete)
(evil-space-bind "ws" 'evil-window-split)
(evil-space-bind "wv" 'evil-window-vsplit)

(define-key evil-motion-state-map "j" 'evil-next-visual-line)
(define-key evil-motion-state-map "k" 'evil-previous-visual-line)

;(define-key evil-normal-state-map "c" (evil-change 

;;; Multiple cursors
; enable
(use-package evil-mc :ensure t)
(global-evil-mc-mode 1)

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
 
