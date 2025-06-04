;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

;;; Install mouse wheel for scrolling
;; (mwheel-install)

;;; Turn off beeping
(setq visible-bell t)

;;; Require new line at the end of a file
(setq require-final-newline t)
(setq mode-require-final-newline t)

;;; Turn off any startup messages
(setq inhibit-startup-message 0)
(setq inhibit-scratch-message nil)

;;; Turn off annoying cordump on tooltip "feature"
(setq x-gtk-use-system-tooltips nil)

;;; Insert spaces instead of tabs
(setq indent-tabs-mode nil)

;;; Line numbers and column numbers
(column-number-mode t)
(line-number-mode t)
(global-display-line-numbers-mode 1) ;; Enable line numbers globally

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-for-comint-mode t)
 '(font-lock-global-modes t)
 '(groovy-mode-hook
   '(whitespace-cleanup-on-save-hook
     (lambda nil
       (setq indent-tabs-mode nil))) t)
 '(load-home-init-file t t)
 '(package-selected-packages
   '(docker typescript-mode groovy-mode pkg-info dockerfile-mode terraform-mode yaml-mode markdown-mode+ markdown-mode zone-nyan paradox))
 '(paradox-github-token t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(comint-highlight-input ((t (:weight bold))))
 '(comint-highlight-prompt ((t nil))))

;;; Suppress tabs in namespace
(defconst my-cc-style
  '("gnu"
    (c-offsets-alist . ((innamespace . [0])))))

(c-add-style "my-cc-style" my-cc-style)

(setq c-default-style "linux") ;; linux indentation style (do not indent '{' after if/for/function blocks)
(setq c-basic-offset 4) ;; default comments at 4 spaces
(c-set-offset 'innamespace 0) ;; namespaces shouldn't cause indentation
(show-paren-mode t) ;; show matching parenthesis
(c-set-offset 'access-label -2) ;; private, public etc. indent at two spaces

;;; load headers files .h as C++ mode not c
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode)) ;; treat .h as C++ no C

;;; Don't generate backup files
(setq make-backup-files nil)

;;; Highlight lines >= 120 characters (C++, Python)
(setq whitespace-line-column 120)
(defun highlight-long-lines-hook ()
  (require 'whitespace)
  (setq whitespace-style '(face empty tabs lines-tail trailing))
  (whitespace-mode t))

(add-hook 'c++-mode-hook 'highlight-long-lines-hook)
(add-hook 'python-mode-hook 'highlight-long-lines-hook)

;;; Cleanup whitespace before save (C++, Python)
(defun whitespace-cleanup-on-save-hook ()
  (add-to-list 'before-save-hook 'whitespace-cleanup nil 'local))

(add-hook 'c++-mode-hook 'whitespace-cleanup-on-save-hook)
(add-hook 'python-mode-hook 'whitespace-cleanup-on-save-hook)
;; (add-hook 'groovy-mode-hook 'whitespace-cleanup-on-save-hook)

;;; Rebind C-x C-b to invoke buffer-menu rather than list-buffers
;;; This will show the buffers in the current window
(global-set-key "\C-x\C-b" 'buffer-menu)

;;; Explicitly set background color to black
(add-to-list 'default-frame-alist '(background-color . "#00000000"))

;;; Rebind C-x C-b to invoke buffer-menu rather than list-buffers
;;; This will show the buffers in the current window
(global-set-key "\C-x\C-b" 'buffer-menu)

;;; Explicitly set background color to black (overwrite any background image)
(add-to-list 'default-frame-alist '(background-color . "#00000000"))

;;; Link your x clipboard (ONLY WORKS IN WINDOW MODE)
;;; (setq x-select-enable-clipboard t)

;;; xclip hack to link your x clipboard in -nw mode
(defun copy-to-clipboard-linux (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "xclip" "*Messages*" "xclip" "-selection" "clipboard")))
      (process-send-string proc text)
      (process-send-eof proc))))

(defun copy-to-clipboard-mac (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

;;; LINUX ONLY: link clipboard and region
;;; (setq interprogram-cut-function 'copy-to-clipboard-linux)

;;; MAC ONLY: link cliboard and region
(setq interprogram-cut-function 'copy-to-clipboard-mac)

;;; activate windmove (default key: shift)
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
;; (windmove-default-keybindings 'M)

;;; increase buffer menu name width to see more of the file name
(setq Buffer-menu-name-width 40)

;;; f8 hotkey to switch between cpp and header file
(defun cpp-switch ()
  (interactive)
  (let ((filename (file-name-nondirectory (buffer-file-name (current-buffer)))))
    (message filename)
    (cond ((string-suffix-p ".cpp" filename)
	   (find-file (concat (file-name-sans-extension filename) ".h")))
	  ((string-suffix-p ".h" filename)
	   (find-file (concat (file-name-sans-extension filename) ".cpp")))
	  (t (message "Not a c++ file"))
	  )))
(global-set-key (kbd "<f8>") 'cpp-switch)

;;; Custom align-regexp to align a particular word in each highlighted line
;;; Emacs Regular Expression is NON STANDARD. See documentation here: https://www.emacswiki.org/emacs/RegularExpression
;;; Notes:
;;; - align-regexp calls the provided regex once per line (so using ^ is equivalent to line start)
;;; - All backslashed have to be escape when calling align-regexp from .emacs
;;;
;;; Regular Expression for aligning the first word in a line: ^\(?:\s-*\S-+\)\{1\}\(\s-+\)
;;; - ^ asserts position at start of the string (i.e., start of line)
;;; - Non-capturing group: \(?:\s-*\S-+\)\{1\}
;;;     - \{1\} Quantifier -- Matches exactly one time (meaningless quantifier)
;;;     - \s-* matches zero or more whitespace characters (equal to [\r\n\t\f\v ])
;;;     - \S-+ matches one or more non-whitespace character (equal to [^\r\n\t\f\v ])
;;; - 1st Capturing Group \(\s-+\)
;;;     - \s-+ matches one or more whitespace character (equal to [\r\n\t\f\v ])
(defun align-word (start end)
  "Choose a number word to align (must be > 1 amd in ascending order)"
  (interactive "r")
  (align-regexp start end
		(concat "^\\(?:\\s-*\\S-+\\)\\{"
			(decrementNumString(read-string "Enter word (>1): "))
			"\\}\\(\\s-+\\)")
		1 1 t))
(defun decrementNumString(str)
  (number-to-string (- (string-to-number str) 1)))

;;; advise align-regexp (and thus align-word) to align with spaces instead of tabs
;;; https://stackoverflow.com/questions/22710040/emacs-align-regexp-with-spaces-instead-of-tabs
(defadvice align-regexp (around align-regexp-with-spaces activate)
  (let ((indent-tabs-mode nil))
    ad-do-it))

;;; idle zone
(require 'zone)
;;; (zone-when-idle 120)

;;; try out particular zones
(defun zone-choose (pgm)
  "Choose a PGM to run for `zone'."
  (interactive
   (list
    (completing-read
     "Program: "
     (mapcar 'symbol-name zone-programs))))
  (let ((zone-programs (list (intern pgm))))
    (zone)))

;;; zone choices are:
;; zone-pgm-jitter
;; zone-pgm-putz-with-case
;; zone-pgm-dissolve
;; zone-pgm-explode
;; zone-pgm-whack-chars
;; zone-pgm-rotate
;; zone-pgm-rotate-LR-lockstep
;; zone-pgm-rotate-RL-lockstep
;; zone-pgm-rotate-LR-variable
;; zone-pgm-rotate-RL-variable
;; zone-pgm-drip
;; zone-pgm-drip-fretfully
;; zone-pgm-five-oclock-swan-dive
;; zone-pgm-martini-swan-dive
;; zone-pgm-rat-race
;; zone-pgm-paragraph-spaz
;; zone-pgm-stress
;; zone-pgm-stress-destress
;; zone-pgm-random-life



;;; Disable "Seconday Device Attributes" query
;;; Query located: https://github.com/emacs-mirror/emacs/blob/master/lisp/term/xterm.el#L788
;;; Info on 'Xterm extra capabilities' located here: https://github.com/emacs-mirror/emacs/blob/master/lisp/term/xterm.el#L46
;;; ANSI Documentation: http://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Functions-using-CSI-_-ordered-by-the-final-character_s_
;;; CSI > Ps c
;;;           Send Device Attributes (Secondary DA).
;;;             Ps = 0  or omitted -> request the terminal's identification
;;;           code.  The response depends on the decTerminalID resource set-
;;;           ting.  It should apply only to VT220 and up, but xterm extends
;;;           this to VT100.
;;;             -> CSI  > Pp ; Pv ; Pc c
;;;           where Pp denotes the terminal type
;;;             Pp = 0  -> "VT100".
;;;             Pp = 1  -> "VT220".
;;;             Pp = 2  -> "VT240".
;;;             Pp = 1 8 -> "VT330".
;;;             Pp = 1 9 -> "VT340".
;;;             Pp = 2 4 -> "VT320".
;;;             Pp = 4 1 -> "VT420".
;;;             Pp = 6 1 -> "VT510".
;;;             Pp = 6 4 -> "VT520".
;;;             Pp = 6 5 -> "VT525".
;;;           and Pv is the firmware version (for xterm, this was originally
;;;           the XFree86 patch number, starting with 95).  In a DEC termi-
;;;           nal, Pc indicates the ROM cartridge registration number and is
;;;           always zero.
;;;
;;;
;;; This is the believed cause of the strange ANSI escape sequences 1;2501;0c appearing (secondary device attribute response)
;;; Can replicate response in C using: printf("\033[>c");
;;; Still more to it, not sure cause or how to replicate.
;;; There appear to be persistent and equally elusive graphical bugs with emacs
;;; These bugs only manifest on gnome-terminal in shell mode (-nw) emacs, leading me to believe
;;; that the root cause is a TERM mismatch (gnome-terminal uses 'xterm', echo $TERM to check)
;;; Investigated 12/21/2017
(setq xterm-extra-capabilities nil)





(defun xah-quote-lines ()
  "Change current text block's lines to quoted lines with comma or other separator char.
When there is a text selection, act on the selection, else, act on a text block separated by blank lines.

For example,

 cat
 dog
 cow

becomes

 \"cat\",
 \"dog\",
 \"cow\",

or

 (cat)
 (dog)
 (cow)

If the delimiter is any left bracket, the end delimiter is automatically the matching bracket.

URL `http://ergoemacs.org/emacs/emacs_quote_lines.html'
Version 2017-01-08"
  (interactive)
  (let* (
	 $p1
	 $p2
	 ($quoteToUse
	  (read-string
	   "Quote to use:" "\"" nil
	   '(
	     ""
	     "\""
	     "'"
	     "("
	     "{"
	     "["
	     )))
	 ($separator
	  (read-string
	   "line separator:" "," nil
	   '(
	     ""
	     ","
	     ";"
	     )))
	 ($beginQuote $quoteToUse)
	 ($endQuote
	  ;; if begin quote is a bracket, set end quote to the matching one. else, same as begin quote
	  (let (($syntableValue (aref (syntax-table) (string-to-char $beginQuote))))
	    (if (eq (car $syntableValue ) 4) ; ; syntax table, code 4 is open paren
		(char-to-string (cdr $syntableValue))
	      $quoteToUse
	      ))))
    (if (use-region-p)
	(progn
	  (setq $p1 (region-beginning))
	  (setq $p2 (region-end)))
      (progn
	(if (re-search-backward "\n[ \t]*\n" nil "NOERROR")
	    (progn (re-search-forward "\n[ \t]*\n")
		   (setq $p1 (point)))
	  (setq $p1 (point)))
	(re-search-forward "\n[ \t]*\n" nil "NOERROR")
	(skip-chars-backward " \t\n" )
	(setq $p2 (point))))
    (save-excursion
      (save-restriction
	(narrow-to-region $p1 $p2)
	(goto-char (point-min))
	(skip-chars-forward "\t ")
	(insert $beginQuote)
	(goto-char (point-max))
	(insert $endQuote)
	(goto-char (point-min))
	(while (re-search-forward "\n\\([\t ]*\\)" nil "NOERROR" )
	  (replace-match
	   (concat $endQuote $separator (concat "\n" (match-string 1)) $beginQuote) "FIXEDCASE" "LITERAL"))
	;;
	))))

;; Delete commands without adding to kill ring (which overwrites the clipboard)

(defun ruthless-delete-word (arg)
  "Delete characters forward until encountering the end of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (delete-region
   (point)
   (progn
     (forward-word arg)
     (point))))

(defun ruthless-backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument, do this that many times.
This command does not push text to `kill-ring'."
  (interactive "p")
  (ruthless-delete-word (- arg)))

(defun ruthless-delete-line ()
  "Delete text from current position to end of line char.
This command does not push text to `kill-ring'."
  (interactive)
  (delete-region
   (point)
   (progn (end-of-line 1) (point)))
  (delete-char 1))

(defun ruthless-delete-line-backward ()
  "Delete text between the beginning of the line to the cursor position.
This command does not push text to `kill-ring'."
  (interactive)
  (let (p1 p2)
    (setq p1 (point))
    (beginning-of-line 1)
    (setq p2 (point))
    (delete-region p1 p2)))

;; ; bind them to emacs's default shortcut keys:
;; (global-set-key (kbd "C-S-k") 'ruthless-delete-line-backward) ; Ctrl+Shift+k
;; (global-set-key (kbd "C-k") 'ruthless-delete-line)
;; (global-set-key (kbd "M-d") 'ruthless-delete-word)
;; (global-set-key "\M-\d" 'ruthless-backward-delete-word) ; Alt+Backspace


;; ; Can't get this to even register as a function
;; (defun ruthless-mode (arg)
;;   (if (string= arg "y")
;;       (progn
;;         (global-set-key (kbd "C-S-k") 'ruthless-delete-line-backward) ; Ctrl+Shift+k
;;         (global-set-key (kbd "C-k") 'ruthless-delete-line)
;;         (global-set-key (kbd "M-d") 'ruthless-delete-word)
;;         (global-set-key "\M-\d" 'ruthless-backward-delete-word) ; Alt+Backspace
;;         )
;;     (if (string= arg "n")
;;         (message "Disabling ruthless mode")
;;       (message "Invalid argument")
;;       )
;;     )
;;   )


;;; Do Re Mi for easier adjustments to window size
;; (load "~/.emacs.d/elisp/doremi")

;; (load "~/.emacs.d/elisp/doremi-cmd")

;; (load "~/.emacs.d/elisp/faces+")
;; (load "~/.emacs.d/elisp/frame-fns")
;; (load "~/.emacs.d/elisp/hexrgb")
;; (load "~/.emacs.d/elisp/doremi-frm")


;;; Fix PS1 color for shell
(require 'comint)
(set-face-attribute 'comint-highlight-prompt nil
		    :inherit nil)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;;; Open shell in current window
(push (cons "\\*shell\\*" display-buffer--same-window-action) display-buffer-alist)

;;; Open Jenkinsfile in groovy-mode
;; (add-to-list 'auto-mode-alist '("Jenkinsfile" . groovy-mode))

;;; Quick function to swap to 2 space indent in local json/javascript file
(defun js-indent (n)
  "Set single json/js file's indent size"
  (interactive "nNumber of spaces: ")
  (make-local-variable 'js-indent-level)
  (setq js-indent-level n))

;;; Quick function to swap to 2 space indent in local json/javascript file
(defun jenkins-indent (n)
  "Set single json/js file's indent size"
  (interactive "nNumber of spaces: ")
  (make-local-variable 'groovy-indent-offset)
  (setq groovy-indent-offset n))

;;; change default smerge-command-prefix from C-c  ^ to C-c v
;;; https://emacs.stackexchange.com/a/16470
(setq smerge-command-prefix "\C-cv")

;;; Using legacy CC-derived groovy-mode (see https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes)
;;; C -> Java -> Groovy Style
;;; Note: M-x c-set-offset or C-c C-o will give you info about the current line's indent tag
;; (add-hook 'groovy-mode-hook
;; 	  (lambda ()
;; 	    (setq c-basic-offset 4)
;; 	    (setq indent-tabs-mode nil)
;; 	    (c-set-offset 'label '+)))


;;; indent by 2 in typescript-mode
(setq typescript-indent-level 2)
(put 'upcase-region 'disabled nil)

;;; fix for navigation keys in JetBrains terminal
(define-key key-translation-map (kbd "∫") (kbd "M-b"))
(define-key key-translation-map (kbd "ƒ") (kbd "M-f"))
(define-key key-translation-map (kbd "∂") (kbd "M-d"))
