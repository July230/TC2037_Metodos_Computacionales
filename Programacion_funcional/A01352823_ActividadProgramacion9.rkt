#lang racket

;; Ian Julián Estrada Castro

;; Convertir funciones a recursividad terminal (de cola)

;; sumatoria
(define (sumatoria datos)
  (sumatoria-helper datos 0))

(define (sumatoria-helper datos acumulador)
  (cond
    ((null? datos) acumulador)
    (else (sumatoria-helper (cdr datos) (+ (car datos) acumulador)))))

;; incrementa
(define (incrementa datos)
  (incrementa-helper datos '()))

(define (incrementa-helper datos resultado)
  (cond
    ((null? datos) (reverse resultado))
    (else (incrementa-helper (cdr datos) (cons (+ 1 (car datos)) resultado)))))
