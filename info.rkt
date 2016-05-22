#lang setup/infotab

(define name "typed-stack")
(define scribblings '(("doc/typed-stack.scrbl" ())))

(define blurb '("Typed Racket implementation of a stack."))
(define primary-file "main.rkt")
(define homepage "https://github.com/lehitoskin/typed-stack/")

(define version "0.1")
(define release-notes '("Filled out library."))

(define required-core-version "6.0.1")

(define deps '("base"
               "typed-racket-more"
               "typed-racket-lib"
               "scribble-lib"))
(define build-deps '("typed-racket-doc"
                     "racket-doc"))
