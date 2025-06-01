(require (prefix-in helix. "helix/commands.scm"))

(helix.theme "dracula")

(provide open-config)

(define open-config (lambda () (helix.open "/home/nikolaiser/.config/helix/helix.scm")))
