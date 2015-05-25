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
  
  ; creates a list from the stack as-is
  (define (stack->list [stk : stack]) : (Listof Any)
    (stack-contents stk))
  
  ; builds a string representation of the stack
  ; with ordering from bottom to top
  (define (stack->string [stk : stack]) : String
    (with-output-to-string (λ () (printf "~a" (reverse (stack->list stk))))))
  
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
  
  ; removes all items from the stack
  (define (pop-all! [stk : stack]) : Void
    (unless (stack-empty? stk)
      (set-stack-contents! stk empty)))
  
  ; swaps the location of the two topmost items
  (define (swap [stk : stack]) : stack
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'swap "stack-length >= 2" (stack-length stk))]
          [else
           (define one (top stk))
           (define two (top (pop stk)))
           (push (push (pop (pop stk)) one) two)]))
  
  (define (swap! [stk : stack]) : Void
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'swap! "stack-length >= 2" (stack-length stk))]
          [else
           (define one (top stk))
           (define two (top (pop stk)))
           (pop! stk)
           (pop! stk)
           (push! stk one)
           (push! stk two)]))
  
  ; push a copy of the second topmost item onto the stack
  (define (push-over [stk : stack]) : stack
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-over "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (define two (top (pop stk)))
           (push stk two)]))
  
  (define (push-over! [stk : stack]) : Void
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-over! "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (define two (top (pop stk)))
           (push! stk two)]))
  
  ; rotates the top three items downward
  ; (stack '(3 2 1)) -> (stack '(1 3 2))
  (define (rotate [stk : stack]) : stack
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'rotate "stack-length >= 3" (stack-length stk))]
          [else (roll stk 2)]))
  
  (define (rotate! [stk : stack]) : Void
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'rotate! "stack-length >= 3" (stack-length stk))]
          [else (roll! stk 2)]))
  
  ; rotates the top three items upward
  ; (stack '(3 2 1)) -> (stack '(2 1 3))
  ; equivalent to rotating twice
  (define (reverse-rotate [stk : stack]) : stack
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'reverse-rotate "stack-length >= 3"
                                 (stack-length stk))]
          [else (roll (roll stk 2) 2)]))
  
  (define (reverse-rotate! [stk : stack]) : Void
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'reverse-rotate! "stack-length >= 3"
                                 (stack-length stk))]
          [else
           (roll! stk 2)
           (roll! stk 2)]))
  
  ; removes the second topmost item from the stack
  (define (pop-nip [stk : stack]) : stack
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'pop-nip "stack-length >= 2" (stack-length stk))]
          [else
           (define val (top stk))
           (push (pop (pop stk)) val)]))
  
  (define (pop-nip! [stk : stack]) : Void
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'pop-nip! "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (define val (top stk))
           (pop! stk)
           (pop! stk)
           (push! stk val)]))
  
  ; swaps the top two items and then pushes a copy of the former top item
  (define (push-tuck [stk : stack]) : stack
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-tuck "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (push-over (swap stk))]))
  
  (define (push-tuck! [stk : stack]) : Void
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-tuck! "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (swap! stk)
           (push-over! stk)]))
  
  ; pushes a copy of the specified index
  (define (push-pick [stk : stack] [i : Index]) : stack
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'push-pick! (format "i < ~a" stk-len) i)]
          [else
           (define val (list-ref (stack->list stk) i))
           (push stk val)]))
  
  (define (push-pick! [stk : stack] [i : Index]) : Void
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'push-pick! (format "i < ~a" stk-len) i)]
          [else
           (define val (list-ref (stack->list stk) i))
           (push! stk val)]))
  
  ; removes the item at the index and pushes to the top of the stack
  (define (roll [stk : stack] [i : Index]) : stack
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'roll (format "i < ~a" stk-len) i)]
          [else
           (define lst (stack->list stk))
           (define val (list-ref lst i))
           (define-values (a b) (split-at lst i))
           (push (stack (append a (cdr b))) val)]))
  
  (define (roll! [stk : stack] [i : Index]) : Void
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'roll! (format "i < ~a" stk-len) i)]
          [else
           (define lst (stack->list stk))
           (define val (list-ref lst i))
           (define-values (a b) (split-at lst i))
           (set-stack-contents! stk (cons val (append a (rest b))))]))
  )
