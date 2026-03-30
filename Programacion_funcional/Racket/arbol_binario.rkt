#lang racket

(define m1 '((1 2 3)
             (4 5 6)
             (7 8 9)))

(define m2 '((9 8 7)
             (6 5 4)
             (3 2 1)))

(define add-row
  (lambda (row1 row2)
    (cond
      ((null? row1) '())
      (else (cons (+ (car row1) (car row2))
                  (add-row (cdr row1) (cdr row2)))))))

(define add-matrix
  (lambda (m1 m2)
    (cond
      ((null? m1) '())
      (else (cons (add-row (car m1) (car m2))
                  (add-matrix (cdr m1) (cdr m2)))))))

;; binary search tree
(define bst
  '(8
    (5 (2 () ())
       (7 () ()))
    (12 ()
       (15 (11 () ())
           ()))))

;; padre del arbol, o de un nodo
(define parent
  (lambda (tree)
    (car tree)))

;; lado izquierdo de un nodo
(define left
  (lambda (tree)
    (cadr tree))) ;cadr: car cdr

;; lado derecho de un nodo
(define right
  (lambda (tree)
    (caddr tree))) ;caddr: car cdr cdr

;; encontrar un elemento en el arbol
(define find
  (lambda (key tree)
    (cond
      ((null? tree) #f)
      ((equal? key (parent tree)) #t)
      ((< key (parent tree)) (find key (left tree)))
    (else (find key (right tree))))))

;; recorrido preorder
(define preorder
  (lambda (tree)
    (cond
      ((null? tree) '())
      (else (cons (parent tree) ;; padre del arbol
                  (append (preorder (left tree)) ;; recorrido preorder
                          (preorder (right tree))))))))

;; insertar en un arbol binario
(define add
  (lambda (key tree)
    (cond
      ((null? tree) (cons key '(() ()))) ; Si no tiene nada, agregar el elemento con dos hijos vacios
      ((< key (parent tree)) (list (parent tree) ; Generar una nueva lista cuyo padre es el primer elemento
                                   (add key (left tree)) ; Hijo izquiedo vacio, agregarlo al hijo izquierdo
                                   (right tree))) ; No tocar hijo derecho
      (else (list (parent tree)
                  (left tree)
                  (add key (right tree))))))) ; Agregarlo al lado derecho