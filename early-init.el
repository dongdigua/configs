(setq gc-cons-threshold most-positive-fixnum)

(if (display-graphic-p)
    (let ((hour-now (string-to-number (format-time-string "%H"))))
      (if (>= hour-now 20)
          (set-face-attribute 'default nil :background bg :foreground bg))))

(tool-bar-mode               -1)
(menu-bar-mode               -1)
(scroll-bar-mode             -1)
(column-number-mode           t)
(setq inhibit-startup-message t)
(setq use-dialog-box        nil)

(setq frame-title-format '(multiple-frames "%b"
                 ("" "%b - Black Source: Emacs @ " system-name)))

;; set transparent effect (29)
(add-to-list 'default-frame-alist '(alpha-background . 85))

;; native smooth scrolling (29)
(pixel-scroll-precision-mode)
