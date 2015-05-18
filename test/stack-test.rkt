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
(check-not-equal? (pop (make-stack)) '())
(check-eq? 'a (top (push (make-stack) 'a)))

(check-true (stack=? (push* (make-stack) 1 2 3)
                     (push (push (push (make-stack) 3) 2) 1)))
