(require (prefix-in helix. "helix/commands.scm"))
(require (prefix-in helix. "helix/configuration.scm"))
(require (prefix-in helix. "helix/components.scm"))
(require (prefix-in helix. "helix/misc.scm"))
(require-builtin helix/components)


(helix.theme "dracula")

(provide open-config)

(require (prefix-in picker. "cogs/picker.scm"))

(define open-config (lambda () (helix.open "/home/nikolaiser/.config/helix/helix.scm")))


(define test-list (list "foo" "bar" "baz" "bananas" "fuzzy-matching" "this seems to work pretty well"))

(provide test)

(define (test) (picker.select-item test-list))
