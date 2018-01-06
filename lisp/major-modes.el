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
  :defer t)
;; For log files
(use-package logview
  :defer t)

(provide 'major-modes)
