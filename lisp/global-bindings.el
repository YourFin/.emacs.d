(provide 'global-bindings)



(defun yf-exit-minibuffer-ev-paste-after
    "Exits the helm minibuffer and
pastes after; intended for helm-calcul-expression"
  (interactive)
  (helm-maybe-exit-minibuffer)
  (evil-paste-after))

(defun yf-exit-minibuffer-ev-paste-before
    "Exits the helm minibuffer and
pastes; intended for helm-calcul-expression"
  (interactive)
  (helm-maybe-exit-minibuffer)
  (evil-paste-before))

(define-key helm-calcul-expression-map (kbd "<RET>") 'yf-exit-minibuffer-ev-paste-after)
(define-key helm-calcul-expression-map (kbd "S-<RET>") 'yf-exit-minibuffer-ev-paste-before)
