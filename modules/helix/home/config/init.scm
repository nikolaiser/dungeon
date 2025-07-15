(require (prefix-in helix. "helix/configuration.scm"))
(require (prefix-in helix. "helix/misc.scm"))

(require (prefix-in picker. "cogs/picker.scm"))
(require (prefix-in navigator. "cogs/navigator.scm"))
(require "cogs/keymaps.scm")

(require (prefix-in explorer. "cogs/explorer.scm"))

(helix.register-lsp-call-handler
  "metals"
  "window/showMessageRequest"
  (lambda (id args)
    (define type (hash-try-get args 'type))
    (define message (hash-try-get args 'message))
    (define actions (hash-try-get args 'actions))
    (define titles (map (lambda (arg) (hash-ref arg 'title)) actions))
    (picker.select-item titles (lambda (result) (helix.lsp-reply-ok "metals" id (hash 'title result))))))

(helix.define-lsp "steel-language-server" (command "steel-language-server") (args '()))

(helix.define-language "scheme"
  (formatter (command "schemat"))
  (auto-format #true)
  (language-servers '("steel-language-server")))

(helix.define-language "nix"
  (formatter (command "nixfmt-rfc-style"))
  (auto-format #true)
  (language-servers '("nil" "nixd")))

(keymap (global) (normal (C-down ":navigator.move-down")))
(keymap (global) (normal (C-up ":navigator.move-up")))
(keymap (global) (normal (C-left ":navigator.move-left")))
(keymap (global) (normal (C-right ":navigator.move-right")))

(keymap (global)
  (normal (space (e ":explorer.show-explorer"))))

(keymap (global)
  (normal (C-t ":w")))

(keymap (global)
  (normal (space (q ":qa"))))
