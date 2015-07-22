#lang scribble/manual
@; typed-stack.scrbl
@(require (for-label typed/racket/base
                     "../main.rkt"))

@title{@bold{Typed-Stack}: A Typed Racket stack library}
@author{Lehi Toskin}

@defmodule[typed-stack]{
  @racketmodname[typed-stack] is a stack implementation written in Typed Racket
  that contains many different procedures to operate on the stack.
}

@;@table-of-contents[]

@defstruct[Stack ([contents (Listof A)]) #:mutable]{
  This is the basis of the library. The core is a list that gets manipulated
  through the various procedures. The "top" or "beginning" of the stack refers
  to the first element of the contents list, while the "bottom" or "end" of the
  stack refers to the last element of the contents list; items on the left side
  of the list are the newest and the items on the right side are the oldest.
}

@section{Procedures}

Almost every procedure has two forms: one that mutates state and a functional
counterpart. Functional versions of the procedures will return the stack as it
was modified while the procedures that mutate state will return @racket[Void].

@defproc[(make-stack [v Any] ...) (Stack A)]{
  Returns a stack of type @racket[A] containing the values @racket[v].
}

@defproc[(empty-stack) (Stack Any)]{
  Returns an empty stack.
}

@defproc[(stack->list [stk (Stack A)]) (Listof A)]{
  Takes a stack and returns a list.
}

@defproc[(stack->string [stk (Stack A)]) String]{
  Takes a stack and returns a string of the contents of the stack, starting
  from the bottom.
}

@defproc[(stack-empty? [stk (Stack A)]) Boolean]{
  Determines if the given stack is empty.
}

@defproc[(stack-length [stk (Stack A)]) Nonnegative-Integer]{
  Returns the length of the stack.
}

@defproc[(stack=? [stk1 (Stack A)] [stk2 (Stack B)]) Boolean]{
  Checks if both stacks are @racket[equal?].
}

@defproc[(top [stk (Stack A)]) A]{
  Returns the item at the top of the stack. Will fail if the stack is empty.
}

@defproc[(in-stack [stk (Stack A)]) (Sequenceof A)]{
  Returns a sequence to iterate over the items in the stack from top to bottom.
}

@deftogether[(@defproc[(pop [stk (Stack A)]) (Stack A)]
              @defproc[(pop! [stk (Stack A)]) Void])]{
  Pops the top item of the stack.
}

@deftogether[(@defproc[(push [stk (Stack A)] [val A]) (Stack A)]
              @defproc[(push! [stk (Stack A)] [val A]) Void])]{
  Pushes an item to the top of the stack.
}

@deftogether[(@defproc[(push* [stk (Stack A)] [val A] ...) (Stack A)]
              @defproc[(push*! [stk (Stack A)] [val A] ...) Void])]{
  Pushes a number of items to the stack at once. They are evaluated from right
  to left and appear in the stack as-entered.
}

@deftogether[(@defproc[(push-dup [stk (Stack A)]) (Stack A)]
              @defproc[(push-dup! [stk (Stack A)]) Void])]{
  Pushes a copy of the top item onto the stack. Will fail if
}

@defproc[(pop-all! [stk (Stack A)]) Void]{
  Pops all items from the stack.
}

@deftogether[(@defproc[(swap [stk (Stack A)]) (Stack A)]
              @defproc[(swap! [stk (Stack A)]) Void])]{
  Swaps the top two items in the stack. Will fail if
}

@deftogether[(@defproc[(push-over [stk (Stack A)]) (Stack A)]
              @defproc[(push-over! [stk (Stack A)]) Void])]{
  Pushes a copy of the second topmost item onto the stack.
}

@deftogether[(@defproc[(rotate [stk (Stack A)]) (Stack A)]
              @defproc[(rotate! [stk (Stack A)]) Void])]{
  Rotates the top three items in the stack downwards such that
  @racket[(Stack '(3 2 1))] becomes @racket[(Stack '(1 3 2))].
}

@deftogether[(@defproc[(reverse-rotate [stk (Stack A)]) (Stack A)]
              @defproc[(reverse-rotate! [stk (Stack A)]) Void])]{
  Rotates the top three items in the stack upwards such that
  @racket[(stack '(3 2 1))] becomes @racket[(stack '(2 1 3))].
}

@deftogether[(@defproc[(pop-nip [stk (Stack A)]) (Stack A)]
              @defproc[(pop-nip! [stk (Stack A)]) Void])]{
  Removes the second topmost item from the stack.
}

@deftogether[(@defproc[(push-tuck [stk (Stack A)]) (Stack A)]
              @defproc[(push-tuck! [stk (Stack A)]) Void])]{
  Swaps the top two items in the stack and then pushes a copy of the former
  top item.
}

@deftogether[(@defproc[(push-pick [stk (Stack A)]
                                  [i Nonnegative-Integer]) (Stack A)]
              @defproc[(push-pick! [stk (Stack A)]
                                   [i Nonnegative-Integer]) Void])]{
  Pushes a copy of the specified index to the top of the stack.
  The index starts at the top of the stack.
}

@deftogether[(@defproc[(roll [stk (Stack A)] [i Nonnegative-Integer]) (Stack A)]
              @defproc[(roll! [stk (Stack A)] [i Nonnegative-Integer]) Void])]{
  Removes the item from the stack at the given index and pushes it to the top
  of the stack. The index starts at the top of the stack.
}

@section{License}

The code in this package and this documentation is under the BSD 3-clause.

@verbatim{
Copyright (c) 2015, Lehi Toskin
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of typed-stack nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
}