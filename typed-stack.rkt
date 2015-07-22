(module typed-stack
  typed/racket
  ; typed-stack.rkt
  ; LIFO stack
  ; "top" refers to the beginning of the list
  ; "bottom" or "end" refers to the end of the list
  (provide make-stack empty-stack stack->list stack->string
           stack-empty? stack-length stack=? top in-stack
           pop pop! push push! push* push*! push-dup push-dup!
           pop-all! swap swap! push-over push-over!
           rotate rotate! reverse-rotate reverse-rotate!
           pop-nip pop-nip! push-tuck push-tuck!
           push-pick push-pick! roll roll! Stack
           (rename-out [Stack? stack?]))
  
  (struct (A) Stack ([contents : (Listof A)]) #:mutable)
  
  ; produces a mutable stack
  (: make-stack (All (A) (A * -> (Stack A))))
  (define (make-stack . lst)
    (Stack lst))
  
  (: empty-stack (-> (Stack Any)))
  (define (empty-stack)
    (Stack '()))
  
  ; creates a list from the stack as-is
  (: stack->list (All (A) ((Stack A) -> (Listof A))))
  (define (stack->list stk)
    (Stack-contents stk))
  
  ; builds a string representation of the stack
  ; with ordering from bottom to top
  (: stack->string (All (A) ((Stack A) -> String)))
  (define (stack->string stk)
    (with-output-to-string (λ () (printf "~a" (reverse (stack->list stk))))))
  
  (: stack-empty? (All (A) ((Stack A) -> Boolean)))
  (define (stack-empty? stk)
    (empty? (stack->list stk)))
  
  (: stack-length (All (A) ((Stack A) -> Nonnegative-Integer)))
  (define (stack-length stk)
    (length (stack->list stk)))
  
  (: stack=? (All (A B) ((Stack A) (Stack B) -> Boolean)))
  (define (stack=? stk1 stk2)
    (equal? (stack->list stk1) (stack->list stk2)))
  
  (: top (All (A) ((Stack A) -> A)))
  (define (top stk)
    (if (stack-empty? stk)
        (raise-argument-error 'top "stack-length >= 1" 0)
        (first (stack->list stk))))
  
  ; returns a sequence to use with stacks
  (: in-stack (All (A) ((Stack A) -> (Sequenceof A))))
  (define (in-stack stk)
    (in-list (stack->list stk)))
  
  ; pops the stack
  (: pop (All (A) ((Stack A) -> (Stack A))))
  (define (pop stk)
    (if (stack-empty? stk)
        stk
        (Stack (rest (stack->list stk)))))
  
  (: pop! (All (A) ((Stack A) -> Void)))
  (define (pop! stk)
    (unless (stack-empty? stk)
      (set-Stack-contents! stk (rest (stack->list stk)))))
  
  (: push (All (A) ((Stack A) A -> (Stack A))))
  (define (push stk val)
    (Stack (cons val (stack->list stk))))
  
  (: push! (All (A) ((Stack A) A -> Void)))
  (define (push! stk val)
    (set-Stack-contents! stk (cons val (stack->list stk))))
  
  ; push multiple values to the stack from right to left
  ; the order in the procedure call is the same as the
  ; stack order
  (: push* (All (A) ((Stack A) A * -> (Stack A))))
  (define (push* stk . lst)
    (Stack (append lst (stack->list stk))))
  
  (: push*! (All (A) ((Stack A) A * -> Void)))
  (define (push*! stk . lst)
    (set-Stack-contents! stk (append lst (stack->list stk))))
  
  ; push a copy of the top of the stack onto the stack
  (: push-dup (All (A) ((Stack A) -> (Stack A))))
  (define (push-dup stk)
    (push stk (top stk)))
  
  (: push-dup! (All (A) ((Stack A) -> Void)))
  (define (push-dup! stk)
    (push! stk (top stk)))
  
  ; removes all items from the stack
  (: pop-all! (All (A) ((Stack A) -> Void)))
  (define (pop-all! stk)
    (unless (stack-empty? stk)
      (set-Stack-contents! stk empty)))
  
  ; swaps the location of the two topmost items
  (: swap (All (A) ((Stack A) -> (Stack A))))
  (define (swap stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'swap "stack-length >= 2" (stack-length stk))]
          [else
           (define one (top stk))
           (define two (top (pop stk)))
           (push (push (pop (pop stk)) one) two)]))
  
  (: swap! (All (A) ((Stack A) -> Void)))
  (define (swap! stk)
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
  (: push-over (All (A) ((Stack A) -> (Stack A))))
  (define (push-over stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-over "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (define two (top (pop stk)))
           (push stk two)]))
  
  (: push-over! (All (A) ((Stack A) -> Void)))
  (define (push-over! stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-over! "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (define two (top (pop stk)))
           (push! stk two)]))
  
  ; rotates the top three items downward
  ; (stack '(3 2 1)) -> (stack '(1 3 2))
  (: rotate (All (A) ((Stack A) -> (Stack A))))
  (define (rotate stk)
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'rotate "stack-length >= 3" (stack-length stk))]
          [else (roll stk 2)]))
  
  (: rotate! (All (A) ((Stack A) -> Void)))
  (define (rotate! stk)
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'rotate! "stack-length >= 3" (stack-length stk))]
          [else (roll! stk 2)]))
  
  ; rotates the top three items upward
  ; (stack '(3 2 1)) -> (stack '(2 1 3))
  ; equivalent to rotating twice
  (: reverse-rotate (All (A) ((Stack A) -> (Stack A))))
  (define (reverse-rotate stk)
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'reverse-rotate "stack-length >= 3"
                                 (stack-length stk))]
          [else (roll (roll stk 2) 2)]))
  
  (: reverse-rotate! (All (A) ((Stack A) -> Void)))
  (define (reverse-rotate! stk)
    (cond [(< (stack-length stk) 3)
           (raise-argument-error 'reverse-rotate! "stack-length >= 3"
                                 (stack-length stk))]
          [else
           (roll! stk 2)
           (roll! stk 2)]))
  
  ; removes the second topmost item from the stack
  (: pop-nip (All (A) ((Stack A) -> (Stack A))))
  (define (pop-nip stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'pop-nip "stack-length >= 2" (stack-length stk))]
          [else
           (define val (top stk))
           (push (pop (pop stk)) val)]))
  
  (: pop-nip! (All (A) ((Stack A) -> Void)))
  (define (pop-nip! stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'pop-nip! "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (define val (top stk))
           (pop! stk)
           (pop! stk)
           (push! stk val)]))
  
  ; swaps the top two items and then pushes a copy of the former top item
  (: push-tuck (All (A) ((Stack A) -> (Stack A))))
  (define (push-tuck stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-tuck "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (push-over (swap stk))]))
  
  (: push-tuck! (All (A) ((Stack A) -> Void)))
  (define (push-tuck! stk)
    (cond [(< (stack-length stk) 2)
           (raise-argument-error 'push-tuck! "stack-length >= 2"
                                 (stack-length stk))]
          [else
           (swap! stk)
           (push-over! stk)]))
  
  ; pushes a copy of the specified index
  (: push-pick (All (A) ((Stack A) Nonnegative-Integer -> (Stack A))))
  (define (push-pick stk i)
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'push-pick! (format "i < ~a" stk-len) i)]
          [else
           (define val (list-ref (stack->list stk) i))
           (push stk val)]))
  
  (: push-pick! (All (A) ((Stack A) Nonnegative-Integer -> Void)))
  (define (push-pick! stk i)
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'push-pick! (format "i < ~a" stk-len) i)]
          [else
           (define val (list-ref (stack->list stk) i))
           (push! stk val)]))
  
  ; removes the item at the index and pushes to the top of the stack
  (: roll (All (A) ((Stack A) Nonnegative-Integer -> (Stack A))))
  (define (roll stk i)
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'roll (format "i < ~a" stk-len) i)]
          [else
           (define lst (stack->list stk))
           (define val (list-ref lst i))
           (define-values (a b) (split-at lst i))
           (push (Stack (append a (cdr b))) val)]))
  
  (: roll! (All (A) ((Stack A) Nonnegative-Integer -> Void)))
  (define (roll! stk i)
    (define stk-len (stack-length stk))
    (cond [(>= i stk-len)
           (raise-argument-error 'roll! (format "i < ~a" stk-len) i)]
          [else
           (define lst (stack->list stk))
           (define val (list-ref lst i))
           (define-values (a b) (split-at lst i))
           (set-Stack-contents! stk (cons val (append a (rest b))))]))
  )
