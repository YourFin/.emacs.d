;;; major-modes.el --- File containing most major modes  -*- lexical-binding: t; -*-

;; Copyright (C) 2017  

;; Author:  <pen@firecakes>
;; Keywords: extensions, 

(use-package python)
(use-package python-django)
(use-package markdown-mode)
(use-package vimrc-mode
  :defer t)
(use-package crystal-mode
  :defer t)
(use-package yaml-mode
  :defer t)
;; clojure ide
(use-package cider
  :defer t
  :config
  (setq cider-repl-use-clojure-font-lock t)
  (add-hook 'cider-repl-mode-hook #'cider-company-enable-fuzzy-completion)
  (add-hook 'cider-mode-hook #'cider-company-enable-fuzzy-completion))
;; For log files
(use-package logview
  :defer t)
(use-package geiser
  :defer t)

(provide 'major-modes)
