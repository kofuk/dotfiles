;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(load-theme 'manoj-dark t)

(setq make-backup-files nil)
(global-font-lock-mode 1)
(setq font-lock-support-mode 'jit-lock-mode)
(setq font-lock-maximum-decornation t)
(show-paren-mode t)
(setq show-paren-style 'mixed)
;; Display line and column number in mode line.
(line-number-mode 1)
(column-number-mode 1)
(setq transient-mark-mode t)
(setq hl-line-face 'underline)
;; Display datetime.
(setq display-time-interval 1)
(setq display-time-string-forms
      '((format "%s/%s/%s(%s) %s:%s:%s" year month day dayname 24-hours minutes seconds)))
(display-time)
(display-time-mode 1)
(global-hl-line-mode)
;; Start up screen
(setq inhibit-startup-screen t)
;; Disable menu bar since it is not needed.
(menu-bar-mode -1)
;; Use C-h as <Delback>.
(global-set-key "\C-h" 'delete-backward-char)
;; ido
(ido-mode 1)
(ido-everywhere 1)
(setq ido-enable-flex-matching t)
;; Alternate bell
(defun modeline-bell ()
  (set-face-background 'mode-line "yellow")
  (run-at-time "100 millisec" nil #'set-face-background #'mode-line "white"))
(setq ring-bell-function 'modeline-bell)
;; Save cursor position
(if (fboundp 'save-place-mode) (save-place-mode 1) (setq-default save-place t))
;; Follow symbolic links to versioned files
(setq vc-follow-symlinks t)
;; Don't make backup file
(setq make-backup-files t)
;; Show whitespaces
(setq whitespace-style '(face trailing tabs tab-mark))
(setq-default indent-tabs-mode nil)
(global-whitespace-mode 1)
;; Make inserting line easy
(defun open-next-line ()
  "Opens new line in next line of the cursor and move cursor to the line."
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))
(global-set-key "\C-j" 'open-next-line)
(global-set-key (kbd "C-c -") 'split-window-vertically)
(global-set-key (kbd "C-c |") 'split-window-horizontally)
;; Make Emacs to put '\n' at the end of file
(setq require-final-newline t)
;; Spell check
(setq-default ispell-program-name "aspell")
;; Enable flyspell mode automatically only if I edit plain text file.
;; flyspell-prog-mode disturb completion from working properly thus I don't
;; enable it if I edit source code.
(mapc (lambda (hook)
	(add-hook hook '(lambda () (flyspell-mode 1))))
      '(text-mode-hook))
(global-set-key (kbd "C-c <C-right>") 'next-buffer)
(global-set-key (kbd "C-c <C-left>") 'previous-buffer)
;; Auto complete
(use-package auto-complete
  :config
  (ac-config-default)
  (setq ac-use-menu-map t)
  (global-auto-complete-mode 1))
;; Abbrev
(setq abbrev-mode t)
(setq save-abbrevs t)
(quietly-read-abbrev-file)
(global-set-key "\C-x'" 'just-one-space)
(global-set-key "\M- " 'dabbrev-expand)
(global-set-key "\M-/" 'expand-abbrev)
(eval-after-load "abbrev" '(global-set-key "\M-/" 'expand-abbrev))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(c-default-style
   (quote
    ((java-mode . "java")
     (awk-mode . "awk")
     (other . "bsd"))))
 '(default-input-method "japanese-skk")
 '(global-fixmee-mode t)
 '(global-git-gutter-mode t)
 '(package-selected-packages
   (quote
    (ac-html mmm-mode twittering-mode smartparens git-gutter bison-mode eglot lsp-mode ddskk ac-php go-mode magit git-commit nhexl-mode auto-complete company-go)))
 '(smartparens-global-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(add-hook 'dired-mode-hook (lambda()
			     (dired-hide-details-mode)))

(setq skk-jisyo-code 'utf-8)

(use-package eglot
  :config
  (when (executable-find "clangd-9")
    (add-to-list 'eglot-server-programs '((c-mode c++-mode ) "clangd-9")))
  (when (executable-find "clnagd")
    (add-to-list 'eglot-server-programs '((c-mode c++-mode ) "clangd")))
  (add-hook 'c-mode-hook 'eglot-ensure)
  (add-hook 'c++-mode-hook 'eglot-ensure))

(use-package twittering-mode
  :config
  (if (file-exists-p (expand-file-name "~/.emacs.d/twit.el"))
      (load (expand-file-name "~/.emacs.d/twit.el")))
  (setq twittering-timer-interval 60)
  (setq twittering-display-remaining t)
  (define-key twittering-mode-map "F" 'twittering-favorite))
