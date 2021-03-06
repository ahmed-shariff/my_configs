;;; orgZ.el --- a simple package                     -*- lexical-binding: t; -*-

;; Copyright (C) 2014  Nic Ferrier

;; Author: Nic Ferrier <nferrier@ferrier.me.uk>
;; Keywords: lisp
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;my custom org setup
;;; Code:
(require 'org)
(require 'org-capture)
;; (require 'org-capture-pop-frame)
;(ido-mode)

(use-package org-capture-pop-frame
  :straight (org-capture-pop-frame :type git :host github :repo "tumashu/org-capture-pop-frame"
                                   :fork (:host github :repo "ahmed-shariff/org-capture-pop-frame")))

(setq org-ellipsis " ▾"
      org-hide-emphasis-markers t
      org-src-fontify-natively t
      org-src-tab-acts-natively t
      org-startup-folded 'content)

(setq org-todo-keywords '((sequence "TODO(t)" "INPROGRESS(p!/@)" "WAIT(w@/!)" "IDEA(i)" "|" "DONE(d!)" "CANCELED(c@)" "LATER(l@)")
			  (sequence "ROUNTINE(R)" "|" "ROUNTINE_COMPLETE(r@)" )))

;;(set-register ("~/Documents/org/uniwork.org"
;;			     "~/Documents/org/uni_research.org")

(setq org-agenda-custom-commands
      '(("c" . "My custom queries")
	("ci" tags-todo "LEVEL=1&+exp/!INPROGRESS"
	 ((org-agenda-files `("~/Research/FoodClassification/experiment_log.org"))
	  (org-agenda-filter-by-top-headline)))
	("ct" tags-todo "LEVEL=1&+exp/!TODO|WAIT"
	 ((org-agenda-files `("~/Research/FoodClassification/experiment_log.org"))
	  (org-agenda-filter-by-top-headline)))
	("ca" tags-todo "LEVEL=1&+exp"
	 ((org-agenda-files `("~/Research/FoodClassification/experiment_log.org"))
	  (org-agenda-filter-by-top-headline)))
	("cd" tags-todo "LEVEL=1&+exp/!DONE"
	 ((org-agenda-files `("~/Research/FoodClassification/experiment_log.org"))
	  (org-agenda-filter-by-top-headline)))))

(add-to-list
 'org-src-lang-modes '("plantuml" . plantuml))
(setq org-src-tab-acts-natively t)

(append org-babel-load-languages '((ruby . t)
				   (plantuml . t)
				   (emacs-lisp . t)
				   (python . t)
				   (shell .t)))

(when (gethash 'use-jupyter configurations t)
  (setq org-babel-default-header-args:jupyter-python '((:async . "yes")
						       (:session . "py")
						       (:kernel . "python3")
						       (:tangle . "yes")
						       (:exports . "both")))
  (use-package ox-ipynb
    :straight (ox-ipynb :type git :host github :repo "jkitchin/ox-ipynb"))
  (append org-babel-load-languages '((jupyter . t))))

(org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages)
;; (defun my-org-confirm-babel-evaluate (lang bdy)
;;   "Function to eval plantuml blocks.
;; LANG
;; BDY"
;;   (not (string= lang "plantuml")))
(setq org-confirm-babel-evaluate nil);;'my-org-confirm-babel-evaluate)
(setq org-latex-image-default-width "")
(setq org-startup-with-inline-images t)

(setq org-tag-persistent-alist '(("@work" . ?w) ("@home" . ?h) ("@mobile" . ?m)))

(setq org-default-notes-file "~/Documents/org/notes.org")

(setq org-refile-targets '((org-agenda-files :maxlevel . 6)))
			   ;(org-c-refile-targets :maxlevel . 6)))

(defun org-ask-title-location (&optional prompt)
  "From  https://stackoverflow.com/questions/9005843/interactively-enter-headline-under-which-to-place-an-entry-using-capture."
  (let* ((prompt (or prompt "Project "))
	 (org-refile-targets '((nil :maxlevel . 1)))
         (hd (condition-case nil
                 (car (let ((in (org-refile-get-location prompt nil t)))
			(message "%s" in)
			in))
               (error (car org-refile-history)))))
    (goto-char (point-min))
    (re-search-forward
         (format org-complex-heading-regexp-format (regexp-quote hd))
         nil t)
        (goto-char (point-at-bol))))

;;  ***************************************************************

(defun org-ask-id (file prompt property)
  "."
  (save-window-excursion
    (find-file file)
    (org-ask-title-location prompt)
    (org-entry-get (point) property)))

(defun org-ask-experiment-id ()
  "."
  (save-window-excursion
    (find-file "~/Documents/org/brain/work/experiments_log.org")
    (org-ask-title-location  "Experiment ")
    (org-entry-get (point) "CUSTOM_ID"))
  ;;(org-ask-id "~/Documents/org/brain/work/experiments_log.org"  "Experiment " "CUSTOM_ID"))
)

(defun org-ask-project-id ()
  "."
  (org-ask-id "~/Documents/org/brain/work/projects.org"  "Project " "CUSTOM_ID"))


(defun org-ask-task-board ()
  "."
  (let* ((project-boards (mapcar (lambda (file) (cons (file-name-base file) file))(directory-files "~/Documents/org/brain/work/project_boards" t ".*\\.org")))
         (board-file (cdr (assoc (ivy-read "Select poject board" project-boards) project-boards))))
    (find-file board-file)
    (goto-char (point-max))))

(defun board-task-location ()
  (let* ((project-boards (directory-files "~/Documents/org/brain/work/project_boards" t ".*\\.org$"))
         (targets
          (org-ql-select project-boards `(and (todo "INPROGRESS") (level 1))
            :action (lambda ()
                      (let* ((headline-plist (cadr (org-element-headline-parser (point))))
                             (title (car (plist-get headline-plist :title)))
                             (file-name (file-name-base (buffer-file-name))))
                        (list (format "%s::%s" file-name title)
                              (org-id-get-create)
                              file-name
                              title)))))
         (target (progn
                   (assoc (ivy-read "Select task: " targets) targets))))
    (format "* [[id:%s][%s]]  %%?
     :PROPERTIES:
     :ID:       %s
     :BRAIN_PARENTS: %s
     :END:"
            (nth 1 target)
            (nth 2 target)
            (org-id-new)
            (nth 1 target))))
     
          
;; (defun org-ask-location ()
;;   org-project-sprint-target-heading) 

(setq org-capture-templates
      '(("i" "hmmmm....somthing!*light bulb*->TO THE NOTES"
	 entry (file+olp+datetree "~/Documents/org/notes.org")
	 "* NOTE %^g\n\tAdded: %U\n\t%?")
	("t" "A thing i have to do(a wonderfull epiphany? 3:))->TO THE NOTES"
	 entry (file "~/Documents/org/notes.org")
	 "* TODO %^{Description} %^g\n\tAdded: %U\n\t%?")
	("j" "Journal entry")
	("jg" "Journal entry general"
	 entry (file+olp+datetree "~/Documents/org/journal.org")
	 "* %?")
	("jw" "Journal entry work"
	 entry (file+olp+datetree "~/Documents/org/brain/work/notes.org")
	 "* %?")
	("js" "Journal entry work-scrum"
	 entry (file+olp+datetree "~/Documents/org/brain/work/scrum.org")
	 "* Y:\n1. %?\n* T:\n1. "
	 :jump-to-captured t)
	("jt" "Journal sub entry"
	 entry (file+olp+datetree "~/Documents/org/brain/work/notes.org")
	 "1. %?")
	("e" "Experiment setup information")
	("ej" "Add Journal entry")
        ("ejt" "for task"
	 entry (file+olp+datetree "~/Documents/org/brain/work/notes.org")
	 "%(board-task-location)")
	("eje" "for experiment"
	 entry (file+olp+datetree "~/Documents/org/brain/work/notes.org")
         "* [[file:experiments_log.org::#%^{EXP_ID}][%\\1]] %? :e%\\1:")
        ("el" "Add experiment"
	 entry (file "~/Documents/org/brain/work/experiments_log.org")
	 "\n\n* TODO <<%^{ID}>> %^{Experiment} [%] :@work:exp_%^{Project_id}:\n  :PROPERTIES:
  :CUSTOM_ID:       %\\1
  :PROJECT: [[file:projects.org::#%\\3][%\\3]]
  :PROJECT_ID: %\\3
  :SPRINT: %^{Sprint ID}
  :END:\n- %^{Description}\n\n** Notes\n\n** TODO %?\n** TODO Conclusions"
	 :jump-to-captured t)
	("es" "Add sprint"
	 entry (file+function "~/Documents/org/brain/work/projects.org" org-ask-title-location)
	 "** TODO Sprint %^{ID}: %^{TITLE}
   :PROPERTIES:
   :EXPORT_TOC: nil
   :EXPORT_TITLE: %\\2
   :EXPORT_OPTIONS: H:2
   :EXPORT_AUTHOR:
   :START_DATE: %u
   :END_DATE:
   :ID:       %(org-id-new)
   :END:
*** From previous:
    - %?
*** Sprint goal:
*** Related experiments:
*** Remarks:
" :jump-to-captured t)
	("ep" "Add project"
	 entry (file "~/Documents/org/brain/work/projects.org")
	 "* TODO <<%^{ID}>> %^{TITLE}
  :PROPERTIES:
  :CUSTOM_ID: %\\1
  :ID:       %(org-id-new)
  :END:
** %\\2 literature
   :PROPERTIES:
   :ID:       %(org-id-new)
   :END:
%?
"
	 :jump-to-captured t)
        ("et" "Add task"
	 entry (function org-ask-task-board)
	 "* TODO %^{TITLE}
  :PROPERTIES:
  :ID:       %(org-id-new)
  :END:
%?
"
	 :jump-to-captured t)
	("b" "Org brain")
	("bp" "Add research paper"
	 entry (function (lambda () (org-brain-goto "research_papers")));(file "~/Documents/org/brain/research_papers.org")
	 "* (%^{YEAR}) %^{TITLE}\n  :PROPERTIES:\n  :LINK: %^{LINK\}n  :ID:  %(org-id-new)\n  :YEAR: %\\1 \n  :END:
  \n  - %^{LINK}"
	 :jump-to-captured t)))

(defun org-summary-todo (n-done n-not-done)
  "Switch entry to DONE when all subentries are done, to TODO otherwise."
  (let (org-log-done org-log-states)   ; turn off logging
    (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

;; ;; from https://stackoverflow.com/questions/13967876/how-to-restrict-a-function-to-a-subtree-in-emacs-org-mode
;; (defun my-ido-find-org-attach ()
;;   "Find files in org-attachment directory"
;;   (interactive)
;;   (let* ((enable-recursive-minibuffers t)
;;          (files (find-lisp-find-files org-attach-directory "."))
;;          (file-assoc-list
;;           (mapcar (lambda (x)
;;                     (cons (file-name-nondirectory x)
;;                           x))
;;                   files))
;;          (filename-list
;;           (remove-duplicates (mapcar #'car file-assoc-list)
;;                              :test #'string=))
;;          (filename (ido-completing-read "Org attachments: " filename-list nil t))
;;          (longname (cdr (assoc filename file-assoc-list))))
;;     (ido-set-current-directory
;;      (if (file-directory-p longname)
;;          longname
;;        (file-name-directory longname)))
;;     (setq ido-exit 'refresh
;;           ido-text-init ido-text
;;           ido-rotate-temp t)
;;     (exit-minibuffer)))

; taken from https://emacs.stackexchange.com/questions/48533/calling-a-fuction-after-org-capturing
;; (defun amsha/org-capture-finalize ()
;;   (let ((key  (plist-get org-capture-plist :key))
;;         (desc (plist-get org-capture-plist :description)))
;;     (unless org-note-abort
;;       (message "Template with key %s and description “%s” run successfully" org-capture-plist desc))))

;; (add-hook 'org-capture-mode-hook 'amsha/org-capture-finalize)

(require 'org-bullets)

(use-package org-ref
  ; :requires (doi-utils org-ref-pdf org-ref-url-utils org-ref-bibtex org-ref-latex org-ref-arxiv)
  :config
  (setq reftex-default-bibliography '("~/Documents/org/bibliography/references.bib")
	org-ref-bibliography-notes "~/Documents/org/brain/research_papers.org"
	org-ref-default-bibliography '("~/Documents/org/bibliography/references.bib")
	org-ref-pdf-directory "~/Documents/org/bibliography/pdfs/"
	bibtex-completion-bibliography "~/Documents/org/bibliography/references.bib"
	bibtex-completion-library-path "~/Documents/org/bibliography/pdfs/"
	bibtex-completion-notes-path "~/Documents/org/brain/research_papers.org"
	org-latex-pdf-process (list "latexmk -shell-escape -bibtex -f -pdf %f")
	org-ref-completion-library "org-ref-ivy"
	bibtex-completion-notes-template-one-file
	(format
	 "\n* (${year}) ${title} [${author}]\n  :PROPERTIES:\n  :Custom_ID: ${=key=}\n  :Keywords: ${keywords}\n  :LINK: ${pdf}\n  :YEAR: ${year}\n  :END:\n\n  - cite:${=key=}")
	doi-utils-open-pdf-after-download nil
	org-ref-note-title-format "* (%y) %t [%9a] \n  :PROPERTIES:\n  :Custom_ID: %k\n  :AUTHOR: %9a\n  :JOURNAL: %j\n  :YEAR: %y\n  :VOLUME: %v\n  :PAGES: %p\n  :DOI: %D\n  :URL: %U\n  :END:\n\n  - ")
  (defun my/org-ref-notes-function (candidates)
    (let ((key (helm-marked-candidates)))
      (funcall org-ref-notes-function (car key))))
  (helm-delete-action-from-source "Edit notes" helm-source-bibtex)
  (helm-add-action-to-source "Edit notes" 'my/org-ref-notes-function helm-source-bibtex 7))

(use-package org-noter ;;:quelpa (org-noter :fetcher github :repo "ahmed-shariff/org-noter")
  :straight (org-noter :type git :host github :repo "weirdNox/org-noter"
                       :fork (:host github :repo "ahmed-shariff/org-noter"))
  :config
  (setq org-noter-property-doc-file "INTERLEAVE_PDF"
        org-noter-property-note-location "INTERLEAVE_PAGE_NOTE"))

(use-package org-brain ;;:quelpa (org-brain :fetcher github :repo "ahmed-shariff/org-brain" :branch "fix322/symlink_fix")
  :init
  (setq org-brain-path "~/Documents/org/brain")
  :bind (("C-c v" . org-brain-visualize)
	 :map org-brain-visualize-mode-map
	 ("\C-coo" . org-brain-open-org-noter)
	 ("\C-cop" . org-brain-add-parent-topic)
         ("\C-cob" . org-brain-goto-button-at-pt)
         ("\C-cos". org-brain-print-topics))
  :config
  ;(define-key org-brain-visualize-mode-map "")
  (setq org-id-track-globally t
        org-id-locations-file "~/.emacs.d/.org-id-locations"
        org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
  (push '("b" "Brain" plain (function org-brain-goto-end)
          "* %i%?" :empty-lines 1)
        org-capture-templates)
  (setq org-brain-visualize-default-choices 'all)
  (setq org-brain-title-max-length 50)
  (setq org-brain-vis-title-prepend-functions (list
                                               (org-brain-function-on-entry 'org-brain-entry-todo-state-colored)
                                               (org-brain-function-on-entry 'org-brain-entry-priority)))
  (defun org-brain-insert-resource-icon (link)
    "Insert an icon, based on content of org-mode LINK."
    (insert (format "%s "
                    (cond ((string-prefix-p "http" link)
                           (cond ((string-match "wikipedia\\.org" link)
                                  (all-the-icons-faicon "wikipedia-w"))
				 ((string-match "github\\.com" link)
                                  (all-the-icons-octicon "mark-github"))
				 ((string-match "vimeo\\.com" link)
                                  (all-the-icons-faicon "vimeo"))
				 ((string-match "youtube\\.com" link)
                                  (all-the-icons-faicon "youtube"))
				 (t
                                  (all-the-icons-faicon "globe"))))
                          ((string-prefix-p "brain:" link)
                           (all-the-icons-fileicon "brain"))
                          (t
                           (all-the-icons-icon-for-file link))))))
  (add-hook 'org-brain-after-resource-button-functions #'org-brain-insert-resource-icon)
  (defface aa2u-face '((t . nil))
    "Face for aa2u box drawing characters")
  (advice-add #'aa2u-1c :filter-return
              (lambda (str) (propertize str 'face 'aa2u-face)))
  (defun aa2u-org-brain-buffer ()
    (let ((inhibit-read-only t))
      (make-local-variable 'face-remapping-alist)
      (add-to-list 'face-remapping-alist
                   '(aa2u-face . org-brain-wires))
      (ignore-errors (aa2u (point-min) (point-max)))))  
  (with-eval-after-load 'org-brain
    (add-hook 'org-brain-after-visualize-hook #'aa2u-org-brain-buffer)))

(defun org-brain-open-org-noter ()
  (interactive)
  (let ((entry (condition-case nil
		   (car (org-brain-button-at-point))
		 (user-error (org-brain-entry-at-pt)))))
    (if (org-brain-filep entry)
	(user-error "Noter cannot be opened for file entry")
      (org-with-point-at (org-brain-entry-marker entry)
	(if (string= "research_papers" (file-name-base (org-entry-get (point) "FILE")))
	    (org-noter)
	  (user-error "Noter only for the entries in research_paper"))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;experimnet begin
;; (defun org-brain-insert-visualize-button-tags (old-func &rest args)
;;   "."
;;   (unless (org-brain-filep (car args))
;;     (message "-- %s" (org-brain-keywords (car args)))) ;(cadar args)))
;;   (apply old-func args))
;; (advice-add 'org-brain-insert-visualize-button :around #'org-brain-insert-visualize-button-tags)

;; (advice-remove 'org-brain-insert-visualize-button #'org-brain-insert-visualize-button-tags)
;; (defun org-brain--vis-children-with-tags (entry)
;;   "Insert children of ENTRY.
;; Helper function for `org-brain-visualize'.
;; Appends the first letter of the todo state of the entry"
;;   (let ((tags (org-brain-get-tags entry t)))
;;     (when-let ((children (org-brain-children entry))
;;                (fill-col (if (member org-brain-each-child-on-own-line-tag
;;                                      (org-brain-get-tags entry))
;;                              0
;;                            (eval org-brain-child-linebreak-sexp))))
;;       (insert "\n\n")
;;       (dolist (child (if (member org-brain-no-sort-children-tag tags)
;;                          children
;;                        (sort children org-brain-visualize-sort-function)))
;;         (let ((child-title (org-brain-title child))
;;               (face (if (member entry (org-brain-local-parent child))
;;                         'org-brain-local-child
;;                       'org-brain-child)))
;;           (when (> (+ (current-column) (length child-title)) fill-col)
;;             (insert "\n"))
;; 	  (let ((kwd-setting
;; 		 (unless (org-brain-filep child)
;; 		   (org-with-point-at
;; 		       (org-brain-entry-marker child)
;; 		     (let ((kwd (org-entry-get (point) "TODO")))
;; 		       (if kwd
;; 			   (list kwd (org-get-todo-face kwd))
;; 			 nil))))))
;; 	    (when kwd-setting
;; 	      (insert (propertize (substring (first kwd-setting) 0 1) 'face (second kwd-setting)) " ")))
;;           (org-brain-insert-visualize-button child face)
;;           (insert "  "))))))
;; (advice-add 'org-brain--vis-children :override #'org-brain--vis-children-with-tags)

;;(advice-remove 'org-brain--vis-children #'org-brain--vis-children-with-tags)

(defun org-brain-insert-visualize-button-with-tags (entry &optional face edge)
  "Insert a button, running `org-brain-visualize' on ENTRY when clicked.
FACE is sent to `org-brain-display-face' and sets the face of the button.
Appends the todo state of the entry being visualized."
  (let ((annotation (org-brain-get-edge-annotation org-brain--vis-entry
                                                   entry
                                                   org-brain--vis-entry-keywords)))
    (let ((kwd-setting
	   (unless (org-brain-filep entry)
	     (org-with-point-at
		 (org-brain-entry-marker entry)
	       (let ((kwd (org-entry-get (point) "TODO")))
		 (if kwd
		     (list kwd (org-get-todo-face kwd))
		   nil))))))
      (when kwd-setting
	(insert (propertize (substring (first kwd-setting) 0 1) 'face (second kwd-setting)) " ")))
    (insert-text-button
     (org-brain-title entry)
     'action (lambda (_x) (org-brain-visualize entry))
     'id (org-brain-entry-identifier entry)
     'follow-link t
     'help-echo annotation
     'aa2u-text t
     'face (org-brain-display-face entry face annotation))))

(defmacro org-brain-function-on-entry (fn)
  "Macro that generates a function which takes an entry and executes the fn while on a file entry."
  `(lambda (entry)
     (if (org-brain-filep entry)
         ""
       (org-with-point-at (org-brain-entry-marker entry)
         (or (funcall ,fn entry)
	     "")))))

(defun org-brain-entry-todo-state-colored (entry)
  "Get todo state of ENTRY with colors."
  (let ((kwd (org-entry-get (point) "TODO")))
    (if kwd
	(propertize (substring kwd 0 1) 'face (org-get-todo-face kwd))
      nil)))

(defun org-brain-entry-priority (entry)
  "Get priority state of ENTRY with colors."
  (let ((priority (org-priority-to-value (org-priority-show))))
    (cond
     ((= priority 2000) "[#A]")
     (t nil))))


;; (advice-add 'org-brain-insert-visualize-button :override #'org-brain-insert-visualize-button-with-tags)

;; (advice-remove 'org-brain-insert-visualize-button #'org-brain-insert-visualize-button-with-tags)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;experimnet end

(use-package org-ql
  :straight (org-ql :type git :host github :repo "alphapapa/org-ql" :fork t)
  :commands org-ql-defpred
  :bind (:map org-agenda-mode-map
         ("C-c o o" . org-ql-view-noter)))

(defun org-ql-view-noter ()
  (interactive)
  (let* ((marker (or (org-get-at-bol 'org-hd-marker)
                     (org-agenda-error)))
         (buffer (marker-buffer marker))
         (pos (marker-position marker)))
    (when (equalp (buffer-name buffer) "research_papers.org")
      (with-current-buffer buffer
        (goto-char pos)
        (org-noter)))))

(org-ql-defpred brain-parent (&rest args)
  ""
  :body
  (let ((parents (org-entry-get-multivalued-property (point) "BRAIN_PARENTS"))
        (pred (car args))
        (parent-ids (cdr args)))
    (message "%s %s" pred parent-ids)
    (when parents
      (funcall
       (cond
        ((equalp pred 'or) #'-any-p)
        ((equalp pred 'and) #'-all-p)
        nil)
       (lambda (parent) (member parent parents)) parent-ids))))

(org-ql-defpred search-pdf-regexp (regexp)
  ""
  :body
  (let ((text-file (org-entry-get (point) "PDF_TEXT_FILE")))
    (when text-file
      (with-temp-buffer
        (insert-file-contents text-file)
        (s-match-strings-all regexp (buffer-string))))))

;; TODO: allow mulitiple combinations of brain-parent to be used (eg: (and (or ..) (or ..)))
(defun org-brain-query-papers-by-topic ()
  "."
  (interactive)
  (let* ((topics '())
         (done nil)
         (selection-list (append '(("-- DONE" . nil)) (org-brain--all-targets))))
    (while (not done)
      (ivy-read "Query topic: " selection-list
                :predicate (lambda (entry)
			     (or (s-starts-with-p "--" (car entry))
                                 (s-starts-with-p "research topics::" (car entry))
                                 (s-starts-with-p "misc_topics::" (car entry))
			         (s-matches-p "work/projects::.*literature" (car entry))
			         (s-starts-with-p "publication::" (car entry))))
                :action (lambda (selection)
                          (if (cdr selection)
                              (push selection topics)
                            (setq done t)))))
    (let* ((topic-ids (list (append `(brain-parent 'and) (mapcar #'cdr topics))))
           (query (append '(and (level <= 1)) topic-ids)))
      (message "%s" query)
      (org-ql-search '("~/Documents/org/brain/research_papers.org")  query))))

(defun org-brain-query-papers-by-pdf-string (regexp)
  "."
  (interactive "sRegexp: ")
  (let* ((query `(and (level <= 1) (search-pdf-regexp ,regexp))))
      (message "%s" query)
      (org-ql-search '("~/Documents/org/brain/research_papers.org")  query)))


(defun org-projects-query-boards ()
  "List the in progress items in the project boards directory. Either show all or filter based on a sprint."
  (interactive)
  (let* ((files (f-entries "~/Documents/org/brain/work/project_boards" (lambda (x) (s-ends-with-p ".org" x))))
         (ivy-slection-list (append '(("ALL" . nil)) (org-brain--all-targets)))
         (predicate '(and (todo "INPROGRESS" "TODO"))))
    
    (ivy-read "Project topic: " ivy-slection-list
              :predicate (lambda (entry)
                           (or (string= (car entry) "ALL")
                               (s-matches-p "work/projects::Sprint.*" (car entry))))
              :action (lambda (selection)
                        (unless (string= (car selection) "ALL")
                          (setq predicate (append predicate `((member ,(cdr selection) (org-entry-get-multivalued-property (point) "BRAIN_PARENTS"))))))))
    (org-ql-search files predicate
      :super-groups (mapcar (lambda (x) (list :file-path (f-base x))) files))))

(require 'ox-extra)
(ox-extras-activate '(ignore-headlines))

(require 'org-download)
(setq org-download-screenshot-method "scrot")
(defun pdf-crop-image (event &optional switch-back)
  "EVENT SWITCH-BACK."
  (interactive "@e")
  (setq current-b (buffer-name))
  (progn (pdf-view-mouse-set-region-rectangle event)
	 (message "%s" pdf-view-active-region)
	 (pdf-view-extract-region-image pdf-view-active-region
					(pdf-view-current-page)
					(pdf-view-image-size)
					(get-buffer-create "teste")
					nil)))

(defun pdf-crop-image-and-save (event &optional switch-back)
  "EVENT SWITCH-BACK."
  (interactive "@e")
  (setq current-b (buffer-name))
  (progn (pdf-view-mouse-set-region-rectangle event)
	 (message "%s" pdf-view-active-region)
	 (pdf-view-extract-region-image pdf-view-active-region
					(pdf-view-current-page)
					(pdf-view-image-size)
					(get-buffer-create "teste.jpg")
					nil)
         (set-buffer "teste.jpg")
	 (switch-to-buffer "taste.jpg")
         (with-current-buffer "taste.jpg"
           (message "-----  %s" (buffer-name))
           (mark-whole-buffer)
           (kill-ring-save (point-min) (point-max))
           (write-file "~/" t)
           (yank))))
	 ;; (kill-buffer "screenshot.png")
	 ;; (set-buffer current-b)
	 ;; (org-noter-insert-note)
	 ;; (org-download-screenshot)
	 ;; (if switch-back
;;     (switch-to-buffer-other-frame current-b))))

(defun amsha/format-multiline-from-kill-ring ()
  "Format a mulitline kill in the kill-ring into a single line."
  (format "\"%s\"" (replace-regexp-in-string "\n" " " (replace-regexp-in-string "- " "" (car kill-ring)))))

(defun amsha/paste-formatted-multiline-from-kill-ring ()
  "Paste a multiline segment (generally copied from pdf) as a single line."
  (interactive)
  (insert (amsha/format-multiline-from-kill-ring)))
  

(defun amsha/org-noter-copy-text-as-note ()
  "While in org noter, copy a highlighted text in as a heading with some minor additional formatting."
  (interactive)
  (let ((precise-info (org-noter--get-precise-info)))
    (pdf-view-kill-ring-save)
    (let ((org-noter-default-heading-title (amsha/format-multiline-from-kill-ring)))
      (let ((org-noter-insert-note-no-questions t))
	(org-noter-insert-note precise-info))
      ;; sometime the replace doesn't seem to work, so redoing it?
      (org-map-entries (lambda ()
			 (let (beg end)
			   (org-back-to-heading)
			   (setq beg (point))
			   (outline-end-of-heading)
			   (setq end (point))
			   (save-excursion
			     (kill-region beg end)
			     (insert (replace-regexp-in-string "- " "" (car kill-ring))))))
		       "LEVEL=2")
      (message "%s" (current-buffer)))))

(when (gethash 'use-pdf-tools configurations t)
  (define-key pdf-view-mode-map (kbd "C-c i") 'amsha/org-noter-copy-text-as-note)
  (define-key pdf-view-mode-map [C-M-down-mouse-1] 'pdf-crop-image)
  (define-key pdf-view-mode-map [C-M-S-down-mouse-1] 'pdf-crop-image-and-save))

(setq org-export-allow-bind-keywords t
      org-latex-image-default-option "scale=0.6")

(defun set-property-for-level-in-region (level property value)
  "."
  (interactive "nLevel: \nsPropertyb: \nsValue: ")
  (message "%s %s %s %s %s" level property value (region-beginning) (region-end))
  (org-map-entries
   (lambda ()
     (org-entry-put (point) (upcase property) value))
     ;;(message "%s" (org-entry-properties)))
   (format "LEVEL=%s" level)
   'region))
     
(defun amsha/rename-full-path (file-name)
  "FILE-NAME."
  (replace-regexp-in-string "^\\([a-z]:\\)?\\(/.*\\)/Documents" "~/Documents" file-name))

(defun research-papers-configure ()
  "."
  (interactive)
  (org-map-entries (lambda ()
		     (let* ((link-string (org-entry-get (point) "LINK"))
                            (link (if (string-empty-p link-string)
                                      nil
                                    link-string))
			    (cite-key (org-entry-get (point) "Custom_ID"))
			    (dir org-ref-pdf-directory)
			    (tags (org-get-tags))
			    (out-file-name (concatenate 'string cite-key ".pdf"))
			    (full-path (amsha/rename-full-path (expand-file-name out-file-name dir))))
		       (org-entry-put (point) "ATTACH_DIR" dir)
		       (org-id-get-create)
		       (when (not (member "ATTACH" tags))
                         (if (or (file-exists-p full-path)
                                 (and link
                                      cite-key
                                      (condition-case nil
                                          (amsha/downlad-raname-move-file link out-file-name dir)
                                        (file-already-exists t))))
                             (progn
                               (org-entry-put (point) "Attachment" out-file-name)
                               (setq tags (append tags '("ATTACH")))
                               (org-entry-put (point) "INTERLEAVE_PDF" full-path))
                           (progn
                             (setq tags (if link (delete "NO_LINK" tags) (append tags '("NO_LINK"))))
                             (setq tags (if cite-key (delete "NO_CITE_KEY" tags) (append tags '("NO_CITE_KEY")))))))
                       (when (file-exists-p full-path)
                         (let ((text-file-name (expand-file-name (format "%s.txt" (file-name-base full-path)) (file-name-directory full-path))))
                           (unless (file-exists-p text-file-name)
                             (condition-case nil
                                 (progn
                                   (with-temp-buffer
                                     (insert (amsha/pdf-to-text full-path))
                                     (write-file text-file-name))
                                   (org-entry-put (point) "PDF_TEXT_FILE" (amsha/rename-full-path text-file-name)))
                               (error (message "Error: failed to read pdf file: %s" full-path)
                                      (setq tags (append tags '("PDF_ERROR"))))))))
		       (setq tags
			     (if (org-entry-get (point) "BRAIN_PARENTS")
			         (delete "NO_PARENTS" tags)
			       (append tags '("NO_PARENTS"))))
		       (org-set-tags (delete "nosiblings" (delete-dups tags)))))
		   "LEVEL=1")
  (org-brain-update-id-locations))

(defun amsha/doi-utils-get-pdf-url-uml (old-function &rest rest)
  "Making sure the urls that are being recived by org-ref is made to use uml links."
  (let ((url (apply old-function rest)))
    (message "%s" url)
    (when url
      (amsha/get-uml-link url))))

(advice-add #'doi-utils-get-pdf-url :around #'amsha/doi-utils-get-pdf-url-uml)

(defun copy-related-research-papers (parent-id)
  "PARENT-ID."
  (interactive (list
		(save-excursion
		  (org-brain-goto (org-brain-choose-entry "Select research topic: " 'all (lambda (entry)
                                                                                           (or
                                                                                            (s-matches-p "work/projects::.*literature" (car entry))
                                                                                            (s-starts-with-p "research topics::" (car entry))))))
		  (org-entry-get (point) "ID"))))
  (let ((out-dir (expand-file-name parent-id "~/Downloads")))
    (condition-case nil
	(make-directory out-dir)
      (file-already-exists
       (progn
	 (message "Deleting directory and creating anew: %s" out-dir) 
	 (delete-directory out-dir t)
	 (make-directory out-dir))))
    (message "Copying files to %s" out-dir)
    (save-excursion
      (org-brain-goto "research_papers")
      (org-map-entries (lambda ()
		         (let ((file-path (org-entry-get (point) "INTERLEAVE_PDF")))
			   (when (and file-path
				      (member parent-id
					      (org-entry-get-multivalued-property (point) "BRAIN_PARENTS")))
			     (message "Copied %s" (file-name-nondirectory file-path)) 
			     (copy-file file-path
				        (expand-file-name (file-name-nondirectory file-path)
							  out-dir)))))))
    (dired out-dir)))

(defvar copy-notes-and-bib-function-org-buffer nil)
(defvar copy-notes-and-bib-function-bib-buffer nil)

(defun copy-notes-and-bib-function ()
  "NOTES-BUFFER BIB-BUFFER PREDICATE."
  (let* ((temp-name (secure-hash 'md5 (format "%s" (current-time))))
         (org-file-buffer (generate-new-buffer (format "*org-paper-notes-%s*" temp-name)))
         (bib-file-buffer (generate-new-buffer (format "*paper-notes-bib-%s*" temp-name))))
    (with-current-buffer org-file-buffer
      (org-mode)
      (insert "#+OPTIONS: H:0\n\n"))
    (with-current-buffer bib-file-buffer
      (bibtex-mode))
    (setq copy-notes-and-bib-function-org-buffer org-file-buffer)
    (setq copy-notes-and-bib-function-bib-buffer bib-file-buffer)
    (lambda ()
      (message "%s >> " (org-entry-get (point) "Custom_ID"))
      (let* ((key (org-entry-get (point) "Custom_ID"))
             (org-ref-result (org-ref-get-bibtex-key-and-file key)))
        (save-excursion
          (find-file (cdr org-ref-result))
          (bibtex-search-entry key)
          (bibtex-copy-entry-as-kill)
          (with-current-buffer bib-file-buffer
            (bibtex-yank))))
      (org-copy-subtree)
      (with-current-buffer org-file-buffer
        (when (not (looking-at "^")) (insert "\n"))
	(org-paste-subtree 1)))))

(defun copy-notes-and-bib-function-switch-to-buffers ()
  (interactive)
  (when copy-notes-and-bib-function-org-buffer
    (switch-to-buffer copy-notes-and-bib-function-org-buffer))
  (when copy-notes-and-bib-function-bib-buffer
    (switch-to-buffer copy-notes-and-bib-function-bib-buffer)))

(defun org-ql-copy-query-notes-and-bib (query)
  "copy notes and bib file to a seperate buffer based on org-ql query QUERY."
  (interactive "xQuery: ")
  (org-ql-select (buffer-file-name (marker-buffer (org-brain-entry-marker "research_papers")))
    query
    :action (copy-notes-and-bib-function))
  (copy-notes-and-bib-function-switch-to-buffers))

(defvar org-agenda-bulk-action-started nil)
(defvar org-agenda-bulk-action-post-execution-function nil)

(defun org-agenda-bulk-action-wrapper (original &rest args)
  (setq org-agenda-bulk-action-started t)
  (condition-case nil
      (apply original args)
    (error nil))
  (setq org-agenda-bulk-action-started nil)
  (when org-agenda-bulk-action-post-execution-function
    (funcall org-agenda-bulk-action-post-execution-function))
  (setq org-agenda-bulk-action-post-execution-function nil))

(advice-add 'org-agenda-bulk-action :around #'org-agenda-bulk-action-wrapper)

(defvar org-agenda-copy-query-notes-and-bib-func nil)

(defun org-agenda-copy-query-notes-and-bib ()
  "To be used with the org-agenda-bulk-action."
  (unless org-agenda-copy-query-notes-and-bib-func
    (setq org-agenda-copy-query-notes-and-bib-func (copy-notes-and-bib-function))
    (setq org-agenda-bulk-action-post-execution-function (lambda ()
                                                           (setq org-agenda-copy-query-notes-and-bib-func nil)
                                                           (copy-notes-and-bib-function-switch-to-buffers))))
  (org-with-point-at (or (org-get-at-bol 'org-hd-marker)
                         (org-agenda-error))
    (funcall org-agenda-copy-query-notes-and-bib-func)))

(require 'org-ref-arxiv)
(defun arxiv-add-bibtex-entry-with-note (arxiv-link bibfile)
  "Add bibtex entry for ARXIV-LINK to BIBFILE."
  (interactive
   (list (read-string "arxiv: ")
         ;;  now get the bibfile to add it to
         (completing-read
          "Bibfile: "
          (append (f-entries "." (lambda (f) (f-ext? f "bib")))
                  org-ref-default-bibliography))))
  (save-window-excursion
    (find-file bibfile)
    (let* ((arxiv-number (s-chop-suffix ".pdf" (car (last (s-split "/" arxiv-link)))))
	   (search-point (word-search-forward arxiv-number nil t)))
      (if search-point
	  (progn
	    (goto-char search-point)
	    (message "%s already exists in the database" arxiv-number))
	(progn
	  (goto-char (point-max))
	  (when (not (looking-at "^")) (insert "\n"))
	  (insert (arxiv-get-bibtex-entry-via-arxiv-api arxiv-number))
	  (org-ref-clean-bibtex-entry)
	  (message "%s" (buffer-file-name))
	  (save-excursion
	    (when (f-file? org-ref-bibliography-notes)
	      (find-file-noselect org-ref-bibliography-notes)
	      (save-buffer))
	    (let ((bibtex-completion-bibliography (list (buffer-file-name)))
		  (keys (progn		  
			  (bibtex-beginning-of-entry)
			  (list (cdr (assoc "=key=" (bibtex-parse-entry)))))))
	      (bibtex-completion-edit-notes keys))
	    (goto-char (point-max))
	    (when (not (looking-at "^")) (insert "\n"))
	    (save-buffer))
	  (save-excursion
	    (find-file-other-window bibtex-completion-notes-path)
	    (goto-char (point-max))
	    (org-set-property "LINK" arxiv-link)
	    (research-papers-configure)))))))

(defun org-brain-add-parent-topic ()
  "."
  (interactive)
  (let ((embark-quit-after-action nil)
        (entry (org-brain-entry-at-pt)))
    (org-brain-add-parent entry (org-brain-choose-entries "Add parent topic: " 'all (lambda (entry)
										      (or (s-starts-with-p "research topics::" (car entry))
                                                                                          (s-starts-with-p "misc_topics::" (car entry))
											  (s-matches-p "work/projects::.*literature" (car entry))
											  (s-starts-with-p "publication::" (car entry))))))
    (org-brain-print-topics entry)))

(defun org-brain-goto-button-at-pt ()
  "."
  (interactive)
  (org-brain-goto (car (org-brain-button-at-point))))

(defun org-brain-print-topics (&optional entry)
  "."
  (interactive)
  (when (null entry)
    (setq entry (condition-case nil
		    (car (org-brain-button-at-point))
		  (user-error (org-brain-entry-at-pt)))))
  (let ((parents (org-brain-parents entry))
        (topics '())
        (other-parents '()))
    (mapcar (lambda (entry)
              (message "%s " entry)
              (when (and (listp entry))
                (if (equalp (car entry) "research topics")
                  (push (cadr entry) topics)            
                  (push (cadr entry) other-parents))))
            parents)
    (message "%s \n********************************\n\t\t%s" (mapconcat 'identity topics "\n") (mapconcat 'identity other-parents "\n\t\t"))
    (cons topics other-parents)))

(defun org-brain-delete-interleve-entry ()
  "Deletes the pdf entry of an org brain bib at point at point."
  (interactive)
  (if (y-or-n-p "Sure you want to delete the pdf file and the interleve entry here?")
      (progn
	(save-excursion
	  (goto-char (org-entry-beginning-position))
	  (delete-file (org-entry-get (point) "INTERLEAVE_PDF") nil)
          (when (file-exists-p (org-entry-get (point) "PDF_TEXT_FILE"))
              (delete-file (org-entry-get (point) "PDF_TEXT_FILE") nil))
	  (org-entry-delete (point) "Attachment")
	  (org-entry-delete (point) "INTERLEAVE_PDF")
          (org-entry-delete (point) "PDF_TEXT_FILE")
	  (org-set-tags (delete "nosiblings" (delete "ATTACH" (org-get-tags))))))))

(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
(add-hook 'org-mode-hook
	  (lambda ()
	    (define-key org-mode-map "\C-c!" 'org-time-stamp-inactive)
	    (define-key org-mode-map "\C-coo" 'org-noter)
	    (define-key org-mode-map "\C-cop" 'org-brain-add-parent-topic)
	    (define-key org-mode-map "\C-coc" 'research-papers-configure)
            (define-key org-mode-map "\C-cos" 'org-brain-print-topics)
	    (flyspell-mode t)))
(add-hook 'org-mode-hook 'visual-line-mode)

(defun amsha/pdf-to-text (file-name)
  "FILE-NAME."
  (let* ((normalized-file-name (expand-file-name file-name)))
    (format
     "%s"
     (replace-regexp-in-string
      "\n" " "
      (replace-regexp-in-string "- " ""
                                (mapconcat (lambda (page-number)
                                             (pdf-info-gettext (number-to-string page-number) '(0 0 1 1) nil normalized-file-name))
                                           (number-sequence 1 (pdf-info-number-of-pages normalized-file-name)) " "))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;experimnet starts
;; (defvar org-brain-insert-visualize-button-predicate nil)

;; (defun org-brain-insert-visualize-button-predicate-drop-research-papers (entry)
;;   (not (member (file-name-sans-extension (file-truename org-ref-bibliography-notes)) (org-brain-parents entry))))

;; (defun org-brain-insert-visualize-button-with-predicate (entry &optional face category)
;;   "Insert a button, running `org-brain-visualize' on ENTRY when clicked.
;; FACE is sent to `org-brain-display-face' and sets the face of the button.
;; CATEGORY is used to set the `brain-category` text property."
;;   (when (and org-brain-insert-visualize-button-predicate
;; 	     (funcall org-brain-insert-visualize-button-predicate entry))
;;     (let ((annotation (org-brain-get-edge-annotation org-brain--vis-entry
;; 						     entry
;; 						     org-brain--vis-entry-keywords)))
;;       (insert-text-button
;;        (org-brain-vis-title entry)
;;        'action (lambda (_x) (org-brain-visualize entry))
;;        'id (org-brain-entry-identifier entry)
;;        'follow-link t
;;        'brain-category (or category 'default)
;;        'help-echo annotation
;;        'aa2u-text t
;;        'face (org-brain-display-face entry face annotation)))))

;; (defun orb-brain-visualize-show-research-papers ()
;;   "."
;;   (interactive)
;;   (setq org-brain-insert-visualize-button-predicate
;; 	(if org-brain-insert-visualize-button-predicate
;; 	    nil
;; 	  (function org-brain-insert-visualize-button-predicate-drop-research-papers))))

;; (advice-add 'org-brain-insert-visualize-button :override #'org-brain-insert-visualize-button-with-predicate)

;; (advice-remove 'org-brain-insert-visualize-button #'org-brain-insert-visualize-button-with-predicate)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;experimnet end

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cc" 'org-capture)
(setq org-log-done 'note)
(setq org-log-into-drawer t)
(setq org-deadline-warning-days 2)
(setq org-clock-idle-time 10)
(setq org-return-follows-link t)
(setq org-return-follows-link t)
(setq org-refile-use-outline-path "file")
(setq org-outline-path-complete-in-steps t)(setq org-completion-use-ido t)
(setq org-attach-directory "~/Documents/org/documents/")
(setq org-clock-continuously t
      org-clock-idle-time 10)

(provide 'orgZ)
;;; orgZ.el ends here
