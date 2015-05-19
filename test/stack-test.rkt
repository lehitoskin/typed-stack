#lang typed/racket/base
; tests for typed/stack
(require "../main.rkt"
         typed/rackunit)

(assert (make-stack) stack?)
(assert (make-stack) stack-empty?)
(check-true (stack? (make-stack)))
(check-true (stack-empty? (make-stack)))
(check-equal? 0 (stack-length (make-stack)))

(check-false (stack-empty? (push (make-stack) 'a)))
(check-equal? (stack->list (pop (make-stack))) '())
(check-eq? 'a (top (push (make-stack) 'a)))

(check-true (stack=? (push* (make-stack) 1 2 3)
                     (push (push (push (make-stack) 3) 2) 1)))

(let ([stk (make-stack)])
  (push! stk 'a)
  (check-false (stack-empty? stk))
  (check-eq? 'a (top stk))
  
  (pop! stk)
  (check-equal? (stack->list stk) '()))

(let ([stk123 (make-stack)]
      [stk*123 (make-stack)])
  (push*! stk*123 1 2 3)
  (push! stk123 3)
  (push! stk123 2)
  (push! stk123 1)
  (check-true (stack=? stk*123 stk123)))
