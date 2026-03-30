#lang racket

;; sum: number => number
;; sumatoria de numeros hasta n
(define sum
  (lambda (n)
    (cond
      [(= n 0) 0]
      [else ( + n (sum (sub1 n)))])))

;; display: number => void
;; despliega n veces el letrero hola
(define display
  (lambda (n)
    (cond
      [(<= n 1) (writeln 'hola)]
      [else (begin
              (writeln 'hola)
              (display (sub1 n)))])))

;; sequence: number => void
;; Despliega la secuencia desde uno hasta n
(define sequence
  (lambda (n)
    (cond
      [(<= n 1) (writeln 1)]
      [else (begin
              (sequence (sub1 n))
              (writeln n))])))

;; count-digits: number => number
(define count-digits
  (lambda (n)
    (cond
      [(< n 10) 1]
      [else (+ 1(count-digits (quotient n 10)))]))) ;; quotient es division entera