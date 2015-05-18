(module typed-stack
  typed/racket
  ; typed-stack.rkt
  ; LIFO stack
  ; "top" refers to the beginning of the list
  ; "bottom" or "end" refers to the end of the list
  (provide (all-defined-out))
  
  ; all functional procedures can take either im/mutable stack types,
  ; but the procedures that mutate state may only take mutable stacks
  ; (obviously)
  (struct stack ([contents : (Listof Any)]) #:mutable)
  (struct stack-immutable ([contents : (Listof Any)]))
  
  (define-type stack+immutable (U stack stack-immutable))
  
  ; produces an empty, mutable stack
  (define (make-stack) : stack
    (stack empty))
  
  ; produces an empty, immutable stack
  (define (make-immutable-stack) : stack-immutable
    (stack-immutable empty))
  
  (define (stack-empty? [stk : stack+immutable]) : Boolean
    (if (stack? stk)
        (empty? (stack-contents stk))
        (empty? (stack-immutable-contents stk))))
  
  (define (stack-length [stk : stack+immutable]) : Nonnegative-Integer
    (if (stack? stk)
        (length (stack-contents stk))
        (length (stack-immutable-contents stk))))
  
  (define (stack=? [stk1 : stack+immutable] [stk2 : stack+immutable]) : Boolean
    (or (and (stack? stk1) (stack? stk2)
             (equal? (stack-contents stk1) (stack-contents stk2)))
        (and (stack-immutable? stk1) (stack-immutable? stk2)
             (equal? (stack-immutable-contents stk1) (stack-immutable-contents stk2)))))
  
  (define (top [stk : stack+immutable]) : Any
    (cond [(stack-empty? stk) empty]
          [else
           (first (if (stack? stk)
                      (stack-contents stk)
                      (stack-immutable-contents stk)))]))
  
  (define (stack->list [stk : stack+immutable]) : (Listof Any)
    (if (stack? stk)
        (stack-contents stk)
        (stack-immutable-contents stk)))
  
  ; returns the popped stack
  (define (pop [stk : stack+immutable]) : stack+immutable
    (cond [(stack-empty? stk) stk]
          [else
           (if (stack? stk)
               (stack (rest (stack-contents stk)))
               (stack-immutable (rest (stack-immutable-contents stk))))]))
  
  ; returns a stack with the value pushed on top
  (define (push [stk : stack+immutable] [val : Any]) : stack+immutable
    (if (stack? stk)
        (stack (cons val (stack-contents stk)))
        (stack-immutable (cons val (stack-immutable-contents stk)))))
  
  ; push multiple values to the stack from right to left
  ; the order in the procedure call is the same as the
  ; stack order
  (define (push* [stk : stack+immutable] . lst) : stack+immutable
    (if (stack? stk)
        (stack (append lst (stack-contents stk)))
        (stack-immutable (append lst (stack-immutable-contents stk)))))
  
  (define (push-dup [stk : stack+immutable]) : stack+immutable
    (if (stack-empty? stk)
        (push stk empty)
        (push stk (first (if (stack? stk)
                             (stack-contents stk)
                             (stack-immutable-contents stk))))))
  
  ; returns a sequence to use with stacks
  (define (in-stack [stk : stack+immutable]) : (Sequenceof Any)
    (in-list (if (stack? stk)
                 (stack-contents stk)
                 (stack-immutable-contents stk))))
  
  ; procedures that mutate state be here
  
  ; pops the stack and returns the previous top
  (define (pop! [stk : stack]) : Any
    (define popped (top stk))
    (set-stack-contents! stk (cdr (stack-contents stk)))
    popped)
  
  (define (push! [stk : stack] [val : Any]) : Void
    (set-stack-contents! stk (cons val (stack-contents stk))))
  
  (define (push*! [stk : stack] . lst) : Void
    (set-stack-contents! stk (append lst (stack-contents stk))))
  
  (define (push-dup! [stk : stack]) : Void
    (if (stack-empty? stk)
        (push! stk empty)
        (push! stk (first (stack-contents stk)))))
  )
