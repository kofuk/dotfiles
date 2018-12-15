;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
;(add-to-list 'package-archives '("marmalade" . "https://marmalade-repo.org/packages/") t)

(global-font-lock-mode 1)
(setq font-lock-support-mode 'jit-lock-mode)
(setq font-lock-maximum-decornation t)
(global-linum-mode)
(show-paren-mode t)
(setq show-paren-style 'mixed)
;; Auto complete
(require 'auto-complete-config)
(ac-config-default)
(setq ac-use-menu-map t)
(global-auto-complete-mode 1)
;; Display line and column number in mode line.
(line-number-mode 1)
(column-number-mode 1)
;; Display line number in left of the display.
;; Reserve 4 columns for 1000-line-over files.
(setq linum-format "%4d \u2502")
(setq transient-mark-mode t)
(setq hl-line-face 'underline)
;; Display datetime.
(setq display-time-interval 1)
(setq display-time-string-forms
      '((format "%s/%s/%s(%s) %s:%s:%s" year month day dayname 24-hours minutes seconds)))
(display-time)
(display-time-mode 1)
(global-hl-line-mode)
;; Disable menu bar since it is not needed.
(menu-bar-mode -1)
;; Use C-h as <Delback>.
(global-set-key "\C-h" 'delete-backward-char)
;; Disable bell
(setq ring-bell-function 'ignore)
;; Save cursor position
(save-place-mode 1)
;; Follow symbolic links to versioned files
(setq vc-follow-symlinks t)
;; Don't make backup file
(setq make-backup-files t)
;; Show whitespaces
(require 'whitespace)
(setq whitespace-style '(face trailing tabs tab-mark))
(global-whitespace-mode 1)
;; Make inserting line easy
(defun open-next-line ()
  "Opens new line in next line of the cursor and move cursor to the line."
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))
(global-set-key "\C-j" 'open-next-line)
;; Golang
(require 'company-go)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (auto-complete company-go))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-lock-builtin-face ((t (:foreground "cyan"))))
 '(font-lock-comment-face ((t (:foreground "brightblack"))))
 '(font-lock-function-name-face ((t (:foreground "white"))))
 '(font-lock-keyword-face ((t (:foreground "brightyellow"))))
 '(font-lock-string-face ((t (:foreground "magenta"))))
 '(font-lock-type-face ((t (:foreground "brightcyan"))))
 '(font-lock-variable-name-face ((t (:foreground "brightblue"))))
 '(whitespace-tab ((t (:foreground "lightgray")))))
;; Set up initial layout
(add-hook 'after-init-hook (lambda()
			      (setq w (selected-window))
			      (setq dired-window (split-window-horizontally (- (window-width w) 30)))
			      (select-window dired-window)
			      (dired ".")
			      (select-window w)))
(add-hook 'dired-mode-hook (lambda()
			     (dired-hide-details-mode)))
