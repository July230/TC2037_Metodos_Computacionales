#lang racket

; Ian Julián Estrada Castro

; arg-swap
(define (args-swap f)
  (lambda (x y)
    (f y x)))

; there-exists-one?
(define (there-exists-one? pred lst)
      (= 1 (count pred lst))) ; En el momento en el que encuentre un elemento acorde a la condicion, devuelve #t

; linear-search
(define (linear-search lst x eq-fun)
  (linear-search-helper lst x eq-fun 0))

(define (linear-search-helper lst x eq-fun i)
    (cond
      ((null? lst) #f)
      ((eq-fun (car lst) x) i)
      (else (linear-search-helper (cdr lst) x eq-fun (+ i 1)))))

