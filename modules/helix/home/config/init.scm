(require (prefix-in helix. "helix/configuration.scm"))




(helix.register-lsp-call-handler
  "metals"
  "window/showMessageRequest"
  (lambda (args) 
    (define type (hash-try-get args 'type))
    (define message (hash-try-get args 'message))
    (define actions (hash-try-get args 'actions))
    (log::info! (to-string args))
    (log::info! (to-string type))
    (log::info! (to-string message))
    (log::info! (to-string actions))
    )
)
