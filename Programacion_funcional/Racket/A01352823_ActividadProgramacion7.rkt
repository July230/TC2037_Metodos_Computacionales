#lang racket

;; Actividad de programación 6, Ian Julián Estrada Castro

;; enlist
(define enlist
  (lambda (lst)
    (cond
      ((null? lst) '())
      (else (cons (list (car lst)) ; añadir el primer elemento a una lista
            (enlist (cdr lst))))))) ; hacer lo mismo con el resto de la lista

;; invert-pairs
(define invert-pairs
  (lambda (lst)
    (cond
      ((null? lst) '())
      (else
       (let ((head (car lst)))
       (cons (list (cadr head) (car head)) ; construir una lista con el segundo y primer elemento del par
             (invert-pairs (cdr lst))))))))

;; deep-reverse
(define deep-reverse
  (lambda (lst)
    (cond
      ((null? lst) '())
      (else
       (let ((first (car lst))
            (rest (cdr lst)))
        (if (list? first)  ; Si el primer elemento es una lista, inviértelo también.
            (append (deep-reverse rest) (list (deep-reverse first)))
            (append (deep-reverse rest) (list first))))))))

;; pack
(define pack
  (lambda (lst)
    (cond ((null? lst) '())
          ((= (length lst) 1) (list (list (car lst)))) ; Si la lista tiene un elemento, devuelve una lista con ese unico elemento
          (else (pack-helper lst))))) ; Si hay un elemento despues, ejecuta helper

(define pack-helper
  (lambda (lst)
    (cond ((null? (cdr lst)) (list (list (car lst))))
          ((equal? (car lst) (cadr lst))
           (cons (cons (car lst) (car (pack-helper (cdr lst)))) (cdr (pack-helper (cdr lst))))) ; Si el par es igual, agrupar en una lista
          (else (cons (list (car lst)) (pack-helper (cdr lst)))))))

;; encode
(define encode
  (lambda (lst)
    (cond
      ((null? lst) '())
      ((= (length lst) 1) (list (list 1 (car lst))))
      (else (encode-helper lst)))))

(define encode-helper
  (lambda (lst)
    (cond
      ((null? (cdr lst)) (list (list 1 (car lst))))
      ((equal? (car lst) (cadr lst))
       (cons (list (+ 1 (car (car (encode-helper (cdr lst))))) (car lst)) (cdr (encode-helper (cdr lst))))); Si son iguales, sumar 1 y agregar a una lista con el contador y el elemento
      (else (cons (list 1 (car lst)) (encode-helper (cdr lst))))))) ; Si solo es un elemento, construir una lista con 1 y el elemento
