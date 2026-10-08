;; Recommended minimal starting Emacs Init File
;; extracted from the book:
;; /Use GNU Emacs: The Plain Text Computing Environment/
;; by Keith Waclena
;; https://www.lib.uchicago.edu/keith/emacs/
;;


(require 'package)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(when (version< emacs-version "26.3")
  ;; older emacsen < 26.3 may need this
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))
(with-eval-after-load 'package
  (dolist (arc '(("nongnu" . "https://elpa.nongnu.org/nongnu/")
                 ("melpa-stable" . "https://stable.melpa.org/packages/")
                 ("melpa" . "https://melpa.org/packages/")))
    (add-to-list 'package-archives arc t))
  (setq package-archive-priorities
        '(("gnu" . 10) ("nongnu" . 9) ("melpa-stable" . 8) ("melpa" . 7))))

;; thanks to an anonymous EmacsWiki coder
(defun undo-yank (arg)
  "Undo the yank you just did.  Really, adjust just-yanked text
like \\[yank-pop] does, but in the opposite direction."
  (interactive "p")
  (yank-pop (- arg)))
(keymap-global-set "C-M-y" 'undo-yank)

(setq enable-recursive-minibuffers t)

(with-eval-after-load 'chistory
  (setq list-command-history-max 120)
  (define-key command-history-map (kbd "<return>") 'command-history-repeat))

(setq completion-styles '(partial-completion substring flex))
(unless (package-installed-p 'vertico)
  (with-demoted-errors "%s"
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'vertico)))
(with-demoted-errors "%s" (vertico-mode +1))

(unless (package-installed-p 'marginalia)
  (with-demoted-errors "%s"
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'marginalia)))
(with-demoted-errors "%s" (marginalia-mode +1))

(unless (package-installed-p 'windmove)
  (with-demoted-errors "%s"
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'windmove)))
;; <S-{left,right,up,down}> switches windows
(with-demoted-errors "%s" (windmove-default-keybindings))

(winner-mode +1) ; undo window config changes
;; add more felicitous bindings
(define-key winner-mode-map [(control c) (control left)] 'winner-undo)
(define-key winner-mode-map [(control c) (control right)] 'winner-redo)

(keymap-global-set "C-{" 'shrink-window-horizontally)
(keymap-global-set "C-}" 'enlarge-window-horizontally)
(keymap-global-set "C-^" 'enlarge-window)

(keymap-global-set "C-<" 'scroll-left)
(keymap-global-set "C->" 'scroll-right)

(undelete-frame-mode +1)                ; bring back deleted frames

(setq large-file-warning-threshold (* 100 1024 1024)) ; 100MB

(unless (version<= "29.1" emacs-version) ; no longer necessary!
  (when (version<= "27.1" emacs-version)  ; only available recently...
    (global-so-long-mode +1)))    ; speed up long lines

(setq view-read-only t)

(add-hook 'doc-view-mode-hook 'auto-revert-mode)

(add-hook 'pdf-view-mode-hook 'auto-revert-mode)

(add-hook 'dired-load-hook (lambda () (require 'dired-x)))

(setq dired-dwim-target t)  ; suggest other visible dired buffer

(unless (package-installed-p 'wgrep)
  (with-demoted-errors "%s"
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'wgrep)))

(add-hook 'kill-emacs-query-functions
          'custom-prompt-customize-unsaved-options)
;;markdown-mode
(unless (package-installed-p 'markdown-mode)
  (with-demoted-errors "%s"
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'markdown-mode)))

;;markdown-mode
(unless (package-installed-p 'obsidian)
  (with-demoted-errors "%s"
    (unless package-archive-contents
      (package-refresh-contents))
    (package-install 'obsidian)))

(when (package-installed-p 'markdown-mode) (autoload 'markdown-mode "markdown-mode"
   "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist
             '("\\.\\(?:md\\|markdown\\|mkd\\|mdown\\|mkdn\\|mdwn\\)\\'" . markdown-mode) )
 (add-hook 'markdown-mode-hook 'ruler-mode)
 )


(desktop-save-mode +1)   ; restore files from previous session

(save-place-mode +1)   ; come back to where we were in that file

(keymap-global-set "C-+" 'text-scale-adjust) ; embiggen font

(setq-default indent-tabs-mode nil)      ; don't insert tabs

(setq async-shell-command-buffer 'new-buffer) ;multiple async commands ok!
(setq async-shell-command-display-buffer nil) ;don't pop up the buffer

(setq comint-buffer-maximum-size 65336) ; must be able to cat War and Peace!
(add-hook 'comint-output-filter-functions 'comint-truncate-buffer)

;; goto-address-mode is handy in these modes
(dolist (hook '(shell-mode-hook eshell-mode-hook))
  (add-hook hook #'goto-address-mode))
(add-hook 'prog-mode-hook #'goto-address-prog-mode)

(setq calendar-mark-holidays-flag t        ; colorize holidays in the calendar
      calendar-mark-diary-entries-flag t)  ; also diary entries

(setq org-agenda-include-diary t)  ; incorporate the diary into the agenda

(appt-activate +1)        ; appointment notifications, please
(require 'notifications)  ; also via desktop notifications

;; don't use a separate Frame for the control panel
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
;; horizontal split is more readable
(setq ediff-split-window-function 'split-window-horizontally)

;; restore window config upon quitting ediff
(defvar ue-ediff-window-config nil "Window config before ediffing.")
(add-hook 'ediff-before-setup-hook
          (lambda ()
            (setq ue-ediff-window-config (current-window-configuration))))
(dolist (hook '(ediff-suspend-hook ediff-quit-hook))
  (add-hook hook
            (lambda ()
              (set-window-configuration ue-ediff-window-config))))

(setopt proced-enable-color-flag t)     ; colorful proced

(setq dictionary-server "dict.org")     ; we don't run our own server

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(global-obsidian-mode t)
 '(obsidian-directory "/home/alfred/Documents/japanese/")
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(global-tab-line-mode +1)
(keymap-global-set "C-x C-b" 'ibuffer)

(global-display-line-numbers-mode +1)
