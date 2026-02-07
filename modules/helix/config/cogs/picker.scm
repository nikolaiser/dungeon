; https://github.com/godalming123/select-project.hx/blob/main/main.scm
(require-builtin helix/components as helix.components.)
(require (prefix-in helix.misc. "helix/misc.scm"))
(require (prefix-in helpers. "cogs/helpers.scm"))

(provide select-item)

(define fzf-command "fzf")

(struct Picker (
                search-query
                cursor-position-in-search-query
                items
                fuzzy-matched-items
                selected-index
                callback))

(define (get-selected-index state) (unbox (Picker-selected-index state)))

(define (get-picker-geometry rect)
  (define available-height (- (helix.components.area-height rect) 2))
  (define horizontal-padding (round (/ (helix.components.area-width rect) 15)))
  (define vertical-padding (round (/ available-height 15)))
  (helix.components.area horizontal-padding
    vertical-padding
    (- (helix.components.area-width rect) (* 2 horizontal-padding))
    (- available-height (* 2 vertical-padding))))

(define (render-picker state rect frame)
  (define normal-style (helix.components.theme-scope *helix.cx* "ui.text"))
  (define selected-style (helix.components.theme-scope *helix.cx* "ui.text.focus"))
  (define outer-area (get-picker-geometry rect))
  (define inner-area-x (+ (helix.components.area-x outer-area) 1))
  (define inner-area-y (+ (helix.components.area-y outer-area) 1))
  (define inner-height (- (helix.components.area-height outer-area) 4))
  (define inner-width (- (helix.components.area-width outer-area) 2))
  (define selected-index (get-selected-index state))
  (define first-rendered-item-index (- selected-index (modulo selected-index inner-height)))
  (helix.components.buffer/clear frame outer-area)
  (helix.components.block/render frame outer-area (helix.components.make-block (helix.components.theme->bg *helix.cx*) (helix.components.theme->bg *helix.cx*) "all" "plain"))

  (helix.components.block/render frame (helix.components.area inner-area-x inner-area-y inner-width 2) (helix.components.make-block (helix.components.theme->bg *helix.cx*) (helix.components.theme->bg *helix.cx*) "bottom" "plain"))
  (helix.components.frame-set-string! frame (+ inner-area-x 1) inner-area-y (unbox (Picker-search-query state)) normal-style)

  (helpers.map-index
    (helpers.sublist (unbox (Picker-fuzzy-matched-items state)) first-rendered-item-index inner-height)
    (lambda (index elem)
      (define x (+ (helix.components.area-x outer-area) 1))
      (define y (+ (helix.components.area-y outer-area) index 3))
      (define selected (equal? (+ index first-rendered-item-index) selected-index))
      (when (and selected (helix.components.Color? (helix.components.style->bg selected-style)))
        (helix.components.buffer/clear-with frame (helix.components.area x y inner-width 1) selected-style))
      (helix.components.frame-set-string! frame (+ x 1) y (string-append (if selected "> " "  ") elem) (if selected selected-style normal-style)))))

(define (get-picker-cursor-position state rect)
  (define block-area (get-picker-geometry rect))
  (helix.components.position (+ (helix.components.area-y block-area) 1)
    (+ (helix.components.area-x block-area) 2 (unbox (Picker-cursor-position-in-search-query state)))))

(define (set-selected-index-wrapping state new-selected-index)
  (set-box! (Picker-selected-index state)
    (modulo new-selected-index (length (unbox (Picker-fuzzy-matched-items state))))))

(define (set-cursor-pos state new-cursor-pos)
  (define new-cursor-pos-constrained (max 0 (min new-cursor-pos (string-length (unbox (Picker-search-query state))))))
  (set-box! (Picker-cursor-position-in-search-query state) new-cursor-pos-constrained))

(define (set-search-query state new-search-query)
  (set-box! (Picker-search-query state) new-search-query)
  (set-box! (Picker-fuzzy-matched-items state)
    (fuzzy-match new-search-query
      (Picker-items state))))

(define (handle-picker-event state event)
  (define char (helix.components.key-event-char event))
  (define selected-index (get-selected-index state))
  (define cursor-pos (unbox (Picker-cursor-position-in-search-query state)))
  (define search-query-len (string-length (unbox (Picker-search-query state))))
  (cond [(helix.components.key-event-escape? event) helix.components.event-result/close]
    [(helix.components.key-event-enter? event) (begin
                                                (define result (list-ref (unbox (Picker-fuzzy-matched-items state)) selected-index))
                                                (define callback (Picker-callback state))
                                                (callback result)

                                                helix.components.event-result/close)]
    [else (begin
           (cond [(helix.components.key-event-up? event) (set-selected-index-wrapping state (- selected-index 1))]
             [(helix.components.key-event-down? event) (set-selected-index-wrapping state (+ selected-index 1))]
             [(helix.components.key-event-right? event) (set-cursor-pos state (+ cursor-pos 1))]
             [(helix.components.key-event-left? event) (set-cursor-pos state (- cursor-pos 1))]
             [(helix.components.key-event-home? event) (set-cursor-pos state 0)]
             ;[(key-event-end? event) (set-cursor-pos state search-query-len)] ; for some reason, `key-event-end?` is not a function
             [(helix.components.key-event-backspace? event)
               (begin (set-search-query state (helpers.remove-char (unbox (Picker-search-query state)) (- cursor-pos 1)))
                 (set-cursor-pos state (- cursor-pos 1)))]
             [(char? char)
               (begin (set-search-query state (helpers.insert-char (unbox (Picker-search-query state)) char cursor-pos))
                 (set-cursor-pos state (+ cursor-pos 1)))])
           helix.components.event-result/consume)]))

;;@doc
;; Shows all of the projects in a picker where selecting a project sets the working directory to that projects directory.
(define (select-item items callback)
  (define picker-state (Picker (box "") (box 0) items (box items) (box 0) callback))
  (helix.misc.push-component! (helix.components.new-component!
                               "Picker"
                               picker-state
                               render-picker
                               (hash "handle_event" handle-picker-event "cursor" get-picker-cursor-position))))
