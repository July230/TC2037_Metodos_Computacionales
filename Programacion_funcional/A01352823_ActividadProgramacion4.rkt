#lang racket

;; factorial: number => number
(define factorial
  (lambda (n)
    (cond
      [(= n 0) 1]
      [else (begin (* n (factorial (sub1 n))))])))

;; pow: number number => number
(define pow
  (lambda (a b)
    (cond
      [(= b 0) 1]
      [else (begin (* a (pow a (- b 1))))])))

;; fib number => number
(define fib
  (lambda (n)
    (cond
      [(= n 0) 0]
      [(= n 1) 1]
      [else (+ (fib (- n 1)) (fib (- n 2)))])))