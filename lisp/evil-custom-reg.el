
(require 'evil)
;;setup
(defvar yf/kill-to-second nil "Whether to kill to the second position or first")
(defadvice kill-new (around ny-kill-new-2nd)
  "If `my-kill-2nd' is non-nil, kills go to the second position of the `kill-ring'."
  (cond
   ((bound-and-true-p evil-mc-cursor-list)
    (let ((interprogram-cut-function nil))
      ad-do-it))
   ((and kill-ring (bound-and-true-p yf/kill-to-second))
    (let ((real-kill-ring kill-ring)
	  (kill-ring (cdr kill-ring))
	  (interprogram-cut-function nil))
      ad-do-it
      (setcdr real-kill-ring kill-ring)
      (setq kill-ring-yank-pointer real-kill-ring)))

   ;;Handle empty kill ring
   ((bound-and-true-p yf/kill-to-second)
    (let ((interprogram-cut-function nil))
      ad-do-it))
   (t (let ((interprogram-cut-function 'yf-sys-clip-set))
	ad-do-it))))

(ad-activate 'kill-new)

;;; functions
(evil-define-operator yf-y (beg end type register yank-handler)
  "Evil-yank that goes to clipboard as well as kill ring"
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (let ((yf/kill-to-second nil))
    (evil-yank beg end type register yank-handler))
  )
(define-key evil-normal-state-map "y" 'yf-y)
(define-key evil-visual-state-map "y" 'yf-y)

(evil-define-operator yf-gy (beg end type register yank-handler)
  "Evil-yank that dumps to 2nd in kill ring but not clipboard"
  :move-point nil
  :repeat nil
  (interactive "<R><x><y>")
  (let ((yf/kill-to-second t))
    (evil-yank beg end type register yank-handler))
  )
(define-key evil-normal-state-map "gy" 'yf-gy)
(define-key evil-visual-state-map "gy" 'yf-gy)

(evil-define-operator yf-Y (beg end type register yank-handler)
  "Evil-yank-line that goes to clipboard as well as kill ring"
  :motion evil-line
  :move-point nil
  :repeat nil
  (interactive "<R><x>")
  (let ((yf/kill-to-second nil))
    (evil-yank-line beg end type register yank-handler))
  )
(define-key evil-normal-state-map "Y" 'yf-Y)
(define-key evil-visual-state-map "Y" 'yf-Y)

(evil-define-operator yf-gY (beg end type register yank-handler)
  "Evil-yank-line that dumps to 2nd in kill ring but not clipboard"
  :motion evil-line
  :move-point nil
  :repeat nil
  (interactive "<R><x>")
  (let ((yf/kill-to-second t))
    (evil-yank-line beg end type register yank-handler))
  )
(define-key evil-normal-state-map "gY" 'yf-gY)
(define-key evil-visual-state-map "gY" 'yf-gY)

(evil-define-operator yf-x (beg end type register)
  "Evil-delete-char that dumps to 2nd in kill ring by default"
  :motion evil-forward-char
  (interactive "<R><x>")
  (let ((yf/kill-to-second t))
    (evil-delete-char beg end type register)))
(define-key evil-visual-state-map "x" 'yf-x)
(define-key evil-normal-state-map "x" 'yf-x)

(evil-define-operator yf-X (beg end type register)
  "Evil-delete-backward-char that dumps to 2nd in kill ring by default"
  :motion evil-backward-char
  (interactive "<R><x>")
  (let ((yf/kill-to-second t))
    (evil-delete-backward-char beg end type register)))
(define-key evil-visual-state-map "X" 'yf-X)
(define-key evil-normal-state-map "X" 'yf-X)

(evil-define-operator yf-d (beg end type register yank-handler)
  "Evil-delete that dumps to 2nd in kill ring by default"
  (interactive "<R><x><y>")
  (let ((yf/kill-to-second t))
    (evil-delete beg end type register)))
(define-key evil-visual-state-map "d" 'yf-d)
(define-key evil-normal-state-map "d" 'yf-d)

(evil-define-operator yf-D (beg end type register yank-handler)
  "Evil-delete-line that dumps to 2nd in kill ring by default"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((yf/kill-to-second t))
    (evil-delete-line beg end type register)))
(define-key evil-visual-state-map "D" 'yf-D)
(define-key evil-normal-state-map "D" 'yf-D)

(evil-define-operator yf-m (beg end type register yank-handler)
  "Evil-delete that sets custom clipboard along with standard kill"
  (interactive "<R><x><y>")
  (let ((yf/kill-to-second nil))
    (evil-delete beg end type register)))
(define-key evil-normal-state-map "m" 'yf-m)
(define-key evil-visual-state-map "m" 'yf-m)

(evil-define-operator yf-M (beg end type register yank-handler)
  "Evil-delete-line that sets custom clipboard along with standard kill"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((yf/kill-to-second nil))
    (evil-delete-line beg end type register)))
(define-key evil-normal-state-map "M" 'yf-M)
(define-key evil-visual-state-map "M" 'yf-M)

(evil-define-operator yf-c (beg end type register yank-handler)
  "Evil-change that dumps to 2nd in kill ring but not clipboard"
  (interactive "<R><x><y>")
  (let ((yf/kill-to-second t))
    (evil-change beg end type register yank-handler))
  )
(define-key evil-normal-state-map "c" 'yf-c)
(define-key evil-visual-state-map "c" 'yf-c)

(evil-define-operator yf-gc (beg end type register yank-handler)
  "Evil-change that goes to clipboard as well as kill ring"
  (interactive "<R><x><y>")
  (let ((yf/kill-to-second nil))
    (evil-change beg end type register yank-hander))
  )
(define-key evil-normal-state-map "gc" 'yf-gc)
(define-key evil-visual-state-map "gc" 'yf-gc)

(evil-define-operator yf-C (beg end type register yank-handler)
  "Evil-change-line that dumps to 2nd in kill ring but not clipboard"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((yf/kill-to-second t))
    (evil-change-line beg end type register yank-handler))
  )
(define-key evil-normal-state-map "C" 'yf-C)
(define-key evil-visual-state-map "C" 'yf-C)

(evil-define-operator yf-gC (beg end type register yank-handler)
  "Evil-change-line that goes to clipboard as well as kill ring"
  :motion evil-end-of-line
  (interactive "<R><x>")
  (let ((yf/kill-to-second nil))
    (evil-change-line beg end type register yank-hander)))

(evil-define-operator yf-s (beg end type register)
  :motion evil-forward-char
  (interactive "<R><x>")
  (let ((yf/kill-to-second t))
    (evil-change beg end type register)))

(define-key evil-normal-state-map "gC" 'yf-gC)
(define-key evil-visual-state-map "gC" 'yf-gC)

(provide 'evil-custom-reg)
