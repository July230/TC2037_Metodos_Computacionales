#lang racket

(define lst1 '(1 2 3 4))

(define lst2 '(a (b c)))

;; count: los (list of symbols) => number ;Contar los elementos de una lista

(define countE
  (lambda (lst)
    (cond
      ((null? lst) 0)
      (else (+ 1 (countE (cdr lst)))))))

;; sum: lon (list of numbers) => number; Sumar todos los elementos de una lista
(define sum
  (lambda (lst)
    (cond
      ((null? lst) 0)
      (else (+ (car lst)
               (sum (cdr lst)))))))

;; count-even: lon => number
(define count-even
  (lambda (lst)
    (cond
      ((null? lst) 0)
      ((equal? (remainder (car lst) 2) 0); si el modulo es 0
       (+ 1 (count-even (cdr lst))))
      (else
       (+ 0 (count-even (cdr lst)))))))

;; max: lon => number
(define greater
  (lambda (lst)
    (cond
      ((null? lst) 0)
      (else
       (let ((result (greater (cdr lst)))) ;; let para establecer variables auxiliares
         (if (> (car lst) result) (car lst) result))))))

;; how-many-positives: lon => number
(define how-many-positives
  (lambda (lst)
    (cond
      ((null? lst) 0)
      ((> (car lst) 0)
          (+ 1 (how-many-positives (cdr lst))))
      (else
          (how-many-positives (cdr lst))))))

;; count: lon => number
(define count
  (lambda (number lst)
    (cond
      ((null? lst) 0) 
      ((= number (car lst))
       (+ 1 (count number (cdr lst)))) 
      (else
       (count number (cdr lst)))))) 