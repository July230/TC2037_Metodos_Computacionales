#lang racket

; Quicksort, un valor "pivote" se toma, los menores quedan a su izquierda y los mayores a su derecha

(define quick-sort
  (lambda (lst)
    (cond
      ((null? lst) '())
      (else (append
             (quick-sort
              (filter (lambda (n) (< n (car lst))) (cdr lst))) ; una funcion que prueba si el pibote es mayor o menor, esto es con los menores
             (list (car lst)) ; El pivote queda en medio
             (quick-sort
              (filter (lambda (n) (> n (car lst))) (cdr lst))) ; Esto es para los mayores al pivote
             )))))