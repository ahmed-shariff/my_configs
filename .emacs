;;; package -- Summary

;;; Commentary:

;;; Code:

;; -*- emacs-lisp -*-
;; 
(require 'package)
(set-language-environment "UTF-8")
(set-default-coding-systems 'utf-8)

;;mepla setup****************************************************
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t);'("elpy" . "http://jorgenschaefer.github.io/packages/"))
;	     '("melpa" . "http://melpa.org/packages/")
;	     '("org" . "http://orgmode.org/elpa/"))
; (add-to-list 'load-path "~/.emacs.d/customFiles")

(setq load-prefer-newer t) ;;mkaing sure older byte compiled files are not loaded

(let ((default-directory  "~/.emacs.d/customFiles/"))
  (normal-top-level-add-to-load-path `("."))
  (normal-top-level-add-subdirs-to-load-path))
(add-to-list 'package-archives
            '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))


(package-initialize)
;; To make sure newer files are being byte compiled 
(require 'auto-compile)
(auto-compile-on-load-mode)
(auto-compile-on-save-mode)

;(package-initialize)      ;; Initialize & Install Package


(defun maximize (&optional f)
  (interactive)
  ;; (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  ;; 	    		 '(2 "_NET_WM_STATE_MAXIMIZED_VERT" 0))
  ;; (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
  ;; 	    		 '(2 "_NET_WM_STATE_MAXIMIZED_HORZ" 0)))
  ;; (toggle-frame-maximized))
  (set-frame-parameter nil 'fullscreen 'maximized))

(maximize)
(add-hook 'after-make-frame-functions 'maximize)
(setq ns-auto-hide-menu-bar t)
(tool-bar-mode 0)

(server-start)
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
;; custom variables*******************************************
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "xdvi")
     (output-pdf "PDF Tools")
     (output-html "xdg-open"))))
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(bookmark-save-flag 1)
 '(company-c-headers-path-system
   (quote
    ("/usr/include/" "/usr/local/include/" "/usr/lib/gcc/x86_64-pc-linux-gnu/6.3.1/")))
 '(custom-enabled-themes (quote (misterioso)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(ede-project-directories
   (quote
    ("/media/Files/Research/FoodClassification/deployment")))
 '(elpy-rpc-python-command "python3")
 '(explicit-shell-file-name "/bin/zsh")
 '(ledger-post-amount-alignment-at :decimal)
 '(ledger-reconcile-default-commodity nil)
 '(ledger-reports
   (quote
    (("asd" "ledger")
     ("a" "ledger ")
     ("bal" "%(binary) -f %(ledger-file) bal")
     ("reg" "%(binary) -f %(ledger-file) reg")
     ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
     ("account" "%(binary) -f %(ledger-file) reg %(account)"))))
 '(org-export-backends (quote (ascii html icalendar latex md)))
 '(package-selected-packages
   (quote
    (quelpa org-plus-contrib org-download org-capture-pop-frame use-package spaceline-all-the-icons org-bullets org-noter latex-math-preview all-the-icons-ivy csproj-mode csharp-mode plantuml-mode jupyter docker dockerfile-mode ascii-art-to-unicode org-ref yasnippet-snippets 2048-game org-brain avy org-capture-pop-frame lsp-ui lsp-mode expand-region diminish amx flx counsel ivy dashboard dired-single ibuffer-vc projectile micgoline dired-hide-dotfiles dired-sidebar magit stumpwm-mode all-the-icons-dired hledger-mode vlf elpy company-auctex auctex pdf-tools yasnippet company-jedi jedi sr-speedbar latex-preview-pane exec-path-from-shell smart-mode-line-powerline-theme slime-company slime slim-mode python-mode flycheck company-quickhelp company-c-headers company-anaconda)))
 '(prolog-system (quote swi))
 '(python-shell-interpreter "python3")
 '(sml/mode-width 15)
 '(sml/shorten-modes t)
 '(sml/theme (quote dark))
 '(use-package-always-ensure t)
 '(visible-bell t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(micgoline-pl-active-green ((t (:inherit mode-line :background "light sky blue" :foreground "#FFFFFF"))))
 '(micgoline-pl-active-red ((t (:inherit mode-line :background "deep sky blue" :foreground "#FFFFFF"))))
 '(micgoline-pl-active-yellow ((t (:inherit mode-line :background "tomato1" :foreground "white"))))
 '(micgoline-pl-inactive-green ((t (:inherit mode-line-inactive :background "slate gray" :foreground "#000000"))))
 '(micgoline-pl-inactive-red ((t (:inherit mode-line-inactive :background "DeepSkyBlue3" :foreground "#FFFFFF"))))
 '(micgoline-pl-inactive-yellow ((t (:inherit mode-line-inactive :background "rosy brown" :foreground "#FFFFFF"))))
 '(mode-line ((t (:inherit mode-line :background "DodgerBlue4" :foreground "#FFFFFF"))))
 '(org-level-1 ((t (:inherit outline-1 :foreground "dark turquoise"))))
 '(org-special-keyword ((t (:inherit outline-1 :foreground "sienna"))))
 '(powerline-active0 ((t (:inherit mode-line :background "medium blue" :foreground "#FFFFFF"))))
 '(powerline-active1 ((t (:inherit mode-line :background "tomato1" :foreground "#FFFFFF"))))
 '(powerline-active2 ((t (:inherit mode-line :background "light sky blue" :foreground "white"))))
 '(company-scrollbar-bg       ((t (:background "#000000"))))
 '(company-scrollbar-fg       ((t (:background "#555555"))))
 '(company-tooltip            ((t (:inherit default :background "#000000"))))
 '(company-tooltip-common     ((t (:inherit font-lock-constant-face))))
 '(company-tooltip-annotation ((t (:inherit font-lock-builtin-face))))
 '(company-tooltip-selection  ((t (:inherit highlight)))))


(setq-default indent-tabs-mode nil)

;(exec-path-from-shell-initialize)

(require 'configurations)
(require 'diminish)
;;allout
(allout-mode)

;;syntax highlight
(global-font-lock-mode 1)

;;add proper word wrapping
(global-visual-line-mode t)

(electric-pair-mode 1)

(setq backup-directory-alist `(("." . "~/.backups_emacs"))
      backup-by-copying t
      delete-old-versions t)

;; Loading symlink-fix (https://www.emacswiki.org/emacs/symlink-fix.el)*************
;; Had to install this to resolve the symlink issues that cropped up with using org in both OS's
(if (not (eq system-type 'windows-nt))
    (progn
      (setq symlink-overload-expand-file-name-p t)
      (require 'symlink-fix)
      (setq expand-file-name-resolve-symlinks-p t))
  (set-face-attribute 'default nil
                      :family "Consolas" :height 105))

;;enable ido mode
;; (require 'ido)
;; (ido-mode t)

(require 'use-package)

;; quelpa **********************************************************
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)

;;ivy-mode *********************************************************
(use-package amx :ensure t
  :init (amx-mode 1))

(use-package ivy :ensure t
  :diminish (ivy-mode . "")             ; does not display ivy in the modeline
  :init
  (ivy-mode 1)                          ; enable ivy globally at startup
  :bind (("C-c g" . counsel-git)
	 ("C-c j" . counsel-git-grep) 
	 ("C-c k" . counsel-ag)       
	 ("C-x l" . counsel-locate)   
	 ("C-S-o" . counsel-rhythmbox)
	 ("C-x C-f" . counsel-find-file)
	 :map ivy-minibuffer-map        ; bind in the ivy buffer
	 ("RET" . ivy-alt-done))
	 ;;      ("s-<"   . ivy-avy)
	 ;;      ("s->"   . ivy-dispatching-done)
	 ;;      ("s-+"   . ivy-call)
	 ;;      ("s-!"   . ivy-immediate-done)
	 ;;      ("s-["   . ivy-previous-history-element)
	 ;;      ("s-]"   . ivy-next-history-element))
  :config
  (setq ivy-use-virtual-buffers t)       ; extend searching to bookmarks and
  (setq ivy-height 15)                   ; set height of the ivy window
  (setq ivy-count-format "(%d) ")     ; count format, from the ivy help page
  (setq ivy-display-style 'fancy)
  (setq ivy-format-function 'ivy-format-function-line) ; Make highlight extend all the way to the right
  ;; TODO testing out the fuzzy search
  (setq ivy-re-builders-alist
      '(;; (read-file-name-internal . ivy--regex-fuzzy)
	;; (internal-complete-buffer . ivy--regex-fuzzy)
	;; (execute-extended-command . ivy--regex-fuzzy)
	;; (amx . ivy--regex-fuzzy)
	(t . ivy--regex-fuzzy))))

;; (use-package all-the-icons-ivy
;;   :ensure t
;;   :config
;;   (all-the-icons-ivy-setup))

(use-package all-the-icons-ivy-rich
  :ensure t
  :init (all-the-icons-ivy-rich-mode 1))

(use-package ivy-rich
  :ensure t
  :init (ivy-rich-mode 1))

(use-package ivy-hydra
  :after (ivy hydra))

;; helm setup ************************************************************************
(use-package helm :ensure t
  ;; :init (helm-mode 1)
  :bind (("M-y" . helm-show-kill-ring))
  )

;;which key **************************************************************************
(use-package which-key :config (which-key-mode))

;;hydra ******************************************************************************
(use-package hydra)
(use-package use-package-hydra)

;;expand-region **********************************************************************
(use-package expand-region
  :bind (("C-=" . hydra-expand-region/body))
  :hydra (hydra-expand-region ()
  "
  [_r_] Expand region    [_w_] Word                [_o_] Inside-quotes    [_c_] Comment
  [_R_] Contract region  [_s_] Symbol              [_O_] Outside-quotes   [_u_] Url    
                       [_S_] Symbol-with-prefix  [_p_] Inside-pairs     [_e_] Email  
                       [_n_] Next-accessor       [_P_] Outside-pairs    [_f_] Defun  
  [_q_] quit             [_m_] Method-call
"
  ("r" er/expand-region)
  ("R" er/contract-region)
  ("w" er/mark-word)
  ("s" er/mark-symbol)
  ("S" er/mark-symbol-with-prefix)
  ("n" er/mark-next-accessor)
  ("m" er/mark-method-call)
  ("o" er/mark-inside-quotes)
  ("O" er/mark-outside-quotes)
  ("p" er/mark-inside-pairs)
  ("P" er/mark-outside-pairs)
  ("c" er/mark-comment)
  ("u" er/mark-url)
  ("e" er/mark-email)
  ("f" er/mark-defun)
  ("q" nil)))

;;mulitple cursor ********************************************************************
(use-package multiple-cursors
  :bind (("C-c m" . hydra-multiple-cursors/body))
  :hydra (hydra-multiple-cursors (:hint nil)
  "
 Up^^             Down^^           Miscellaneous           % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
------------------------------------------------------------------
 [_p_]   Next     [_n_]   Next     [_l_] Edit lines  [_0_] Insert numbers
 [_P_]   Skip     [_N_]   Skip     [_a_] Mark all    [_A_] Insert letters
 [_M-p_] Unmark   [_M-n_] Unmark   [_s_] Search      [_q_] Quit
 [_|_] Align with input CHAR       [Click] Cursor at point"
  ("l" mc/edit-lines :exit t)
  ("a" mc/mark-all-like-this :exit t)
  ("n" mc/mark-next-like-this)
  ("N" mc/skip-to-next-like-this)
  ("M-n" mc/unmark-next-like-this)
  ("p" mc/mark-previous-like-this)
  ("P" mc/skip-to-previous-like-this)
  ("M-p" mc/unmark-previous-like-this)
  ("|" mc/vertical-align)
  ("s" mc/mark-all-in-region-regexp :exit t)
  ("0" mc/insert-numbers :exit t)
  ("A" mc/insert-letters :exit t)
  ("<mouse-1>" mc/add-cursor-on-click)
  ;; Help with click recognition in this hydra
  ("<down-mouse-1>" ignore)
  ("<drag-mouse-1>" ignore)
  ("q" nil)))


;;rainbow delimeters******************************************************************
(use-package rainbow-delimiters
  :commands rainbow-delimiters-mode
  :config
  (add-hook 'emacs-lisp-mode-hook #'rainbow-delimeters-mode)
  (add-hook 'csharp-mode-hook #'rainbow-delimeters-mode)
  (add-hook 'java-mode-hook #'rainbow-delimeters-mode)
  (add-hook 'python-mode-hook #'rainbow-delimeters-mode))

;;lsp-mode ***************************************************************************
(use-package lsp-ui
  :init
  (add-hook 'python-mode-hook #'lsp-ui-mode)
  :config
  (setq lsp-ui-sideline-show-hover t
	lsp-ui-sideline-delay 1))

(use-package company-box
  :hook (company-mode . company-box-mode))


;; about using lsp-csharp for unity, just make sure you have installed latest omnisharp-roslyn and have mono >= 6 installed on your machine
;; the omnisharp-roslyn that lsp-mode install does not work for unity projects because it needs a recent mono version installed and the mono built-in on omnisharp-roslyn doesn't have msbuild, some libs that unity require

(use-package lsp-mode
  :hook (;;(python-mode . lsp)
         (csharp-mode . lsp)
	 (java-mode . lsp)
	 (lsp-mode . lsp-enable-which-key-integration))
  
  :init
  ;; (add-hook 'prog-mode-hook #'lsp)
  ;; (setq lsp-auto-guess-root t)
  ;; (setq lsp-print-io t)
  :config
  ;; (lsp-register-client
  
  ;;  (make-lsp-client :new-connection (lsp-tramp-connection "pyls")
  ;;                   :major-modes '(python-mode)
  ;;                   :remote? t
  ;;                   :server-id 'pyls))
  (setq 
   ;; lsp-pyls-configuration-sources ["flake8"]
   ;; lsp-pyls-plugins-jedi-completion-enabled nil
   ;; lsp-pyls-plugins-pydocstyle-enabled t
   ;; lsp-pyls-plugins-pyflakes-enabled nil
   ;; lsp-pyls-plugins-pycodestyle-max-line-length 110
   ;; lsp-pyls-plugins-rope-completion-enabled nil
   ;; lsp-pyls-plugins-pycodestyle-enabled nil
   ;; lsp-pyls-plugins-yapf-enabled nil
   ;;lsp--delay-timer 1
   gc-cons-threshold 200000000
   read-process-output-max (* 1024 1024 4) ;; 4mb
   lsp-idle-delay 0.500
   lsp-enable-file-watchers nil
   ;; lsp-csharp-server-path (if (eq system-type 'windows-nt)
   ;;      		      (file-truename "~/packages_external/omnisharp-win-x64/OmniSharp.exe")
   ;;      		    nil)
   )
  (lsp-register-custom-settings '(("omnisharp.useGlobalMono" "always"))))

;; (use-package lsp-jedi
;;   :ensure t
;;   :config
;;   (with-eval-after-load "lsp-mode"
;;     (add-to-list 'lsp-disabled-clients 'pyls)
;;     ;; (add-to-list 'lsp-enabled-clients 'jedi)
;;     ))

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp)))
  :config
  (with-eval-after-load "lsp-mode"
    (add-to-list 'lsp-disabled-clients 'pyls)))

(use-package lsp-java)

;; (use-package lsp-python-ms
;;   :ensure t
;;   :init (setq lsp-python-ms-auto-install-server t)
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-python-ms)
;;                           (lsp))))  ; or lsp-deferred

(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode)
  :hook (dap-stopped . (lambda (arg) (call-interactively #'dap-hydra))))
(use-package dap-java :ensure nil)

;;avy *******************************************************************************
(use-package avy
  :bind (("C-S-s" . avy-goto-char)
	 ("C-'" . avy-goto-char-2)
	 ("M-g l" . avy-goto-line)
	 ("M-g w" . avy-goto-word-1))
  :config
  (avy-setup-default))

;;pdf
(when (gethash 'use-pdf-tools configurations t)
  (pdf-tools-install)
  (add-hook 'pdf-view-mode-hook '(lambda ()
				   (pdf-misc-size-indication-minor-mode))))

;;delete-selection-mode
(delete-selection-mode t)
(require 'vlf-setup)

;;speedbar settings
(require 'sr-speedbar)
(global-set-key (kbd "M-s M-s") 'dired-sidebar-toggle-sidebar)

;; Flycheck: On the fly syntax checking
(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)
; stronger error display
(defface flycheck-error
  '((t (:foreground "red" :underline (:color "Red1" :style wave) :weight bold)))
  "Flycheck face for errors"
  :group "flycheck")
(setq flycheck-check-syntax-automatically '(mode-enabled new-line))

(use-package all-the-icons)
;;flycheck
;;(require 'flyspell)

;;ispell
;; for hunspell on windows: http://www.nextpoint.se/?p=656
(setq ispell-program-name "hunspell")
(require 'ispell)
(require 'flyspell)

;; (require 'micgoline)
;; (setq powerline-default-separator 'arrow-fade)
;; (use-package spaceline-all-the-icons 
;;   :after spaceline
;;   :config (spaceline-all-the-icons-theme))
;;(rich-minority-mode 1)

(diminish 'visual-line-mode)
(diminish 'ivy-mode)
(diminish 'projectile-mode "P")

;; (use-package eyeliner :ensure nil
;;   :straight (eyeliner :type git
;;                       :host github
;;                       :repo "dustinlacewell/eyeliner")
;;   :config
;;   (require 'eyeliner)
;;   (setq eyeliner/left-hand-segments
;;         '(("%l:%c ")
;; 	  (eyeliner/buffer-name :skip-alternate t)
;;           (eyeliner/mode-icon)
;; 	  (eyeliner/buffer-modified)
;;           (eyeliner/branch-icon :skip-alternate t :tight-right t)
;;           (eyeliner/branch-name)
;;           (eyeliner/project-name :skip-alternate t))
;; 	eyeliner/right-hand-segments
;; 	'((" %q "))
;; 	eyeliner/cool-color "medium blue")
;;   (eyeliner/install))

(use-package doom-modeline
  :ensure t
  ;;:hook (after-init . doom-modeline-mode)
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-icon (display-graphic-p)
	doom-modeline-minor-modes (featurep 'minions)))

(require 'dired+)
(diredp-toggle-find-file-reuse-dir 1)
;; (add-hook 'dired-mode-hook 'all-the-icons-dired-mode)
(add-hook 'dired-mode-hook (lambda () (dired-omit-mode)))
(require 'dired-sort)

(defhydra hydra-dired (:hint nil :color pink)
  "
_+_ mkdir          _v_iew           _m_ark             _(_ details        _i_nsert-subdir    wdired
_C_opy             _O_ view other   _U_nmark all       _)_ omit-mode      _$_ hide-subdir    C-x C-q : edit
_D_elete           _o_pen other     _u_nmark           _l_ redisplay      _w_ kill-subdir    C-c C-c : commit
_R_ename           _M_ chmod        _t_oggle           _g_ revert buf     _e_ ediff          C-c ESC : abort
_Y_ rel symlink    _G_ chgrp        _E_xtension mark   _s_ort             _=_ pdiff
_S_ymlink          ^ ^              _F_ind marked      _._ toggle hydra   \\ flyspell
_r_sync            ^ ^              ^ ^                ^ ^                _?_ summary
_z_ compress-file  _A_ find regexp
_Z_ compress       _Q_ repl regexp

T - tag prefix
"
  ("\\" dired-do-ispell)
  ("(" dired-hide-details-mode)
  (")" dired-omit-mode)
  ("+" dired-create-directory)
  ("=" diredp-ediff)         ;; smart diff
  ("?" dired-summary)
  ("$" diredp-hide-subdir-nomove)
  ("A" dired-do-find-regexp)
  ("C" dired-do-copy)        ;; Copy all marked files
  ("D" dired-do-delete)
  ("E" dired-mark-extension)
  ("e" dired-ediff-files)
  ("F" dired-do-find-marked-files)
  ("G" dired-do-chgrp)
  ("g" revert-buffer)        ;; read all directories again (refresh)
  ("i" dired-maybe-insert-subdir)
  ("l" dired-do-redisplay)   ;; relist the marked or singel directory
  ("M" dired-do-chmod)
  ("m" dired-mark)
  ("O" dired-display-file)
  ("o" dired-find-file-other-window)
  ("Q" dired-do-find-regexp-and-replace)
  ("R" dired-do-rename)
  ("r" dired-do-rsynch)
  ("S" dired-do-symlink)
  ("s" dired-sort-toggle-or-edit)
  ("t" dired-toggle-marks)
  ("U" dired-unmark-all-marks)
  ("u" dired-unmark)
  ("v" dired-view-file)      ;; q to exit, s to search, = gets line #
  ("w" dired-kill-subdir)
  ("Y" dired-do-relsymlink)
  ("z" diredp-compress-this-file)
  ("Z" dired-do-compress)
  ("q" nil)
  ("." nil :color blue))

(defun my-dired-init ()
  "Bunch of stuff to run for dired, either immediately or when it's
   loaded."
  ;; <add other stuff here>
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse)
  (define-key dired-mode-map "." 'hydra-dired/body)
  (define-key dired-mode-map "^"
    (function
     (lambda nil (interactive) (dired-single-buffer "..")))))

;; if dired's already loaded, then the keymap will be bound
(if (boundp 'dired-mode-map)
    ;; we're good to go; just add our bindings
    (my-dired-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'my-dired-init))

;; ;;org mode*******************************************************
;; ;;rest in ~/.emacs.d/CustomLoadFiles/orgZ.el
(require 'orgZ)

;; ;;enabling company***********************************************
(add-hook 'after-init-hook 'global-company-mode)
;; ;; ;;makes completion start automatically rather than waiting for 3 chars / 0.5sec
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0.0)
;; ;; ;;company quickhelp gives docstring info
(company-quickhelp-mode 1)
(setq company-quickhelp-delay nil)

;; ;;yasnippet setup************************************************
(require 'yasnippet)
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"                 ;; personal snippets
        ))
(yas-global-mode 1)

;;slime and cl setup*********************************************
(require 'slim-mode)
;;(load (expand-file-name "/home/amsha/quicklisp/slime-helper.el"))
(setq package-enable-at-startup nil)
;;(setq inferior-lisp-program "F:/Binaries/ccl/wx86cl64.exe")
(setq inferior-lisp-program "sbcl")
(setq slime-auto-connect 'ask)
(setq slime-net-coding-system 'utf-8-unix)
(require  'slime)
(slime-setup
 '(slime-fancy slime-asdf slime-references slime-indentation slime-xref-browser slime-company))
(unless package-archive-contents 
  (package-refresh-contents))
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

;;python setup*************************************************
 ;(eval-after-load "company"
 ;  '(add-to-list 'company-backends 'company-anaconda)); :with company-capf)))
 ;(add-hook 'python-mode-hook 'anaconda-mode)
 ;(add-hook 'python-mode-hook 'anaconda-eldoc-mode)
;(add-hook 'python-mode-hook '(company-anaconda 'interactive))
;;(add-to-list 'company-backends 'company-jedi)
;; (use-package elpy
;;   :ensure t
;;   :init
;;   (elpy-enable))
					;(setenv "IPY_TEST_SIMPLE_PROMPT" "1")
(setq python-shell-interpreter "python" python-shell-interpreter-args "-i")
(pyvenv-activate "~/virtualenv/pytorch")
(pyvenv-mode)

(use-package poetry
  :init
  (poetry-tracking-mode))

;; from https://emacs.stackexchange.com/questions/32140/python-mode-indentation
(defun how-many-region (begin end regexp &optional interactive)
  "Print number of non-trivial matches for REGEXP in region.
   Non-interactive arguments are Begin End Regexp"
  (interactive "r\nsHow many matches for (regexp): \np")
  (let ((count 0) opoint)
    (save-excursion
      (setq end (or end (point-max)))
      (goto-char (or begin (point)))
      (while (and (< (setq opoint (point)) end)
                  (re-search-forward regexp end t))
        (if (= opoint (point))
            (forward-char 1)
          (setq count (1+ count))))
      (if interactive (message "%d occurrences" count))
      count)))

(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many-region (point-min) (point-max) "^  "))
        (tab-count (how-many-region (point-min) (point-max) "^\t")))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
(add-hook 'python-mode-hook 'linum-mode)
(add-hook 'python-mode-hook
    (lambda ()
        (setq indent-tabs-mode nil)
        (infer-indentation-style)))
;; (highlight-indentation-mode t)
;; (highlight-indentation-current-column t)
;; (use-package diminish)
;; (diminish 'highlight-indentation-mode)
;; (diminish 'highlight-indentation-current-column-mode)
;; (diminish 'elpy)
;; (diminish 'hs-minor-mode)
;; (diminish 'Projectile "Projectile")

;;prolog*******************************************************
;; (setq auto-mode-alist
;;   (cons (cons "\\.pl" 'prolog-mode)
;;      auto-mode-alist))

;; c/c++ setup*************************************************
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)

(semantic-mode 1)

(add-to-list 'company-backends 'company-c-headers)
; (semantic-add-system-include "/usr/lib/gcc/x86_64-pc-linux-gnu/6.4.1/" 'c++-mode)
					;(add-to-list 'company-c-headers-path-system "/usr/lib/gcc/x86_64-pc-linux-gnu/6.3.1")
(defun my-c-mode-common-hook ()
 ;; my customizations for all of c-mode, c++-mode, objc-mode, java-mode
 (c-set-offset 'substatement-open 0)
 ;; other customizations can go here

 (setq c++-tab-always-indent t)
 (setq c-basic-offset 4)                  ;; Default is 2
 (setq c-indent-level 4)                  ;; Default is 2

 (setq tab-stop-list '(4 8 12 16 20 24 28 32 36 40 44 48 52 56 60))
 ; (setq tab-width 4)
 (setq indent-tabs-mode t)  ; use spaces only if nil
 )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
;; (use-package ccls
;;   :ensure t
;;   :config
;;   (setq ccls-executable "ccls")
;;   (setq lsp-prefer-flymake nil)
;;   (setq-default flycheck-disabled-checkers '(c/c++-clang c/c++-cppcheck c/c++-gcc))
;;   :hook ((c-mode c++-mode objc-mode) .
;; 	 (lambda ()
;; 	   (require 'ccls)
;; 	   (lsp)
;; 	   (linum-mode))))


;;visual editing**********************************************************************************************************
;;set transparency********************************************
;;(set-frame-parameter (selected-frame) 'alpha '(<active> . <inactive>))
 ;;(set-frame-parameter (selected-frame) 'alpha <both>)
(set-frame-parameter (selected-frame) 'alpha '(95 . 85))
(add-to-list 'default-frame-alist '(alpha . (95 . 85)))


;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(mode-line ((t (:background "#004276" :foreground "#8cccff" :box nil :height 0.9))))
;;  '(mode-line-inactive ((t (:background "#666666" :foreground "#f9f9f9" :box nil :height 0.9))))
;;  '(sml/global ((t (:foreground "gray50" :inverse-video nil :height 0.9 :width normal)))))

;;treemacs setup**********************************************************************************************************
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (progn
    (setq treemacs-collapse-dirs                 (if treemacs-python-executable 3 0)
          treemacs-deferred-git-apply-delay      0.5
          treemacs-directory-name-transformer    #'identity
          treemacs-display-in-side-window        t
          treemacs-eldoc-display                 t
          treemacs-file-event-delay              5000
          treemacs-file-extension-regex          treemacs-last-period-regex-value
          treemacs-file-follow-delay             0.2
          treemacs-file-name-transformer         #'identity
          treemacs-follow-after-init             t
          treemacs-git-command-pipe              ""
          treemacs-goto-tag-strategy             'refetch-index
          treemacs-indentation                   2
          treemacs-indentation-string            " "
          treemacs-is-never-other-window         nil
          treemacs-max-git-entries               5000
          treemacs-missing-project-action        'ask
          treemacs-move-forward-on-expand        nil
          treemacs-no-png-images                 nil
          treemacs-no-delete-other-windows       t
          treemacs-project-follow-cleanup        nil
          treemacs-persist-file                  (expand-file-name ".cache/treemacs-persist" user-emacs-directory)
          treemacs-position                      'left
          treemacs-recenter-distance             0.1
          treemacs-recenter-after-file-follow    nil
          treemacs-recenter-after-tag-follow     nil
          treemacs-recenter-after-project-jump   'always
          treemacs-recenter-after-project-expand 'on-distance
          treemacs-show-cursor                   nil
          treemacs-show-hidden-files             t
          treemacs-silent-filewatch              nil
          treemacs-silent-refresh                nil
          treemacs-sorting                       'alphabetic-asc
          treemacs-space-between-root-nodes      t
          treemacs-tag-follow-cleanup            t
          treemacs-tag-follow-delay              1.5
          treemacs-user-mode-line-format         nil
          treemacs-width                         35)

    ;; The default width and height of the icons is 22 pixels. If you are
    ;; using a Hi-DPI display, uncomment this to double the icon size.
    ;;(treemacs-resize-icons 44)

    (treemacs-follow-mode t)
    (treemacs-filewatch-mode t)
    (treemacs-fringe-indicator-mode t)
    (pcase (cons (not (null (executable-find "git")))
                 (not (null treemacs-python-executable)))
      (`(t . t)
       (treemacs-git-mode 'deferred))
      (`(t . _)
       (treemacs-git-mode 'simple))))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after treemacs projectile
  :ensure t)

(use-package treemacs-icons-dired
  :after treemacs dired
  :ensure t
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit
  :ensure t)

(use-package treemacs-persp
  :after treemacs persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(setq persp-keymap-prefix (kbd "C-x p"))

;;latex setup***********************************************************************************
(defun turn-on-outline-minor-mode ()
  "."
  (outline-minor-mode 1))

(use-package auctex
  :requires (preview company-auctex)
  :init 
  (setq TeX-auto-save t
	TeX-parse-self t
	TeX-save-query nil
	TeX-PDF-mode t
	reftex-plug-into-AUCTeX t
	TeX-PDF-from-DVI "Dvips")
  (TeX-global-PDF-mode t)
  (setq-default TeX-master nil)
  :config
  (company-auctex-init)
  (setq outline-minor-mode-prefix "\C-c \C-o")
  :hook ((LaTeX-mode-hook . turn-on-outline-minor-mode)
	 (latex-mode-hook . turn-on-outline-minor-mode)
	 (LaTeX-mode-hook . flyspell-mode)
	 (latex-mode-hook . flyspell-mode)
	 (LaTeX-mode-hook . turn-on-reftex)))

;; (defun activate-preview-mode ()
;;   (load "preview-latex.el" nil t t))

;; (add-hook 'LaTeX-mode-hook 'turn-on-outline-minor-mode)
;; (add-hook 'latex-mode-hook 'turn-on-outline-minor-mode)
;; ;; (add-hook 'LaTeX-mode-hook 'activate-preview-mode)
;; ;; (add-hook 'laTeX-mode-hook 'activate-preview-mode)
;; (add-hook 'LaTeX-mode-hook 'flyspell-mode)
;; (add-hook 'latex-mode-hook 'flyspell-mode)
;; (setq outline-minor-mode-prefix "\C-c \C-o")


;;magit******************************************************************
(global-set-key (kbd "C-x g") 'magit-status)


;;projectile mode********************************************************
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

;;ibuffer****************************************************************
(global-set-key (kbd "C-x C-b") 'ibuffer)

;;origami*****************************************************************************
(use-package origami
  :bind ("C-+" . hydra-origami/body)
  :hook ((prog-mode . origami-mode))
  :hydra (hydra-origami (:color red)
   "
  [_o_] Open node    [_n_] Next fold       [_f_] toggle forward  [_s_] Show current only
  [_c_] Close node   [_p_] Previous fold   [_a_] toggle all      [_q_] quit
  "
   ("o" origami-open-node)
   ("c" origami-close-node)
   ("n" origami-next-fold)
   ("p" origami-previous-fold)
   ("f" origami-forward-toggle-node)
   ("a" origami-toggle-all-nodes)
   ("s" origami-show-only-node)
   ("q" nil)))

;; ;;hide/show
;; (defun toggle-selective-display (column)
;;   (interactive "P")
;;   (set-selective-display
;;    (or column
;;        (unless selective-display
;; 	 (1+ (current-column))))))

;; (defun toggle-hiding (column)
;;   (interactive "P")
;;   (if hs-minor-mode
;;       (if (condition-case nil
;; 	      (hs-toggle-hiding)
;; 	    (error t))
;; 	  (hs-show-all))
;;     (toggle-selective-display column)))

;; (load-library "hideshow")
;; (global-set-key (kbd "C-+") 'toggle-hiding)
;; (global-set-key (kbd "C-\\") 'toggle-selective-display)

;; (defun add-hs-hook (mode-list)
;;   "MODE-LIST:  list of modes that needs 'hs-minor-mode' hook."
;;   (dolist (mode mode-list)
;;     (add-hook mode 'hs-minor-mode)))

;; (add-hs-hook (list 'python-mode-hook 'lisp-mode-hook))

;;other stuff************************************************************
(defun copy-current-file-name ()
  "Copy the current buffers filename to the kill ring."
  (interactive)
  (kill-new (file-name-nondirectory (buffer-file-name (window-buffer (minibuffer-selected-window))))))

(defun copy-current-file-full-path ()
  "Copy the current buffers filename to the kill ring."
  (interactive)
  (kill-new (buffer-file-name (window-buffer (minibuffer-selected-window)))))

(defun single-linify (beg end)
  "Make a paragraph single-lined by replacing line break with space.
  BEG The begining of a region
  END The end of a region"
  (interactive (if (use-region-p)
                   (list (region-beginning) (region-end))
                 (list nil nil)))
  (let ((insertion (replace-regexp-in-string "\n" " " (buffer-substring beg end))))
    (when (and beg end)
      (delete-region beg end)
      (insert insertion))))

(use-package slack
  :commands (slack-start)
  :init
  (setq slack-buffer-emojify t) ;; if you want to enable emoji, default nil
  (setq slack-prefer-current-team t)
  :config
  (slack-register-team
   :name "team-name" ; add team name here
   :default t
   :client-id (gethash 'slack-client-id configurations "123231423499.234123421342")
   :client-secret (gethash 'slack-client-secret configurations "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")
   :token (gethash 'slack-token configurations
		   "xoxp-111111111111-222222222222-333333333333-44444444444444444444444444444444")
   :subscribed-channels '() ;add chanel list here
   :full-and-display-names t))


;;alert mode************************************************************
(use-package alert
  :commands (alert)
  :init
  (setq alert-default-style 'notifier))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

;; (require 'web-mode)
;; (add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
;; (add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))

(defun switch-web-js2 ()
  "Swicth between web mode and js2 mode."
  (interactive)
  (cond
   ((equal major-mode 'web-mode)
    (js2-mode))
   ((equal major-mode 'js2-mode)
    (web-mode))
   (t (error "Only when in web-mode or js2-mode"))))

(use-package web-mode 
  :mode "\\.phtml\\'"
  :mode	"\\.tpl\\.php\\'"
  :mode	"\\.php\\'"
  :mode	"\\.[agj]sp\\'"
  :mode	"\\.as[cp]x\\'"
  :mode	"\\.erb\\'"
  :mode "\\.html?\\'"
  :bind ("C-c s" . switch-web-js2))

(use-package web-narrow-mode
  :hook 'web-mode)

(use-package js2-mode
  :mode "\\.js\\'"
  :bind ("C-c s" . switch-web-js2))
    
(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package plantuml-mode
  :init
  (add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
  :config
  (setq plantuml-jar-path "~/.emacs.d/customFiles/plantuml.jar")
  (setq org-plantuml-jar-path "~/.emacs.d/customFiles/plantuml.jar"))
  ;; (setq plantuml-exec-mode "jar")
  ;; (plantuml-set-exec-mode "jar"))

;; csharp #####################################################################
(defun my-csharp-mode-hook ()
  ;; enable the stuff you want for C# here
  (company-mode)
  (flycheck-mode)
  
  (setq indent-tabs-mode nil)
  (setq c-syntactic-indentation t)
  (c-set-style "ellemtel")
  (setq c-basic-offset 4)
  (setq truncate-lines t)
  ; (setq tab-width 4)
  (setq evil-shift-width 4)

  (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
  (local-set-key (kbd "C-c C-c") 'recompile))

(use-package csharp-mode
  ;:requires omnisharp
  :ensure t
  :hook (csharp-mode . my-csharp-mode-hook))

;; (add-hook 'csharp-mode-hook 'my-csharp-mode-hook t)
;; (add-hook 'csharp-mode-hook #'flycheck-mode)

;;Docker
(use-package docker
  :ensure t
  :bind ("C-c d" . docker))

;;arxiv mode
(require 'arxiv-mode)


(defun amsha/downlad-raname-move-file (url newname dir)
  (url-copy-file url (expand-file-name newname dir)))

(defun amsha/get-uml-link (link)
  (interactive "slink: ")
  (let ((split-link (s-split "/" link))
	(formated-link '()))
    (dolist (el split-link)
      (if (or (s-matches-p ".*\.com" el)
		(s-matches-p ".*\.org" el))
	  (push (s-concat (s-replace "." "-" el) ".uml.idm.oclc.org") formated-link)
	(push el formated-link)))
    (kill-new (s-join "/" (reverse formated-link)))))

;; company-tabnin********************************************************

(use-package company-tabnine
  :config
  (when (gethash 'use-tabnine configurations t)
    (push 'company-tabnine company-backends)))


;; emacs discrod plugin
(use-package elcord :ensure nil  ;; installed using git, thus!
  :config
  (setq elcord-display-buffer-details nil)
  (elcord-mode))
;; (setq elcord-client-id (gethash 'elcord-client-id configurations))


;; processing-mode*******************************************************
(use-package processing-mode
  :config
  (setq processing-location "~/packages_external/processing"
        processing-sketchbook-dir "~/Documents/Processing/sketchbook"))

;;code to run at the end!************************************************

(defun company-mode/backend-with-yas (backend)
"Adding yasnippet after company-mode.
BACKEND: the backend"
  (if (and (listp backend) (member 'company-yasnippet backend))
      backend
    (append (if (consp backend) backend (list backend))
            '(:with company-yasnippet))))

(setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))

;;yasnippets company conflict resolution
;(provide .emacs)
;;; .emacs ends here
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(defun yank-pop-forwards (arg)
  "Ha ha ha. 
ARG : the arg"
  (interactive "p")
  (yank-pop (- arg)))
(global-set-key "\M-Y" 'yank-pop-forwards) ; M-Y (Meta-Shift-Y)

(setq font-latex-user-keyword-classes '(("positive-comment"
                                         (("p" "{"))
                                         (:foreground "aquamarine")
                                         command)
                                        ("negative-comment"
                                         (("n" "{"))
                                         (:foreground "IndianRed")
                                         command)
                                        ("autoref" (("autoref" "{")) 'font-lock-constant-face command)
                                        ("red" (("red" "{")) (:background "red") command)
                                        ("mg-comment" (("mg" "{")) (:background "blue") command)
                                        ("shf-comment" (("shf" "{")) (:background "DarkGreen") command) 
                                        ("kf-comment" (("kf" "{")) (:background "Sienna") command)  
                                        ("dh-comment" (("dh" "{")) (:background "Firebrick") command)
                                        ("pp-comment" (("pp" "{")) (:background "DarkSlateBlue") command)))

