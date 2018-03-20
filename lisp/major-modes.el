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
(use-package toml-mode
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
;; Scheme
(use-package geiser
  :defer t)
(use-package racket-mode
  :defer t)
(use-package dockerfile-mode
  :defer t)
;; scala
(use-package ensime
  :defer t
  :pin melpa-stable)
(use-package pdf-tools
  :defer t)
(use-package rust-mode
  :defer t
  :config
  (use-package racer
    :config
    (add-hook 'rust-mode-hook #'racer-mode)
    (add-hook 'racer-mode-hook #'eldoc-mode)))
(use-package kotlin-mode
  :defer t
  :config
  (use-package flycheck-kotlin
    :config
    (flycheck-kotlin-setup)))
(use-package ess
  :defer t
  :config
  (setq ess-use-auto-complete t)
  (setq ess-tab-complete-in-script t))
;;(use-package julia-mode
;;  :defer t
;;  :config
;;  (use-package julia-shell))

(provide 'major-modes)
