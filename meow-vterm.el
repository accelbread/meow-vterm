;;; meow-vterm.el --- Integrate meow and vterm modes -*- lexical-binding: t; -*-

;; Copyright (C) 2022 Archit Gupta

;; Version: 1.0.0
;; Author: Archit Gupta <archit@accelbread.com>
;; Maintainer: Archit Gupta <archit@accelbread.com>
;; URL: https://github.com/accelbread/meow-vterm.el
;; Keywords: meow, vterm
;; Package-Requires: ((emacs "28.1") (meow "1.4.0"))

;; This file is not part of GNU Emacs

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

;; This package integrates meow's input modes with vterm.
;;
;; `vterm' consumes all inputs other than its exceptions, making it not
;; integrate well with meow. This package solves this by using a custom keymap
;; in normal mode with standard bindings, and using the default vterm keymap in
;; in meow insert mode.
;;
;; To use this package add `(meow-vterm-enable)' to your init.el.
;;
;; Additionally, to have minimal bindings in insert mode, add the following to
;; your init.el before vterm is loaded:
;; `(setq vterm-keymap-exceptions '("C-c"))'.

;;; Code:

(require 'meow)
(require 'vterm)

(defvar meow-vterm-normal-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "RET") #'vterm-send-return)
    map)
  "Keymap for vterm in normal mode.")

(defun meow-vterm-insert-enter ()
  "Enable vterm default binding in insert and set cursor."
  (use-local-map vterm-mode-map)
  (vterm-goto-char (point)))

(defun meow-vterm-insert-exit ()
  "Use regular bindings in normal mode."
  (use-local-map meow-vterm-normal-mode-map))

(defun meow-vterm-setup ()
  "Configure insert mode for vterm."
  (add-hook 'meow-insert-enter-hook #'meow-vterm-insert-enter nil t)
  (add-hook 'meow-insert-exit-hook #'meow-vterm-insert-exit nil t)
  (use-local-map meow-vterm-normal-mode-map))

;;;###autoload
(defun meow-vterm-enable ()
  "Enable syncing vterm keymap with current meow mode."
  (setq vterm-keymap-exceptions '("C-c"))
  (define-key vterm-mode-map (kbd "C-c ESC") #'vterm-send-escape)
  (dolist (c '((yank . vterm-yank)
               (xterm-paste . vterm-xterm-paste)
               (yank-pop . vterm-yank-pop)
               (mouse-yank-primary . vterm-yank-primary)
               (self-insert-command . vterm--self-insert)
               (beginning-of-defun . vterm-previous-prompt)
               (end-of-defun . vterm-next-prompt)))
    (define-key meow-vterm-normal-mode-map (vector 'remap (car c)) (cdr c)))
  (add-hook 'vterm-mode-hook #'meow-vterm-setup))

(provide 'meow-vterm)
;;; meow-vterm.el ends here
