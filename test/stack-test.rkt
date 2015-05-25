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

; stack->list
(let ([stk (make-stack)])
  (push! stk 'a)
  (check-false (stack-empty? stk))
  (check-eq? 'a (top stk))
  
  (pop! stk)
  (check-equal? (stack->list stk) '()))

; stack=?
(let ([stk123 (make-stack)]
      [stk*123 (make-stack)])
  (push*! stk*123 1 2 3)
  (push! stk123 3)
  (push! stk123 2)
  (push! stk123 1)
  (check-true (stack=? stk*123 stk123)))

; stack->string
(check-false (string=? (stack->string (stack '(1 2 3 4))) "1234"))
(check-false (string=? (stack->string (stack '(1 2 3 4))) "4321"))
(check-true (string=? (stack->string (stack '(1 2 3 4))) "(4 3 2 1)"))
(check-false (string=? (stack->string (make-stack)) ""))
(check-true (string=? (stack->string (make-stack)) "()"))

; push-dup
(let ([stk1 (stack '(1 2 3))]
      [stk2 (stack '(1 2 3))])
  (push-dup! stk2)
  (check-true (stack=? (push-dup stk1) stk2))
  (check-true (stack=? (push-dup (make-stack)) (stack '(())))))

; pop-all!
(let ([stk (stack '(1 2 3))])
  (pop-all! stk)
  (check-true (stack-empty? stk)))

; swap
(check-exn exn:fail:contract? (λ () (swap (make-stack))))
(check-exn exn:fail:contract? (λ () (swap! (make-stack))))
(let ([stk1 (stack '(1))]
      [stk2 (stack '(1 2 3))]
      [stk3 (stack '(1 2 3))])
  (swap! stk3)
  (check-exn exn:fail:contract? (λ () (swap stk1)))
  (check-true (stack=? (swap stk2) stk3)))

; push-over
(check-exn exn:fail:contract? (λ () (push-over (make-stack))))
(check-exn exn:fail:contract? (λ () (push-over! (make-stack))))
(let ([stk1 (stack '(1 2 3))]
      [stk2 (stack '(1 2 3))])
  (push-over! stk2)
  (check-true (stack=? (push-over stk1) stk2)))

; rotate
(check-exn exn:fail:contract? (λ () (rotate (make-stack))))
(check-exn exn:fail:contract? (λ () (rotate! (make-stack))))
(let ([stk1 (stack '(3 2 1))]
      [stk2 (stack '(3 2 1))])
  (rotate! stk2)
  (check-true (stack=? (rotate stk1) stk2))
  (check-true (stack=? (rotate stk1) (stack '(1 3 2)))))

; reverse-rotate
; same as rotate twice
(check-exn exn:fail:contract? (λ () (reverse-rotate (make-stack))))
(check-exn exn:fail:contract? (λ () (reverse-rotate! (make-stack))))
(let ([stk1 (stack '(1 2 3 4 5 6))]
      [stk2 (stack '(1 2 3 4 5 6))]
      [stk3 (stack '(1 2 3 4 5 6))]
      [stk4 (stack '(1 2 3 4 5 6))])
  (reverse-rotate! stk2)
  (check-true (stack=? (reverse-rotate stk1) stk2))
  (check-true (stack=? (reverse-rotate stk1) (rotate (rotate stk3))))
  (rotate! stk4)
  (rotate! stk4)
  (check-true (stack=? stk2 stk4)))

; pop-nip
(check-exn exn:fail:contract? (λ () (pop-nip (make-stack))))
(check-exn exn:fail:contract? (λ () (pop-nip! (make-stack))))
(let ([stk1 (stack '(1 2 3))]
      [stk2 (stack '(1 2 3))])
  (pop-nip! stk2)
  (check-true (stack=? (pop-nip stk1) stk2))
  (check-true (stack=? (pop-nip stk1) (stack '(1 3)))))

; push-tuck
(check-exn exn:fail:contract? (λ () (push-tuck (make-stack))))
(check-exn exn:fail:contract? (λ () (push-tuck! (make-stack))))
(let ([stk1 (stack '(1 2 3))]
      [stk2 (stack '(1 2 3))])
  (push-tuck! stk2)
  (check-true (stack=? (push-tuck stk1) stk2)))

; push-pick
(check-exn exn:fail:contract? (λ () (push-pick (make-stack) 0)))
(check-exn exn:fail:contract? (λ () (push-pick (make-stack) 2)))
(check-exn exn:fail:contract? (λ () (push-pick! (make-stack) 0)))
(check-exn exn:fail:contract? (λ () (push-pick! (make-stack) 2)))
(let ([stk1 (stack '(1 2 3))]
      [stk2 (stack '(1 2 3))])
  (push-pick! stk2 1)
  (check-true (stack=? (push-pick stk1 1) stk2)))

; roll
; used in rotate and reverse-rotate
(check-exn exn:fail:contract? (λ () (roll (make-stack) 0)))
(check-exn exn:fail:contract? (λ () (roll (make-stack) 2)))
(check-exn exn:fail:contract? (λ () (roll! (make-stack) 0)))
(check-exn exn:fail:contract? (λ () (roll! (make-stack) 2)))
(let ([stk1 (stack '(1 2 3))]
      [stk2 (stack '(1 2 3))])
  (roll! stk2 2)
  (check-true (stack=? (roll stk1 2) stk2))
  (check-true (stack=? (roll stk1 2) (rotate stk1)))
  (check-true (stack=? (rotate stk1) stk2))
  (check-true (stack=? (reverse-rotate stk1) (rotate stk2))))
