#lang racket

(define m1 '((1 2 3)
             (4 5 6)
             (7 8 9)))

; Sumatoria de elementos de una matriz
(define sum-matrix
  (lambda (m)
    (apply + (map (lambda (row) (apply + row)) m)))) ;El segundo lambda es una funcion anonima

; Matriz traspuesta
(define traspose
  (lambda (m)
    (apply map list m)))

; f(x,y) = x + y
(define fn
  (lambda (x)
    (lambda (y)
      (+ x y))))

(define genera-fn-incremento
  (lambda (inc)
    (lambda (value)
      (+ value inc))))