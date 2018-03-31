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
(use-package evil-collection
  :custom (evil-collection-setup-minibuffer t)
  :init (evil-collection-init))

(use-package general
  :config (general-evil-setup))

;; It's vim-surround but so much better!
(use-package evil-embrace
  :config
  (global-evil-surround-mode t)
  (evil-embrace-enable-evil-surround-integration))

;; Our lord and savior-cleverparens
(use-package evil-cleverparens
  :config
  ;; Adds some nice text objects - (around/in) (f)orm, (c)omment, and (d)efun or a top level text object
  (require 'evil-cleverparens-text-objects)
  (evil-define-key 'motion evil-cleverparens-mode-map
    (kbd "{") 'evil-backward-paragraph
    (kbd "}") 'evil-forward-paragraph)
  (evil-define-key 'normal evil-cleverparens-mode-map
    (kbd "{") 'evil-backward-paragraph
    (kbd "}") 'evil-forward-paragraph)
  (evil-define-key 'visual evil-cleverparens-mode-map
    (kbd "{") 'evil-backward-paragraph
    (kbd "}") 'evil-forward-paragraph)
  ;; TODO: move this to a lispy-mode file
  (mapc (lambda (lisp) (add-hook (intern lisp) #'evil-cleverparens-mode))
	'("clojure-mode-hook" "emacs-lisp-mode-hook" "scheme-mode-hook" "lisp-mode-hook")))

;; Heretic evil clipboard mode
(require 'heretic-evil-clipboard-mode)
(add-hook 'evil-mode-hook #'heretic-evil-clipboard-mode-on)

(require 'evil-space-binds)

(use-package expand-region
  :config
  (define-key evil-visual-state-map "o" 'er/expand-region)
  (define-key evil-visual-state-map "O" 'er/contract-region))

(use-package evil-iedit-state)
(use-package evil-matchit
  :config (global-evil-matchit-mode 1))

;; Treemacs!
(use-package treemacs-evil
  :ensure t
  :demand t
  :config
  (general-define-key
   :keymaps 'treemacs-mode-map
   "M-j" 'treemacs-next-line-other-window
   "M-k" 'treemacs-previous-line-other-window))

;; Make finishing commits faster
(evil-define-minor-mode-key 'normal 'git-commit-mode
  "q" 'with-editor-finish
  "z" 'with-editor-cancel)

;; ---------- Misc Bindings ----------- ;
;; for everybody's sanity
(setq evil-want-Y-yank-to-eol t)

;;;; Global evil bindings:
;; As visual line movements make no sense in visual line or block mode
(evil-define-motion yf-visual-j (count)
  "Wrapper for `evil-next-visual-line' ignores the visual in visual-line mode"
  :type line
  (if (or (not evil-visual-state-minor-mode) (eq (evil-visual-type) 'inclusive))
      (evil-next-visual-line count)
    (evil-next-line count)))
(evil-define-motion yf-visual-k (count)
  "Wrapper for `evil-previous-visual-line' ignores the visual in visual-line mode"
  :type line
  (if (or (not evil-visual-state-minor-mode) (eq (evil-visual-type) 'inclusive))
      (evil-previous-visual-line count)
    (evil-previous-line count)))
;;; better search: Swiper!
;; Make swiper act like evil in terms
;; of where it leaves the cursor
(defun yf--swiper-advice (&rest r)
  ;;(setq isearch-string (substring-no-properties (car swiper-history)))
  (setq isearch-forward t)
  (evil-search-previous))
(advice-add 'swiper :after #'yf--swiper-advice)

;; Force use of motion bindings
(general-def 'normal
  "J" nil)
(general-def 'motion
  "j" 'yf-visual-j
  "k" 'yf-visual-k
  "J" (lambda () (interactive) (yf-visual-j 15))
  "K" (lambda () (interactive) (yf-visual-k 15))
  "," 'goto-last-change
  "g," 'goto-last-change-reverse
  ";" 'evil-repeat-find-char
  "g;" 'evil-repeat-find-char-reverse
  "/" 'swiper)
(general-define-key
 :states '(normal insert)
 "C-y" 'yas-expand
 "C-s" 'evil-cp->
 "M-RET" 'comment-indent-new-line)
(general-define-key
 :states 'insert
 "M-j" 'evil-next-visual-line
 "M-k" 'evil-previous-visual-line
 "M-h" 'evil-backward-char
 "M-l" 'evil-forward-char
 "M-w" 'evil-forward-word)

;; a holdover from my vim days
(define-key evil-normal-state-map (kbd "-j") 'evil-join)

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
^ ^ _k_ ^ ^       _o__O_pen File  _C-o_nly win             ^Vim _C-k_ 
_h_ ^✜^ _l_       _b__B_ Sw-Buffer  _x_ Delete this win    ^_C-w_ _C-j_
^ ^ _j_ ^ ^       _u_ _C-r_ undo    _s_plit _v_ertically     ^_C-h_ _C-l_"
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
  ("C-w" evil-window-next :color blue)
  ("C-k" evil-window-up :color blue)
  ("C-j" evil-window-down :color blue)
  ("C-h" evil-window-left :color blue)
  ("C-l" evil-window-right :color blue)
  ("SPC" nil  :color blue))

(define-key evil-normal-state-map (kbd "C-w") nil)
(define-key evil-motion-state-map (kbd "C-w") nil)
(define-key evil-insert-state-map (kbd "C-w") nil)
;; I'm sorry emacs users, but I can't not being
;; able to get to this from everywhere
(global-set-key (kbd "C-w") 'yf-evil-windows/body)

;;(define-key evil-normal-state-map (kbd "C-S-H")
;;  (lambda () "Moves the cursor left and adds a cursor" (interactive)
;;    (evil-backward-char)
;;    (evil-mc-make-cursor-here)))
;;
;;(define-key evil-normal-state-map (kbd "C-S-L")
;;  (lambda () "Moves the cursor right and adds a cursor" (interactive)
;;    (evil-forward-char)
;;    (evil-mc-make-cursor-here)))
;;
;;(define-key evil-normal-state-map (kbd "C-S-J")
;;  (lambda () "Moves the cursor up and adds a cursor" (interactive)
;;    (evil-next-line)
;;    (evil-mc-make-cursor-here)))
;;
;;(define-key evil-normal-state-map (kbd "C-S-K")
;;  (lambda () "Moves the cursor down and adds a cursor" (interactive)
;;    (evil-previous-line)
;;    (evil-mc-make-cursor-here)))

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
  (define-key ranger-normal-mode-map (kbd "c") 'yf--magit-clone-ranger))

(provide 'evil-bindings)
