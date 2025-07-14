(require (prefix-in helix.commands. "helix/commands.scm"))
(require-builtin helix/core/static as helix.core.static.)
(require (prefix-in helpers. "cogs/helpers.scm"))

(provide show-explorer)

(define (show-explorer) 
  (define current-file (helix.core.static.cx->current-file *helix.cx*))
  (log::info! current-file)
  (define lf-cmd
    (if (and current-file (string? current-file))
        ;; current‑file is a string → tell lf to start there
        (string-append "xplr " current-file)
        ;; current‑file is #false → leave lf unchanged
        "xplr"))
  (define raw-result (helpers.exec-tmux-popup lf-cmd))
  (define result (trim raw-result))
    (when (and result                              
               (not (string=? result "")))         
      (helix.commands.open result)))
