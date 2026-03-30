#lang racket

;; Ian Julian Estrada Castro

;; sign: number number => boolean
(define sign
  (lambda (numero)
    (cond
      [(< numero 0) -1]
      [(> numero 0) 1]
      [else 0])))

;; BMI: number number => boolean
(define (bmi weight height)
  (define bmi-value (/ weight (* height height)))
  (cond ((<= bmi-value 19.9) 'underweight)
        ((<= bmi-value 24.9) 'normal)
        ((<= bmi-value 29.9) 'obese1)
        ((<= bmi-value 39.9) 'obese2)
        (else 'obese3)))