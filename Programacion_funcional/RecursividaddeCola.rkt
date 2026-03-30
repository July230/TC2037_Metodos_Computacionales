#lang racket

; Recursividad terminal, programacion recursiva donde la solucion al problema se obtiene al llegar al caso base 

; Factorial
(define fact1
  (lambda (n)
    (cond
      ((= n 1) 1)
      (else (* n (fact1 (sub1 n)))))))


; Recursividad de cola

; Auxiliar de factorial
(define fact-aux
  (lambda (n acc)
    (cond
      ((= n 1) acc)
      (else (fact-aux (sub1 n) (* n acc))))))

; Factorial, esta funcion la ve el usuario
(define fact2
  (lambda (n)
    (fact-aux n 1)))

; contar elementos de una lista
(define count
  (lambda (lst)
    (cond
      ((null? lst) 0)
      (else (+ 1 (count (cdr lst)))))))

; con recursividad de cola
(define count-aux
  (lambda (lst acc)
    (cond
      ((null? lst) acc)
      (else (count-aux (cdr lst) (add1 acc))))))

(define count2
  (lambda (lst)
    (count-aux lst 0)))

; sumar los elementos de una lista
(define sum
  (lambda (lst)
    (cond
      ((null? lst) 0)
      (else (+ (car lst)
               (sum (cdr lst)))))))

; con recursion de cola
(define sum-aux
  (lambda (lst acc)
    (cond
      ((null? lst) acc)
      (else (cum-aux (cdr lst) (+ (car lst) acc))))))

(define sum2
  (lambda (lst)
    (sum-aux lst 0)))

(