;;; package --- Summary

;;; Commentary:


;;; Code:
(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
                         ;; ("org" . "http://orgmode.org/elpa/")))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))


;; Always use utf-8:
(set-charset-priority 'unicode)
(prefer-coding-system 'utf-8-unix)


;; Show filename in title
(setq frame-title-format
      (list (format "%s %%S: %%j " (system-name))
        '(buffer-file-name "%f" (dired-directory dired-directory "%b"))))


;; Don't produce backup-files...:
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

;; Make sure Emacs finds the right path:
;; (use-package exec-path-from-shell
  ;; :init (exec-path-from-shell-initialize))


;; Stop Emacs from hiding:
(unbind-key "C-z") ;; suspend-frame


;; Delete whitespaces:
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(setq require-final-newline t)


;; More emphasis on active buffer:
;; (require 'dimmer)
;;  (dimmer-configure-which-key)
;;  (dimmer-configure-helm)
;;  (dimmer-mode t)

;; (use-package dimmer
;;   :custom (dimmer-fraction 0.1)
;;   :config (dimmer-mode))


;; (show-paren-mode)
;; (setq show-paren-style 'expression)
;; (use-package rainbow-delimiters
  ;; :hook ((prog-mode . rainbow-delimiters-mode)))
;; (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
;; (electric-pair-mode)


;; short-cut for editing config.el:
(defun open-init-file ()
  "Open this very file."
  (interactive)
  (find-file "~/.emacs.d/config.el"))
(bind-key "C-c e" #'open-init-file)


;; edit files with sudo:
(use-package sudo-edit)


;; Delight sets special fonts
(use-package delight :ensure t)
(use-package use-package-ensure-system-package :ensure t)


;; Always show linenumbers in the left margin:
(global-display-line-numbers-mode 1)


(setq-default
 ad-redefinition-action 'accept                   ; Silence warnings for redefinition
 cursor-in-non-selected-windows t                 ; Hide the cursor in inactive windows
 display-time-default-load-average nil            ; Don't display load average
 fill-column 80                                   ; Set width for automatic line breaks
 help-window-select t                             ; Focus new help windows when opened
 ;; indent-tabs-mode nil                             ; Prefer spaces over tabs
 inhibit-startup-screen t                         ; Disable start-up screen
 initial-scratch-message ""                       ; Empty the initial *scratch* buffer
 kill-ring-max 128                                ; Maximum length of kill ring
 load-prefer-newer t                              ; Prefer the newest version of a file
 mark-ring-max 128                                ; Maximum length of mark ring
 read-process-output-max (* 1024 1024)            ; Increase the amount of data reads from the process
 scroll-conservatively most-positive-fixnum       ; Always scroll by one line
 select-enable-clipboard t                        ; Merge system's and Emacs' clipboard
 tab-width 4                                      ; Set width for tabs
 use-package-always-ensure t                      ; Avoid the :ensure keyword for each package
 user-full-name "Johan Thor"                      ; Set the full name of the current user
 ;;user-mail-address "terencio.agozzino@gmail.com"  ; Set the email address of the current user
 vc-follow-symlinks t                             ; Always follow the symlinks
 fast-but-imprecise-scrolling t                   ; More scrolling performance!
 view-read-only t)                                ; Always open read-only buffers in view-mode
(column-number-mode 1)                            ; Show the column number
(fset 'yes-or-no-p 'y-or-n-p)                     ; Replace yes/no prompts with y/n
(global-hl-line-mode)                             ; Hightlight current line
(set-default-coding-systems 'utf-8)               ; Default to utf-8 encoding
(show-paren-mode 1)                               ; Show the parent

(defvar xdg-bin (getenv "XDG_BIN_HOME")
  "The XDG bin base directory.")

(defvar xdg-cache (getenv "XDG_CACHE_HOME")
  "The XDG cache base directory.")

(defvar xdg-config (getenv "XDG_CONFIG_HOME")
  "The XDG config base directory.")

;; (defvar xdg-data (getenv "XDG_DATA_HOME")
;;   "The XDG data base directory.")

;; (defvar xdg-lib (getenv "XDG_LIB_HOME")
;;   "The XDG lib base directory.")

;; Set the font:
(set-face-attribute 'default nil :font "Source Code Pro" :height 160)


;; Uppstartsposition och storlek:
;;(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; (set-frame-size (selected-frame) 100 55)
;; (set-frame-position (selected-frame) 1100 140)


;; By default, I want paste operations to indent their results. I could express
;; this as defadvice around the yank command, but I try to avoid such measures
;; if possible.
(defun pt-yank ()
  "Call yank, then indent the pasted region, as TextMate does."
  (interactive)
  (let ((point-before (point)))
    (when mark-active (call-interactively 'delete-backward-char))
    (yank)
    (indent-region point-before (point))))

(bind-key "C-y" #'pt-yank)
(bind-key "s-v" #'pt-yank)
(bind-key "C-Y" #'yank)


;; Don't turn on highlighting mode of the current line
;; in e.g. vterm:
(require 'hl-line)
(add-hook 'prog-mode-hook #'hl-line-mode)
(add-hook 'text-mode-hook #'hl-line-mode)
(set-face-attribute 'hl-line nil :background "gray21")


;; Kommentera/bortkommentera oberoende av språk:
(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (comment-or-uncomment-region (line-beginning-position) (line-end-position))
    )
  )

(global-set-key (kbd "C-1") 'comment-or-uncomment-line-or-region)



;; Scrollhastighet, musen: De här båda slöar ner scrollningen mycket!!
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)


;; Bootstrap straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))


;; Integrates `straight' directly into the `use-package' package through the `:straight' expression.
(straight-use-package 'use-package)


;; I needed to install these manually by M-x install-package?
;; Appearance of Emacs:
(use-package doom-themes
  :straight t
  :config
  (load-theme 'doom-material t)
  (doom-themes-org-config))

(use-package doom-modeline
  :straight t
  :init (doom-modeline-mode)
  :custom
  (doom-modeline-icon (display-graphic-p))
  (doom-modeline-mu4e t))


;; darken "unreal" buffers to focus on
;; the ones you code in:
(use-package solaire-mode
  :straight t
  :defer 0.1
  :custom (solaire-mode-remap-fringe t)
  :config (solaire-global-mode))


;; ;; add icons to the files:
(use-package all-the-icons-completion
  :straight t
  :after (marginalia all-the-icons)
  :hook (marginalia-mode . all-the-icons-completion-marginalia-setup))


;; Use flycheck to check code...
(use-package flycheck
  :straight t
  :ensure t
  :init (global-flycheck-mode))
;; How can this be set on a per project way?
;; It seems flake8 doesn't support this...
;; (setq flycheck-flake8rc "/home/johanthor/.config/.flake8")


;; ibuffer
(use-package ibuffer
  :straight t
  :ensure nil
  :preface
  (defvar protected-buffers '("*scratch*" "*Messages*")
    "Buffer that cannot be killed.")

  (defun my/protected-buffers ()
    "Protect some buffers from being killed."
    (dolist (buffer protected-buffers)
      (with-current-buffer buffer
        (emacs-lock-mode 'kill))))
  :bind ("C-x C-b" . ibuffer)
  :init (my/protected-buffers))


;; windmove
(use-package windmove
  :straight t
  :bind
  (("M-j" . windmove-left)
  ("M-i" . windmove-up)
  ("M-k" . windmove-down)
  ("M-l" . windmove-right)))


;; ;; magit
;; (use-package magit
;;   :diminish magit-auto-revert-mode
;;   :diminish auto-revert-mode
;;   :bind (("C-c g" . #'magit-status))
;;   :custom
;;   (magit-repository-directories '(("~/code" . 1)))
;;   :config
;;   (add-to-list 'magit-no-confirm 'stage-all-changes))

;; (use-package magit-filenotify
;;   :straight t
;;   :commands (magit-filenotify-mode)
;;   :hook (magit-status-mode . magit-filenotify-mode))


;; ;; optionally if you want to use debugger
;; (use-package dap-mode)
;; ;; (use-package dap-LANGUAGE) to load the dap adapter for your language


;; ;; optional if you want which-key integration
;; (use-package which-key
;;     :config
;;     (which-key-mode))


;; imenu
(use-package imenu
  :straight t
  :ensure nil
  :preface
  (defun my/smarter-move-beginning-of-line (arg)
    "Move point back to indentation of beginning of line.

   Move point to the first non-whitespace character on this line.
   If point is already there, move to the beginning of the line.
   Effectively toggle between the first non-whitespace character and
   the beginning of the line.

   If ARG is not nil or 1, move forward ARG - 1 lines first. If
   point reaches the beginning or end of the buffer, stop there."
    (interactive "^p")
    (setq arg (or arg 1))

    ;; Move lines first
    (when (/= arg 1)
      (let ((line-move-visual nil))
        (forward-line (1- arg))))

    (let ((orig-point (point)))
      (back-to-indentation)
      (when (= orig-point (point))
        (move-beginning-of-line 1))))
  :bind (("C-a" . my/smarter-move-beginning-of-line)
         ("C-r" . imenu)))


;;
(use-package window
  :ensure nil
  :bind (("C-x 2" . vsplit-last-buffer)
         ("C-x 3" . hsplit-last-buffer)
         ;; Don't ask before killing a buffer.
         ([remap kill-buffer] . kill-this-buffer))
  :preface
  (defun hsplit-last-buffer ()
    "Focus to the last created horizontal window."
    (interactive)
    (split-window-horizontally)
    (other-window 1))

  (defun vsplit-last-buffer ()
    "Focus to the last created vertical window."
    (interactive)
    (split-window-vertically)
    (other-window 1)))

;; (use-package centered-window
;;   :custom
;;   (cwm-centered-window-width 130)
;;   (cwm-frame-internal-border 0)
;;   (cwm-incremental-padding t)
;;   (cwm-incremental-padding-% 2)
;;   (cwm-left-fringe-ratio 0)
;;   (cwm-use-vertical-padding t)
;;   :config (centered-window-mode))



;; (use-package switch-window
;;   :bind (("C-x o" . switch-window)
;;          ("C-x w" . switch-window-then-swap-buffer)))


;; (use-package winner
;;   :ensure nil
;;   :config (winner-mode))


;; vertico provides vertical interactive mode for autocompletion
(use-package vertico
  :straight (:files (:defaults "extensions/*"))
  :init (vertico-mode)
  :bind (:map vertico-map
              ("C-<backspace>" . vertico-directory-up))
  :custom (vertico-cycle t)
  :custom-face (vertico-current ((t (:background "#1d1f21")))))


;;
(use-package marginalia
  :straight t
  :after vertico
  :init (marginalia-mode)
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil)))


;;
(use-package sh-script
  :straight t
  :delight "δ"
  :ensure nil
  :hook (after-save . executable-make-buffer-file-executable-if-script-p))


;;
(use-package csv-mode :mode ("\\.\\(csv\\|tsv\\)\\'"))


;;
(use-package dockerfile-mode :delight "δ" :mode "Dockerfile\\'")


;;
(use-package yaml-mode)


;;
(use-package toml-mode)


;; ;;
(use-package json-mode
  :straight t
  :delight "J"
  :mode "\\.json\\'"
  :hook (before-save . my/json-mode-before-save-hook)
  :preface
  (defun my/json-mode-before-save-hook ()
    (when (eq major-mode 'json-mode)
      (json-pretty-print-buffer)))

  (defun my/json-array-of-numbers-on-one-line (encode array)
    "Print the arrays of numbers in one line."
    (let* ((json-encoding-pretty-print
            (and json-encoding-pretty-print
                 (not (loop for x across array always (numberp x)))))
           (json-encoding-separator (if json-encoding-pretty-print "," ", ")))
      (funcall encode array)))
  :config (advice-add 'json-encode-array :around #'my/json-array-of-numbers-on-one-line))



;; Markdown
(use-package markdown-mode
  :straight t
  :delight "μ"
  :mode ("\\.\\(md\\|markdown\\)\\'")
  :custom (markdown-command "/usr/bin/pandoc"))

(use-package markdown-preview-mode
  :commands markdown-preview-mode
  :custom
  (markdown-preview-javascript
   (list (concat "https://github.com/highlightjs/highlight.js/"
                 "9.15.6/highlight.min.js")
         "<script>
            $(document).on('mdContentChange', function() {
              $('pre code').each(function(i, block)  {
                hljs.highlightBlock(block);
              });
            });
          </script>"))
  (markdown-preview-stylesheets
   (list (concat "https://cdnjs.cloudflare.com/ajax/libs/github-markdown-css/"
                 "3.0.1/github-markdown.min.css")
         (concat "https://github.com/highlightjs/highlight.js/"
                 "9.15.6/styles/github.min.css")

         "<style>
            .markdown-body {
              box-sizing: border-box;
              min-width: 200px;
              max-width: 980px;
              margin: 0 auto;
              padding: 45px;
            }

            @media (max-width: 767px) { .markdown-body { padding: 15px; } }
          </style>")))


;; sql
(use-package sql-mode
  :ensure nil
  :mode "\\.sql\\'")


(use-package sql-indent
  :delight sql-mode "Σ"
  :hook (sql-mode . sqlind-minor-mode))


;; company - completion popups
(use-package company
  :straight t
  :diminish company-mode
  :init
  (global-company-mode)
  :hook (prog-mode . company-mode)
  :custom
  (company-dabbrev-downcase nil "Don't downcase returned candidates.")
  (company-show-numbers t "Numbers are helpful.")
  (company-tooltip-limit 10 "The more the merrier.")
  (company-tooltip-idle-delay 0.8 "Faster!")
  ; Show suggestions after entering one character.
  (company-minimum-prefix-length 2)
  (company-selection-wrap-around t)
  ;; Use tab key to cycle through suggestions.
  ;; ('tng' means 'tab and go')
  (company-tng-configure-default)

  (company-async-timeout 20 "Some requests can take a long time. That's fine.")
  :config

  ;; Use the numbers 0-9 to select company completion candidates
  (let ((map company-active-map))
    (mapc (lambda (x) (define-key map (format "%d" x)
   `(lambda () (interactive) (company-complete-number ,x))))
   (number-sequence 0 9)))

  :config
  ;; set default `company-backends'
  (setq company-backends
        '((company-files          ; files & directory
           company-keywords       ; keywords
           company-capf)		  ; completion-at-point-functions
          (company-abbrev company-dabbrev)
          ))

  (use-package company-box
  :hook (company-mode . company-box-mode))

  (use-package company-statistics
    :straight t
    :init
    (company-statistics-mode))

  (use-package company-try-hard
    :straight t
    :bind
    (("C-<tab>" . company-try-hard)
     :map company-active-map
     ("C-<tab>" . company-try-hard)))

  (use-package company-quickhelp
    :straight t
    :config
    (company-quickhelp-mode))
  )


;;
;; (use-package yasnippet
;;   :defer 3 ;; takes a while to load, so do it async
;;   :diminish yas-minor-mode
;;   :config (yas-global-mode)
;;   :custom (yas-prompt-functions '(yas-completing-prompt)))



;; Python-section

;; (use-package python
;;   :mode ("\\.py" . python-mode)
;;   :ensure t
;;   :config
;;   (setq python-shell-interpreter "~/.pyenv/shims/ipython3"
;;         python-shell-interpreter-args "-i --simple-prompt --InteractiveShell.display_page=True")
;;   (setq python-indent-offset 4)

;;   (define-key python-mode-map (kbd "C-c C-r") 'python-shell-send-region)
;;   (define-key python-mode-map (kbd "C-c C-b") 'python-shell-send-buffer)
;; )



;; (use-package lsp-mode
;;   :init
;;   ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
;;   (setq lsp-keymap-prefix "C-c l")
;;   :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
;;          (python-mode . lsp)
;;          (latex-mode . lsp)
;;          ;; if you want which-key integration
;;          (lsp-mode . lsp-enable-which-key-integration))
;;   :commands lsp)

;; ;; optionally
;; (use-package lsp-ui :commands lsp-ui-mode)
;; ;; if you are helm user
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
;; (use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)


;; ;; pip install pyright needs to be pip-installed in the env you're using
;; (use-package lsp-pyright
;;   :ensure t
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-pyright)
;;                           (lsp))))  ; or lsp-deferred


;; Pyenv
;; (use-package pyenv
;;     :straight (:host github :repo "aiguofer/pyenv.el")
;;     :config
;;     ;; (setq pyenv-use-alias 't)
;;     (setq pyenv-modestring-prefix " ")
;;     (setq pyenv-modestring-postfix nil)
;;     ;; (setq pyenv-set-path nil)
;;     (setq pyenv-set-path ".pyenv/shims")

;;     (global-pyenv-mode)
;;     (defun pyenv-update-on-buffer-switch (prev curr)
;;       (if (and (string-equal "Python" (format-mode-line mode-name nil nil curr))
;;                (not (cl-search ".pyenv/versions" (buffer-file-name))))
;;           (progn
;;             (pyenv-use-corresponding)
;;             (pyvenv-activate (concat (pyenv--prefix) "/"))
;;             )))
;;     (add-hook 'switch-buffer-functions 'pyenv-update-on-buffer-switch)
;;     )

;;   (use-package buftra
;;     :straight (:host github :repo "humitos/buftra.el"))


;; for good function-commenting:
;; (use-package py-pyment
;;     :straight (:host github :repo "humitos/py-cmd-buffer.el")
;;     :config
;;     (setq py-pyment-options '("--output=numpydoc")))


;;
;; (use-package python-docstring
;;     :straight t
;;     :hook (python-mode . python-docstring-mode))


;; (use-package blacken
;;   :delight
;;   :hook (python-mode . blacken-mode))

;; (use-package py-isort
;;   :hook ((before-save . py-isort-before-save)
;;          (python-mode . py-isort-enable-on-save))
;;   :config
;;   (setq py-isort-options '("-l=88" "--profile=black")))



;; LaTeX
(use-package tex
  :ensure auctex
  :preface
  (defun my/switch-to-help-window (&optional ARG REPARSE)
    "Switches to the *TeX Help* buffer after compilation."
    (other-window 1))
  :hook (LaTeX-mode . reftex-mode)
  :bind (:map TeX-mode-map
              ("C-c C-o" . TeX-recenter-output-buffer)
              ("C-c C-l" . TeX-next-error)
              ("M-[" . outline-previous-heading)
              ("M-]" . outline-next-heading))
  :custom
  (TeX-auto-save t)
  (TeX-byte-compile t)
  (TeX-clean-confirm nil)
  (TeX-master 'dwim)
  (TeX-parse-self t)
  (TeX-PDF-mode t)
  (TeX-source-correlate-mode t)
  (TeX-view-program-selection '((output-pdf "PDF Tools")))
  :config
  (advice-add 'TeX-next-error :after #'my/switch-to-help-window)
  (advice-add 'TeX-recenter-output-buffer :after #'my/switch-to-help-window)
  ;; the ":hook" doesn't work for this one... don't ask me why.
  (add-hook 'TeX-after-compilation-finished-functions 'TeX-revert-document-buffer))

(setq-default TeX-engine 'xetex)

;; (add-to-list 'load-path "/Users/johanthor/.emacs.d/elpa/lsp-latex-20210815.1426")
;; (require 'lsp-latex)
;; ;; "texlab" must be located at a directory contained in `exec-path'.
;; ;; If you want to put "texlab" somewhere else,
;; ;; you can specify the path to "texlab" as follows:
;; (setq lsp-latex-texlab-executable "/home/linuxbrew/.linuxbrew/bin/texlab")

(with-eval-after-load "tex-mode"
 (add-hook 'tex-mode-hook 'lsp)
 (add-hook 'latex-mode-hook 'lsp))






;;; config.el ends here
