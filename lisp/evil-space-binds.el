;;; evil-space-binds.el --- contains space-prefixed binds for evil mode  -*- lexical-binding: t; -*-

;; Copyright (C) 2018

;; Author:  <pen@firecakes>
;; Keywords: evil

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:
(require 'evil)
(require 'general)
(require 'heretic-evil-clipboard-mode)

;; unmap normal space
(define-key evil-motion-state-map " " nil)

;; Treemacs
(defun yf-treemacs ()
  "Runs `treemacs-projectile' if in project, otherwise `treemacs'"
  (interactive)
  (if (projectile-project-p)
      (treemacs-projectile)
    (treemacs)))

(general-define-key
 :states '(normal insert)
 :prefix "SPC"
 :non-normal-prefix "M-a"
 ;;:global
 "<SPC>" 'helm-smex
 ;;files/buffers
 "bb" 'save-buffer
 "bB" 'write-file
 "bs" 'yf-switch-buffer
 "bS" 'helm-mini
 "bo" 'ranger
 "bO" 'helm-find-files
 "bx" 'kill-this-buffer
 "bX" 'kill-buffer
 "bl" 'evil-switch-to-windows-last-buffer
 ;; Windows
 "ww" 'evil-window-next
 "wj" 'evil-window-down
 "wk" 'evil-window-up
 "wl" 'evil-window-right
 "wh" 'evil-window-left
 "wx" 'evil-window-delete
 "wo" 'delete-other-windows

 "g" 'magit-status

 ;; Projectile/projects
 "pa" 'helm-projectile-ag
 "ps" 'helm-projectile-switch-project

 ;; Random utilities
 "uc" 'helm-calcul-expression
 "ua" 'helm-apropos
 "ub" 'describe-key
 "uu" 'undo-tree-visualize
 "ur" 'redraw-display
 "ut" 'yf-run-outside-terminal
 "um" 'helm-all-mark-rings

 "t" 'yf-treemacs

 ;; quickrun - Gets replaced by more specific things in
 ;; `auto-mode-files' files
 "r" 'quickrun

 "k" 'heretic-evil-helm-kill-ring)

(define-key evil-visual-state-map (kbd "<SPC>r") 'quickrun-region)

(provide 'evil-space-binds)
;;; evil-space-binds.el ends here
