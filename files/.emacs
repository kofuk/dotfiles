;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(add-to-list 'load-path "~/src/el")

(setq make-backup-files nil)
(setq abbrev-mode t)
(global-font-lock-mode 1)
(setq font-lock-support-mode 'jit-lock-mode)
(setq font-lock-maximum-decornation t)
(show-paren-mode t)
(setq show-paren-style 'mixed)
;; Auto complete
(ac-config-default)
(setq ac-use-menu-map t)
(global-auto-complete-mode 1)
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
;; Disable menu bar since it is not needed.
(menu-bar-mode -1)
;; Use C-h as <Delback>.
(global-set-key "\C-h" 'delete-backward-char)
;; Disable bell
(setq ring-bell-function 'ignore)
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
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "bsd")))
 '(package-selected-packages '(nhexl-mode auto-complete company-go)))
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

(add-hook 'dired-mode-hook (lambda()
			     (dired-hide-details-mode)))

(require 'postfix)
(add-to-list 'postfix-snippets-alist '("go" . "~/.emacs.d/postfix-snip/go"))
(add-to-list 'postfix-snippets-alist '("c" . "~/.emacs.d/postfix-snip/c"))
(global-set-key (kbd "C-c RET") 'postfix-completion)
