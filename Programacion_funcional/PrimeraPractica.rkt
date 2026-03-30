#lang racket

;;Ian Julian Estrada Castro

;; sum: number number => number
(define sum
  (lambda (a b)
    (+ a b)))

;; area-of-triangle: number number => number
(define area-of-triangle
  (lambda (base height)
    (/ (* base height) 2)))

;; area-of-circle: number number => number
(define area-of-circle
  (lambda (radius)
    (* 3.141516 radius radius)))

;; area-of-ring: number number => number
(define area-of-ring
  (lambda (outer inner)
    (- (area-of-circle outer)
       (area-of-circle inner))))

;; volume-of-circular-cylinder: numbre numbre => number
(define volume-of-circular-cylinder
  (lambda (radius height)
    (* height (area-of-circle radius))))

;; Activity

;; fahrenheit-to-celsius: number number => number, formula C = (5(F - 32))/9
(define farenheit-to-celsius
  (lambda (farenheit)
    (/ (* 5 (- farenheit 32)) 9)))

;; roots: number number number => number
(define roots
  (lambda (a b c)
    (/ (+ (- b) (sqrt(- (* b b) (* 4 a c)))) (* 2 a))))

(define root
  (lambda (a b c)
    (sqrt(- (* b b) (* 4 a c)))))

(define general
  (lambda (a b c)
    (/ (+ (- b) (root a b c)) (* 2 a))))

;; max2: number number => boolean
(define max2
  (lambda (a b)
    (if (> a b) a b)))

;; max3: number number number => boolean
(define max3
  (lambda (a b c)
    (max2 (max2 a b) c)))

;; interest: number => number
(define interest
  (lambda (amount)
    (cond
      [(<= amount 1000) (* 0.04 amount)]
      [(<= amount 5000) (* 0.045 amount)]
      [else (* 0.05 amount)])))