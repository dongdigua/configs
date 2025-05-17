(setq gc-cons-threshold most-positive-fixnum)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes t)
 '(package-selected-packages
   '(age all-the-icons benchmark-init catppuccin-theme clippy
         clojure-mode company darkman doom-modeline elixir-mode elpher
         erlang evil evil-god-state evil-mc expand-region fzf
         gemini-mode go-mode god-mode haskell-mode htmlize imenu-list
         indent-guide lua-mode magit markdown-mode nasm-mode neotree
         nim-mode nix-mode nord-theme nyan-mode org-tree-slide pyim
         racket-mode rainbow-delimiters rainbow-mode restclient
         rfc-mode rime rust-mode sdcv selectric-mode
         shr-tag-pre-highlight simple-httpd smart-hungry-delete topsy
         undo-tree use-package valign vterm web-mode webfeeder
         writeroom-mode yaml-mode zenburn-theme))
 '(warning-suppress-types '((comp))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;;@ Graphical Interface ;;
(set-frame-font "-FRJN-IntoneMono Nerd Font-regular-normal-normal-*-19-*-*-*-m-0-iso10646-1")
(set-fontset-font t 'han "LXGW WenKai")


;;@ package manager ;;
(setq package-archives'(("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
                        ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
(setq use-package-verbose t)

(defmacro setup-what-pkg (what)
  ;; https://liujiacai.net/blog/2021/05/05/emacs-package
  `(progn
     (when (not package-archive-contents)
       (package-refresh-contents))
     (dolist (p ,what)
       (when (not (package-installed-p p))
         (package-install p)))))

(defun setup-full-pkg () (interactive) (setup-what-pkg package-selected-packages))


;;@ custom ;;
(setq make-backup-files nil
      auto-save-file-name-transforms
      '((".*" "~/.emacs.d/autosave/" t)))

(setq-default tab-width 4
              c-basic-offset 4
              sh-basic-offset 2
              indent-tabs-mode nil)    ; must be setq-default
(setq backward-delete-char-untabify-method 'hungry)

(setq display-line-numbers-type 'relative)
(if (display-graphic-p)
    (progn
      (global-display-line-numbers-mode)
      (global-tab-line-mode t)))

(setq epa-file-cache-passphrase-for-symmetric-encryption t
      epg-pinentry-mode 'loopback)    ; use minibuffer instead of popup

(defalias 'yes-or-no-p 'y-or-n-p)
(global-auto-revert-mode t)
(electric-pair-mode t)

(setq shr-use-fonts nil)
(setq dired-listing-switches "-alh")
(setenv "LC_TIME" "en_US.UTF-8")

;; manually do the gcmh https://akrl.sdf.org
(setq normal-gc-threshold 6400000)
(defmacro k-time (&rest body)
  "Measure and return the time it takes evaluating BODY."
  `(let ((time (current-time)))
     ,@body
     (float-time (time-since time))))
(run-with-idle-timer 30 t
                     (lambda ()
                       (message "gcmh: start")
                       (message "gcmh: %.04fsec"
                                (k-time (garbage-collect)))))



;;@ functions ;;
(defun animate-text (text)
  ;; https://github.com/matrixj/405647498.github.com/blob/gh-pages/src/emacs/emacs-fun.org
  (interactive "stext: ")  ; s means read-string
  (switch-to-buffer (get-buffer-create "*butterfly*"))
  (erase-buffer)
  (animate-string text 10))

(defun convert-punctuation ($from $to)
  ;; convert Chinese pubctuation to normal
  ;; http://xahlee.info/emacs/emacs/emacs_zap_gremlins.html
  (interactive "r")
  (let (($charMap
    [
     ["，" ", "] ["。" ". "]
     ["？" "? "] ["！" "! "]
     ["：" ": "] ["；" "; "]
     ["（" "("]  ["）" ")"]
     ["【" "["]  ["】" "]"]
     ["‘" "'"]   ["’" "'"]
     ["“" "\""]  ["”" "\""]
     ]))
    (save-restriction
      (narrow-to-region $from $to)
      (mapc
       (lambda ($pair)
         (goto-char (point-min))
         (while (re-search-forward (elt $pair 0) (point-max) t)
           (replace-match (elt $pair 1))))
       $charMap))))

(defun switch-browser ()
  (interactive)
  (if (eq browse-url-browser-function 'eww-browse-url)
      (progn
        (setq browse-url-browser-function 'browse-url-firefox)
        (message "browser switched to firefox"))
    (progn
      (setq browse-url-browser-function 'eww-browse-url)
      (message "browser switched to eww"))))

(defun proxy ()
  (interactive)
  (if (eq url-proxy-services nil)
      (setq url-proxy-services '(("http"  . "127.0.0.1:20171")))
    (progn
      (setq url-proxy-services nil)
      (message "no proxy"))))

(defun toggle-shr-hl ()
  (interactive)
  (if shr-external-rendering-functions
      (setq shr-external-rendering-functions nil)
    (progn
      (add-to-list 'shr-external-rendering-functions
                   '(pre . shr-tag-pre-highlight))
      (message "on"))))

(defun gc-change-threshold ()
  ;; for some crazy usage
  (interactive)
  (if (eq gc-cons-threshold normal-gc-threshold)
      (progn (setq gc-cons-threshold #x40000000) (message "big"))
  (setq gc-cons-threshold normal-gc-threshold)))

(defun yy/outline-setup ()
  ;; https://egh0bww1.com/posts/2024-01-09-48-use-outline-manage-init-file/
  (interactive)
  (setq-local outline-regexp ";;; Code\\|;;@+")
  (setq-local outline-minor-mode-use-buttons 'in-margins)
  (setq-local outline-minor-mode-highlight 'append)
  (setq-local outline-minor-mode-cycle t)
  (outline-minor-mode))

(defun newsboat ()
  ;; newsboat is the best RSS reader
  (interactive)
  (vterm)
  (writeroom-mode)
  (vterm-send-string "newsboat\n"))



;;@ use-package ;;
(use-package evil
  :ensure t
  :init
  ;; https://emacstalk.codeberg.page/post/025/
  (setq evil-want-C-i-jump nil)
  (setq evil-undo-system 'undo-tree)
  (evil-mode 1)
  :bind
  ("C-r" . isearch-backward))

(use-package evil-mc
  :defer 1
  :bind
  ("C->". evil-mc-make-and-goto-next-match)
  ("C-<". evil-mc-make-and-goto-prev-match)
  :config
  (global-evil-mc-mode 1))

(use-package org
  ;; to make tags aligned:
  ;; https://emacs-china.org/t/org-mode-tag/22291
  ;; but it looks not satisfying and add a bit of lag, so I don't use it
  :defer t
  :init
  ;; https://dongdigua.github.io/gmi/org_load_gnus_disable.gmi.txt
  (setq org-modules '(org-crypt org-id ol-info)
        org-tags-exclude-from-inheritance '("crypt")
        org-crypt-key "2394861A728929E3755D8FFADB55889E730F5B41")
  (org-crypt-use-before-save-magic)
  :config
;;;ifdef dump
  (setq org-startup-indented t
        org-src-preserve-indentation t
        org-agenda-files '("~/org/TODO.org"))
;;;endif dump
  (defun org-writer ()
    ;; https://www.reddit.com/r/emacs/comments/43vfl1/enable_wordwrap_in_orgmode/
    (interactive)
    (org-indent-mode)
    (visual-line-mode))

  (define-key org-mode-map (kbd "M-n") #'org-next-link)
  (define-key org-mode-map (kbd "M-p") #'org-previous-link)

  (use-package org-capture
    :config
    (setq org-capture-templates
          '(("t" "Task" entry (file+headline "~/org/capture.org" "Tasks")
              "* TODO %?\n  %u\n  %a")
            ("i" "Inbox" entry (file "~/org/capture.org")
             "* %U - %^{heading}\n%?\n")
            )))

  ;; https://d12frosted.io/posts/2017-07-30-block-templates-in-org-mode.html
  (setq org-structure-template-alist
   '(("c" . "CENTER")
     ("C" . "COMMENT")
     ("e" . "EXAMPLE")
     ("E" . "EXPORT")
     ("q" . "QUOTE")
     ("s" . "SRC")))

  (defmacro my/orgurl (proto)
    `(org-link-set-parameters ,proto
                             :follow #'elpher-browse-url-elpher
                             :export
                             (lambda (link description format _)
                               (let ((url (format "%s:%s" ,proto link)))
                                 (format "<a href=\"%s\">%s</a>" url (or description url))))))
  (my/orgurl "gopher")
  (my/orgurl "gemini"))

(use-package expand-region
  ;; something like wildfire.vim
  :after evil-mc
  :config
  ;; can't use :bind
  (global-set-key (kbd "C-<return>") 'er/expand-region))

(use-package neotree
  :init
  (global-set-key [(f3)] 'neotree-toggle)
  :defer t
  :config
  (setq neo-theme (if (display-graphic-p) 'icons))
  ;; without this evil mode will conflict with neotree
  ;; ref: https://www.emacswiki.org/emacs/NeoTree
  (evil-define-key 'normal neotree-mode-map (kbd "q") 'neotree-hide)
  (evil-define-key 'normal neotree-mode-map (kbd "g") 'neotree-refresh)
  (evil-define-key 'normal neotree-mode-map (kbd "H") 'neotree-hidden-file-toggle)
  (evil-define-key 'normal neotree-mode-map (kbd "<return>") 'neotree-enter))

(use-package smart-hungry-delete
  :if window-system ; in terminal the key just don't work
  :defer 1
  :bind
  ("C-<backspace>" . 'smart-hungry-delete-backward-char))

(use-package undo-tree
  :defer 1
  :config
  (global-undo-tree-mode)
  (setq undo-tree-auto-save-history nil))

(use-package company
  :if window-system
  :defer 1
  :config
  (setq company-dabbrev-ignore-case nil)
  (setq company-global-modes '(not erc-mode gud-mode))
  (global-company-mode))

(use-package valign
  :commands (valign--space valign--put-overlay)  ; autoload
  :hook (org-mode . valign-mode))

(use-package gud
  :defer t
  :config
  (setq gdb-many-windows t)
  (defalias 'disas 'gdb-display-disassembly-buffer)
  (tool-bar-mode t))

;; (use-package pyim
;;   :init
;;   (setq default-input-method "pyim")
;;   (setq pyim-punctuation-translate-p '(no yes auto)) ; must be 3-long
;;   :config
;;   (setq pyim-page-tooltip 'minibuffer)
;;   (setq pyim-cloudim 'google)  ; I hate baidu
;;   (setq pyim-dicts
;;         '((:name "tsinghua" :file "~/.emacs.d/pyim-tsinghua-dict/pyim-tsinghua-dict.pyim")))
;;   :bind
;;   ("C-|" . pyim-punctuation-toggle))

(use-package clippy
  ;; also from DistroTube
  :if window-system
  :bind
  (("C-x c v" . clippy-describe-variable)
   ("C-x c f" . clippy-describe-function)))

(use-package sdcv
  ;; http://download.huzheng.org/zh_CN/stardict-oxford-gb-formated-2.4.2.tar.bz2
  :init
  (defalias 'sdcv 'sdcv-search-input)
  :bind
  ("C-x M-t" . sdcv-search-pointer))

(use-package fzf
  ;; hacker news: How FZF and ripgrep improved my workflow
  ;; https://news.ycombinator.com/item?id=20360204
  :defer t
  :config
  (setenv "FZF_DEFAULT_COMMAND" "rg --files --hidden"))

(use-package indent-guide
  :defer 1
  :config
  (indent-guide-global-mode))

(use-package nyan-mode
  :if window-system
  :defer 1
  :config
  (nyan-mode)
  (nyan-start-animation))

(use-package rainbow-mode
  :defer 1
  :config
  (setq rainbow-x-colors nil
        rainbow-r-colors nil
        rainbow-html-colors nil))

;;;ifdef excl
(use-package doom-modeline
  ;; if the icons go wrong, try nerd-icons-install-fonts
  :config
  (setq doom-modeline-modal-icon nil) ; the icon for evil is dumb
  (doom-modeline-mode))
;;;endif excl

(use-package rfc-mode
  :defer t
  :config
  (setq rfc-mode-directory (expand-file-name "~/.emacs.d/rfc/")))

(use-package imenu-list
  :defer t
  ;; https://youtu.be/YM0TD8Eg9qg
  :config
  (setq imenu-list-persist-when-imenu-index-unavailable nil)
  (evil-define-key 'normal imenu-list-major-mode-map (kbd "SPC") 'imenu-list-display-dwim))

(use-package imenu
  :defer t
  :init
  (setq elisp-usepackage-expression
        ;; I love regxp!!!
        '("Packages" "^\\s-*(\\(use-package\\)\\s-+\\(\\(?:\\sw\\|\\s_\\|\\\\.\\)+\\)" 2))
  (add-hook 'emacs-lisp-mode-hook
            (lambda ()
              (setq-local imenu-generic-expression
                          (cons elisp-usepackage-expression lisp-imenu-generic-expression))))
  )

(use-package rime
  :config
  (setq default-input-method "rime")
  (setq rime-user-data-dir "~/.local/share/fcitx5/rime/")
  (setq rime-show-candidate 'popup)
  :bind
  ("C-|" . 'rime-inline-ascii))

(use-package darkman
  :config
  (setq modus-themes-mode-line '(borderless))
  (if (not (display-graphic-p))
    (setq darkman-themes '(:light zenburn :dark mariana)))
  (darkman-mode))

(use-package evil-god-state
  :config
  (evil-define-key 'normal global-map (kbd "SPC") 'evil-execute-in-god-state)
  (evil-define-key 'god global-map [escape] 'evil-god-state-bail))

(use-package writeroom-mode
  :defer t
  :config
  (setq writeroom-fullscreen-effect 'maximized))

(use-package icomplete
  :config
  (setq icomplete-compute-delay 0
        icomplete-delay-completions-threshold 0
        icomplete-show-matches-on-no-input t
        icomplete-scroll t)
  (bind-key "TAB" #'icomplete-force-complete icomplete-minibuffer-map)
  (icomplete-vertical-mode t))

;;@ use-package/languages ;;
(use-package cc-mode
  :defer t
  :init
  :config
  (setq c-default-style '((c-mode    . "bsd")
                          (java-mode . "java")
                          (awk-mode  . "awk")
                          (other     . "gnu"))))

(use-package web-mode
  ;; https://web-mode.org/
  :mode "\\.eex\\'"
  :mode "\\.html\\'"
  :mode "\\.xml\\'" ; when editing https://dongdigua.github.io/anaconda_kickstart
  :config
  (setq web-mode-markup-indent-offset 2))

(use-package rust-mode
  :config
  (defun rust-t (fun)
    (interactive "sfun: ")
    (rust--compile "%s test -- --nocapture %s" rust-cargo-bin fun))
  :bind
  ("C-c C-c c" . rust-compile))

(use-package gemini-mode
  :defer t
  :config
  (defun my/gemini-open-link-at-point ()
    "modified version of the original function"
    (interactive) ; vital for :map
    (let ((link (gemini-link-at-point)))
      (when link
        (cond ((string-prefix-p "gemini://" link t)
               (elpher-go link))
              ((string-prefix-p "gopher://" link t)
               (elpher-go link))
              ((file-exists-p link)
               (find-file link))
              ((string-match "https?://" link)
               (browse-url link))
              (t (error "gemini-mode: invalid link %s" link))))))
  (setq whitespace-style '(face lines-char))
  :hook
  ;; normally add whitespace-mode doesn't work, this is a per-buffer setting
  (gemini-mode . whitespace-mode)
  :bind
  (:map gemini-mode-map ("C-c C-o" . #'my/gemini-open-link-at-point)))

(use-package flycheck
  :defer t
  :init
  (setq flycheck-global-modes '(rust-mode)))

(use-package nasm-mode
  ;; https://vishnudevtj.github.io/notes/assembly-in-emacs
  :hook (asm-mode-hook nasm-mode))

(use-package go-mode
  :defer t
  :config
  (setq-local tab-width 4)
  (indent-tabs-mode t)
  (setq whitespace-style '(face tabs tab-mark)) ; setq-local won't work
  :hook
  (go-mode . whitespace-mode))

(use-package eglot
  :defer t
  :config
  (add-to-list 'eglot-server-programs '(elixir-mode "~/git/elixir-ls/release/language_server.sh")))

;;@ use-package/internet ;;
(use-package erc
  ;; sasl support! (29)
  :defer t
  :init
  (defun erc-libera ()
    (interactive)
    (erc-tls :server "irc.libera.chat" :port 6697
             :nick "dongdigua"
             :client-certificate
             ;; must use absolute path, otherwise it will stuck at "Opening connection.."
             '("/home/digua/.emacs.d/cert/libera.key"
               "/home/digua/.emacs.d/cert/libera.crt")))
  (defun erc-bouncer ()
    (interactive)
    (erc :server "r2s.local" :port 6667
         :nick "dongdigua"
         :user "dongdigua/irc.libera.chat"
         :password ""))
  (defun erc-chathistory ()
    ;; https://lists.sr.ht/~sircmpwn/sr.ht-discuss/<87il2c12e0.fsf@ryzen.jonjfineman.com>
    (interactive)
    (insert (concat "/quote CHATHISTORY LATEST " (buffer-name) " * 100")))
  :config
;;ifdef dump
  (setq erc-modules
        ;; customize and copy to here
        '(button completion fill irccontrols log match menu move-to-prompt netsplit networks noncommands notifications readonly ring sasl stamp track truncate list replace))
;;endif dump
  (erc-update-modules)
  (setq erc-email-userid "dongdigua"
        erc-log-channels-directory "~/.emacs.d/erc-log"
        erc-notice-prefix "! "
        erc-replace-alist '(("<nichi_bot> " . ""))))

(use-package eww
  :init
  (setq browse-url-handlers
        '( ; use alist in browse-url-browser-function is deprecated
          ("^https?://youtu\\.be"            . browse-url-firefox)
          ("^https?://.*youtube\\..+"        . browse-url-firefox)
          ("^https?://.*bilibili\\.com"      . browse-url-firefox)
          ("^https?://.*zhihu\\.com"         . browse-url-firefox)
          ("^https?://.*reddit\\.com"        . browse-url-firefox)
          ("^https?://.*github\\.com"        . browse-url-firefox)
          ("^https?://.*stackoverflow\\.com" . browse-url-firefox)
          ("^https?://.*stackexchange\\.com" . browse-url-firefox)
          ("^https?://t\\.co"                . browse-url-firefox)
          ("^http://phrack\\.org"            . eww-browse-no-pre-hl)
          ("gopher://.*"                     . elpher-browse-url-elpher)
          ("gemini://.*"                     . elpher-browse-url-elpher)
          ))
  :defer t
  :config
  (defun eww-browse-no-pre-hl (url &optional new-window)
    (eww-browse-url url new-window)
    (setq-local shr-external-rendering-functions nil))
  (evil-define-key 'normal eww-mode-map (kbd "^") 'eww-back-url) ; like elpher
  (evil-define-key 'normal eww-mode-map (kbd "C") 'eww-copy-page-url) ; like elpher
  (evil-define-key 'normal eww-mode-map (kbd "&") 'eww-browse-with-external-browser))

(use-package elpher
  :defer t
  :config
  ;; I usually fire up a local agate server to test my content
  (setq elpher-default-url-type "gemini"
        elpher-certificate-directory "~/.emacs.d/cert/"))

(use-package shr-tag-pre-highlight
  ;; render code block in eww
  :defer t
  :after shr
  :config
  (add-to-list 'shr-external-rendering-functions
               '(pre . shr-tag-pre-highlight)))

;; (use-package gnus
;;   :defer t
;;   :config
;;   ;; yeah I can access the usenet in China
;;   ;; found this address on wikipedia
;;   (setq gnus-select-method '(nntp "freenews.netfront.net"))
;;   (setq gnus-default-directory "~/.emacs.d/Gnus/") 
;;   (setq gnus-dribble-directory "~/.emacs.d/Gnus/") 
;;   (setq gnus-startup-file "~/.emacs.d/Gnus/.newsrc") 
;;   (setq gnus-asynchronous t))



;;@ end of init ;;
(setq initial-scratch-message
      (concat
       (emacs-init-time ";; %2.4f secs, ")
       (format "%d gcs\n" gcs-done)
       (buttonize ";; (config)" (lambda (_) (find-file-existing "~/.emacs.d/init.el")))
       "\n"
       (buttonize ";; (collections)" (lambda (_) (find-file-existing "~/git/dongdigua.github.io/org/internet_collections.org")))
       "\n"
       (buttonize ";; (quotes)" (lambda (_) (find-file-existing "~/git/dongdigua.github.io/quotes.txt")))
       "\n"
       ))

(setq gc-cons-threshold normal-gc-threshold)
