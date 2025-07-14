; https://github.com/godalming123/select-project.hx/blob/main/helpers.scm
(provide remove-char)
(provide insert-char)
(provide sublist)
(provide filter)
(provide map-index)
(provide exec-tmux-popup)

(define (remove-char str index-to-remove-at)
  (define str-len (string-length str))
  (if (or (< index-to-remove-at 0) (>= index-to-remove-at str-len))
      str
      (string-append (substring str 0 index-to-remove-at)
                     (substring str (+ index-to-remove-at 1) str-len))))

(define (insert-char str char index-to-insert-at)
  (string-append (substring str 0 index-to-insert-at)
                 (list->string (list char))
                 (substring str index-to-insert-at (string-length str))))

(define (sublist lst start length) (take (drop lst start) length))

(define (filter lst check) (filter-loop '() lst check))
(define (filter-loop out listLeft check)
  (if (empty? listLeft)
      out
      (begin
        (define firstElem (first listLeft))
        (filter-loop (if (check firstElem) (append out (list firstElem)) out)
                     (cdr listLeft)
                     check))))

(define (map-index lst func)
  (define index (box 0))
  (map (lambda (elem)
               (define indexVal (unbox index))
               (set-box! index (+ indexVal 1))
               (func indexVal elem)) lst))


(define (with-stdout-piped command)
  (set-piped-stdout! command)
  command)

(define (exec-tmux-popup prog)
  (define cmd
    (string-append
     "pipe=$(mktemp -u); mkfifo \"$pipe\"; "
     "tmux display-popup -E \"printf '%s\\n' \\$(" prog ") >$pipe\" & "
     "read -r answer < \"$pipe\"; rm \"$pipe\"; echo \"$answer\""))
  (~> (command "bash" `("-c"  ,cmd)) ( with-stdout-piped ) ( spawn-process ) ( Ok->value ) ( wait->stdout ) ( Ok->value )))
