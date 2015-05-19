(module typed-stack
  typed/racket
  ; typed-stack.rkt
  ; LIFO stack
  ; "top" refers to the beginning of the list
  ; "bottom" or "end" refers to the end of the list
  (provide (all-defined-out))
  
  (struct stack ([contents : (Listof Any)]) #:mutable)
  
  ; produces an empty, mutable stack
  (define (make-stack) : stack
    (stack empty))
  
  (define (stack->list [stk : stack]) : (Listof Any)
    (stack-contents stk))
  
  (define (stack-empty? [stk : stack]) : Boolean
    (empty? (stack->list stk)))
  
  (define (stack-length [stk : stack]) : Nonnegative-Integer
    (length (stack->list stk)))
  
  (define (stack=? [stk1 : stack] [stk2 : stack]) : Boolean
    (and (stack? stk1) (stack? stk2)
         (equal? (stack->list stk1) (stack->list stk2))))
  
  (define (top [stk : stack]) : Any
    (if (stack-empty? stk)
        empty
        (first (stack->list stk))))
  
  ; returns a sequence to use with stacks
  (define (in-stack [stk : stack]) : (Sequenceof Any)
    (in-list (stack->list stk)))
  
  ; pops the stack
  (define (pop [stk : stack]) : stack
    (if (stack-empty? stk)
        stk
        (stack (rest (stack->list stk)))))
  
  (define (pop! [stk : stack]) : Void
    (unless (stack-empty? stk)
      (set-stack-contents! stk (rest (stack->list stk)))))
  
  (define (push [stk : stack] [val : Any]) : stack
    (stack (cons val (stack->list stk))))
  
  (define (push! [stk : stack] [val : Any]) : Void
    (set-stack-contents! stk (cons val (stack->list stk))))
  
  ; push multiple values to the stack from right to left
  ; the order in the procedure call is the same as the
  ; stack order
  (define (push* [stk : stack] . lst) : stack
    (stack (append lst (stack->list stk))))
  
  (define (push*! [stk : stack] . lst) : Void
    (set-stack-contents! stk (append lst (stack->list stk))))
  
  ; push a copy of the top of the stack onto the stack
  (define (push-dup [stk : stack]) : stack
    (push stk (top stk)))
  
  (define (push-dup! [stk : stack]) : Void
    (push! stk (top stk)))
  )
