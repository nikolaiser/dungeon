(require (prefix-in helix.commands. "helix/commands.scm"))
(require-builtin helix/core/static as helix.core.static.)
(require (prefix-in helpers. "cogs/helpers.scm"))

(provide show-explorer)

(define (show-explorer)
  (define explorer-command "tmux new-session yazi --chooser-file=$pipe")
  (define current-file (helix.core.static.cx->current-file *helix.cx*))
  (define lf-cmd
    (if (and current-file (string? current-file))
      ;; current‑file is a string → tell lf to start there
      (string-append explorer-command " " current-file)
      ;; current‑file is #false → leave lf unchanged
      explorer-command))
  (define raw-result (helpers.exec-tmux-popup lf-cmd))
  (define result (trim raw-result))
  (log::info! result)
  (when (and result
         (not (string=? result ""))
         (not (string=? result "[exited]")))
    (helix.commands.open result)))
