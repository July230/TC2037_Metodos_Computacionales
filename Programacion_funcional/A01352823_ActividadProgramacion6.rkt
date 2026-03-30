#lang racket

;; duplicate lst => lst
(define duplicate
  (lambda (lst)
    (cond
      ((null? lst) '())
      (else
       (cons (car lst) (cons (car lst)
                             (duplicate (cdr lst))))))))
         
;; positives lon => lon     
(define positives
  (lambda (lst)
    (cond
      ((null? lst) '())
      ((> (car lst) 0)
       (cons (car lst) (positives (cdr lst))))
      (else
       (positives (cdr lst))))))

;; list-of-symbols?: lst => lst
(define list-of-symbols?
  (lambda (lst)
    (cond
      ((null? lst) #t)
      ((symbol? (car lst))
       (list-of-symbols? (cdr lst)))
      (else #f))))

;; swapper: a b lst => lst
(define swapper
  (lambda (a b lst)
    (cond
      ((null? lst) '())
      ((equal? a (car lst))
       (cons b (swapper a b (cdr lst))))
      ((equal? b (car lst))
       (cons a (swapper a b (cdr lst))))
      (else
       (cons (car lst) (swapper a b (cdr lst)))))))

;; dot-product: lon lon => number
(define dot-product
  (lambda (lst1 lst2)
    (cond
      ((null? lst1) 0)
      ((null? lst2) 0)
      (else
       (+(*(car lst1) (car lst2))
       (dot-product (cdr lst1) (cdr lst2)))))))