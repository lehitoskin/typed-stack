#lang typed/racket/base
; tests for typed/stack
(require "../main.rkt"
         typed/rackunit)

(assert (empty-stack) stack?)
(assert (empty-stack) stack-empty?)
(check-true (stack? (empty-stack)))
(check-true (stack-empty? (empty-stack)))
(check-equal? 0 (stack-length (empty-stack)))

(check-false (stack-empty? (push (empty-stack) 'a)))
(check-equal? (stack->list (pop (empty-stack))) '())
(check-eq? 'a (top (push (empty-stack) 'a)))

; stack->list
(let ([stk (empty-stack)])
  (push! stk 'a)
  (check-false (stack-empty? stk))
  (check-eq? 'a (top stk))
  
  (pop! stk)
  (check-equal? (stack->list stk) '()))

; stack=? and push*
(let ([stk123 (empty-stack)]
      [stk*123 (empty-stack)])
  (check-true (stack=? (push* (empty-stack) 1 2 3)
                       (push (push (push (empty-stack) 3) 2) 1)))
  (push*! stk*123 1 2 3)
  (push! stk123 3)
  (push! stk123 2)
  (push! stk123 1)
  (check-true (stack=? stk*123 stk123))
  (check-false (stack=? (make-stack 'a 'b 'c) (make-stack 1 2 3)))
  (check-true (stack=? (push* (make-stack 1 2 3) 4 5 6)
                       (make-stack 4 5 6 1 2 3))))

; stack->string
(check-false (string=? (stack->string (make-stack 1 2 3 4)) "1234"))
(check-false (string=? (stack->string (make-stack 1 2 3 4)) "4321"))
(check-true (string=? (stack->string (make-stack 1 2 3 4)) "(4 3 2 1)"))
(check-false (string=? (stack->string (empty-stack)) ""))
(check-true (string=? (stack->string (empty-stack)) "()"))

; push-dup
(let ([stk1 : (Stack Integer) (make-stack 1 2 3)]
      [stk2 : (Stack Integer) (make-stack 1 2 3)])
  (push-dup! stk2)
  (check-true (stack=? (push-dup stk1) stk2))
  (check-true (stack=? (push-dup (make-stack 1 2 3)) (make-stack 1 1 2 3))))

; pop-all!
(let ([stk (make-stack 1 2 3)])
  (pop-all! stk)
  (check-true (stack-empty? stk)))

; swap
(check-exn exn:fail:contract? (λ () (swap (empty-stack))))
(check-exn exn:fail:contract? (λ () (swap! (empty-stack))))
(let ([stk1 (make-stack 1)]
      [stk2 (make-stack 1 2 3)]
      [stk3 (make-stack 1 2 3)])
  (swap! stk3)
  (check-exn exn:fail:contract? (λ () (swap stk1)))
  (check-true (stack=? (swap stk2) stk3)))

; push-over
(check-exn exn:fail:contract? (λ () (push-over (empty-stack))))
(check-exn exn:fail:contract? (λ () (push-over! (empty-stack))))
(let ([stk1 (make-stack 1 2 3)]
      [stk2 (make-stack 1 2 3)])
  (push-over! stk2)
  (check-true (stack=? (push-over stk1) stk2)))

; rotate
(check-exn exn:fail:contract? (λ () (rotate (empty-stack))))
(check-exn exn:fail:contract? (λ () (rotate! (empty-stack))))
(let ([stk1 (make-stack 3 2 1)]
      [stk2 (make-stack 3 2 1)])
  (rotate! stk2)
  (check-true (stack=? (rotate stk1) stk2))
  (check-true (stack=? (rotate stk1) (make-stack 1 3 2))))

; reverse-rotate
; same as rotate twice
(check-exn exn:fail:contract? (λ () (reverse-rotate (empty-stack))))
(check-exn exn:fail:contract? (λ () (reverse-rotate! (empty-stack))))
(let ([stk1 (make-stack 1 2 3 4 5 6)]
      [stk2 (make-stack 1 2 3 4 5 6)]
      [stk3 (make-stack 1 2 3 4 5 6)]
      [stk4 (make-stack 1 2 3 4 5 6)])
  (reverse-rotate! stk2)
  (check-true (stack=? (reverse-rotate stk1) stk2))
  (check-true (stack=? (reverse-rotate stk1) (rotate (rotate stk3))))
  (rotate! stk4)
  (rotate! stk4)
  (check-true (stack=? stk2 stk4)))

; pop-nip
(check-exn exn:fail:contract? (λ () (pop-nip (empty-stack))))
(check-exn exn:fail:contract? (λ () (pop-nip! (empty-stack))))
(let ([stk1 (make-stack 1 2 3)]
      [stk2 (make-stack 1 2 3)])
  (pop-nip! stk2)
  (check-true (stack=? (pop-nip stk1) stk2))
  (check-true (stack=? (pop-nip stk1) (make-stack 1 3))))

; push-tuck
(check-exn exn:fail:contract? (λ () (push-tuck (empty-stack))))
(check-exn exn:fail:contract? (λ () (push-tuck! (empty-stack))))
(let ([stk1 (make-stack 1 2 3)]
      [stk2 (make-stack 1 2 3)])
  (push-tuck! stk2)
  (check-true (stack=? (push-tuck stk1) stk2)))

; push-pick
(check-exn exn:fail:contract? (λ () (push-pick (empty-stack) 0)))
(check-exn exn:fail:contract? (λ () (push-pick (empty-stack) 2)))
(check-exn exn:fail:contract? (λ () (push-pick! (empty-stack) 0)))
(check-exn exn:fail:contract? (λ () (push-pick! (empty-stack) 2)))
(let ([stk1 (make-stack 1 2 3)]
      [stk2 (make-stack 1 2 3)])
  (push-pick! stk2 1)
  (check-true (stack=? (push-pick stk1 1) stk2)))

; roll
; used in rotate and reverse-rotate
(check-exn exn:fail:contract? (λ () (roll (empty-stack) 0)))
(check-exn exn:fail:contract? (λ () (roll (empty-stack) 2)))
(check-exn exn:fail:contract? (λ () (roll! (empty-stack) 0)))
(check-exn exn:fail:contract? (λ () (roll! (empty-stack) 2)))
(let ([stk1 (make-stack 1 2 3)]
      [stk2 (make-stack 1 2 3)])
  (roll! stk2 2)
  (check-true (stack=? (roll stk1 2) stk2))
  (check-true (stack=? (roll stk1 2) (rotate stk1)))
  (check-true (stack=? (rotate stk1) stk2))
  (check-true (stack=? (reverse-rotate stk1) (rotate stk2))))
