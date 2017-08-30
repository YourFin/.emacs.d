
;Get rid of splash screen ffs
(setq inhibit-startup-message t)

;Remove annoying bars
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;;; Apperance packages:
(use-package tangotango-theme)
(load-theme 'tangotango t)

;;;Host specific
(cond ([(eq (system-name) "firecakes")	
	(set-frame-font "ConsolasHacked 22" nil t)
	]))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
  (setq rainbow-delimiters-max-face-count 8)
    ;more rainbow-ey rainbow delimiters. they cycle around the
    ;color wheel approximatly every three colors with a bit of offset. 256 color
    ;term compatable
  (set-face-foreground 'rainbow-delimiters-depth-1-face "#5fd7ff")
  (set-face-foreground 'rainbow-delimiters-depth-2-face "#ffaf00")
  (set-face-foreground 'rainbow-delimiters-depth-3-face "#d75fff")
  (set-face-foreground 'rainbow-delimiters-depth-4-face "#87ff00")
  (set-face-foreground 'rainbow-delimiters-depth-5-face "#ff5f00")
  (set-face-foreground 'rainbow-delimiters-depth-6-face "#0087ff")
  (set-face-foreground 'rainbow-delimiters-depth-7-face "#ffff00")
  (set-face-foreground 'rainbow-delimiters-depth-8-face "#ff87ff")
  )



(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'column)
  (setq highlight-indent-guides-auto-odd-face-perc 23)
  (setq highlight-indent-guides-auto-even-face-perc 16)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;;; Fringe
; Line Numbers
(defun my-linum ()
  "Turns on and colors line numbers"
  (linum-mode)
  (custom-set-variables '(linum-format 'dynamic))
  ;; Blatantly stolen from stackoverflow: https://stackoverflow.com/questions/3626632/right-align-line-numbers-with-linum-mode
  (defadvice linum-update-window (around linum-dynamic activate)
    (let* ((w (length (number-to-string
		       (count-lines (point-min) (point-max)))))
	   (linum-format (concat "%" (number-to-string w) "d ")))
      ad-do-it)) 
  (set-face-background 'linum "black"))
(add-hook 'prog-mode-hook #'my-linum)

;; Remove wrap arrows
;; Taken from https://web.archive.org/web/20170820232748/https://stackoverflow.com/questions/27845980/how-do-i-remove-newline-symbols-inside-emacs-vertical-border 
(setf (cdr (assq 'continuation fringe-indicator-alist))
       '(nil right-curly-arrow) ;; right indicator only
      )

;; exclusivly for smooth scrolling
(use-package sublimity
  :config
  (require 'sublimity-scroll)
  (setq sublimity-scroll-weight 8)
  (setq sublimity-scroll-drift-length 2)
  (sublimity-mode 1))

(use-package adaptive-wrap
  :config (add-hook 'prog-mode-hook 'adaptive-wrap-prefix-mode))


;; Margin diff for vc
(use-package diff-hl
  :config
  (set-face-foreground 'diff-hl-change "light goldenrod")
  (set-face-background 'diff-hl-change "dark goldenrod")
  (set-face-foreground 'diff-hl-delete "red")
  (set-face-background 'diff-hl-delete "red4")
  (set-face-foreground 'diff-hl-insert "green1")
  (set-face-background 'diff-hl-insert "green4")
  (when (<= 24.4 (string-to-number emacs-version))
    (add-hook 'prog-mode-hook 'diff-hl-flydiff-mode)
    (add-hook 'text-mode-hook 'diff-hl-flydiff-mode))
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
  (add-hook 'prog-mode-hook 'diff-hl-mode))

(provide 'apperance)
