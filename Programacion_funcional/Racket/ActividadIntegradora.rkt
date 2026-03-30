#lang racket

;; Ian Julián Estrada Castro
;; Actividad integradora 2: Validación de autómatas usando entradas

;; validate (automata listas)

;; Automata de ejemplo
;; Estados (0 1 2 3 4)
;; Alfabeto (a b)
;; Transiciones ((0 a 1) (0 b 2) (1 a 1) (1 b 3) (2 b 2) (2 a 1) (3 a 1) (3 b 4) (4 a 1) (4 b 2))
;; Estado de arranque (inicial) 0
;; Estado/s de aceptacion (4)

;; Funciones para los movimientos ¿A dónde puedo ir bajo 'x' símbolo?

;; move, toma un estado, simbolo, una transicion y verifica que si la transición corresponde al estado y símbolo dados
;; O(1), Esto es debido a que son sólo comparaciones 
(define (move state symbol transition)
  (if (and (equal? (car transition) state) ; El estado actual es igual al primer elemento de la transición?
           (equal? (cadr transition) symbol)) ; El símbolo de entrada es igual al segundo elemento de la transición?
      (caddr transition) ; Si ambas condiciones se cumplen, devuelve el tercer elemento, el estado de destino
      #f)) ; Si ninguna condicion se cumple, es false, no hay transicion válida

;; move-helper, toma el estado, simbolo y la lista de transiciones
;; Complejidad O(n)
;; n es el numero de transiciones
(define (move-helper state symbol transitions)
  (cond
    ((null? transitions) '()) 
    ((move state symbol (car transitions)) ; Llama a move con el estado actual, simbolo y la primera transicion de la lista de transiciones
     (cons (move state symbol (car transitions)) ; Si es válida, agrega el estado de destino de esa transición a la lista de resultados
           (move-helper state symbol (cdr transitions)))) ; Continua con el resto de las transiciones de la lista de transiciones
    (else (move-helper state symbol (cdr transitions))))) ; En caso de no ser valida, simplemente continua con el resto de transiciones

;; moves, toma el estado actual, el simbolo y la lista de transicions
;; Complejidad O(n)
;; n es el numero de transiciones
(define (moves current-state symbol transitions)
  (move-helper current-state symbol transitions)) ; Llama a move-helper con los datos de entrada

;; Funcion para validar

;; accepting-state, toma el estado actual y la lista de estados aceptados, ¿Estoy en un estado de aceptación?
;; Complejidad O(n)
;; n es el tamaño de la lista de estados de aceptación
(define (accepting-state? current-state accepting-states)
  (member current-state accepting-states)) ; member, devuelve true si el elemento se encuentra en la lista


;; Funcion para recorrer las cadenas

;; evaluate-string, la cadena a evaluar, la lista de transiciones, estado actual y la lista de estados aceptados
;; Complejidad O(n * m)
;; n es la cantidad de simbolos en la cadena
;; m es el numero de transiciones
(define (evaluate-string string transitions current-state accepting-states)
  (evaluate-helper current-state string transitions accepting-states)) ; Llama a evaluate-helper con los datos de entrada

;; evaluate-helper, toma el estado actual, los simbolos de la cadena, lista de transiciones y estados aceptados
;; Complejidad O(n * m)
;; n es la cantidad de simbolos
;; m es el numero de transiciones
(define (evaluate-helper current-state symbols transitions accepting-states)
  (if (null? symbols) ; Verifica si la lista de simolos esta vacia, esto indica que llego al final de la lista
      (if (accepting-state? current-state accepting-states) ; Si la lista de simbolos esta vacia, compara si el estado actual es un estado aceptado
          #t  ; Verdadero si es un estado aceptado
          #f) ; Falso si es un estado cualquiera
      (let ((next-states (moves current-state (car symbols) transitions))) ; En caso de que la lista no este vacia, se define next-states como posibles estados siguientes
        (if (null? next-states) ; Si next-states esta vacio, significa que no hay transiciones disponibles desde el estado actual
            #f ; Devuelve false ya que significa que la cadena no es valida
            (evaluate-helper (car next-states) (cdr symbols) transitions accepting-states))))) ; Si hay estados disponibles, se hace recursivamente con el primer estado de next-states


;; validar estados y transiciones

;; validate-states-transitions, toma la lista de estados y la lista de transiciones
;; Complejidad O(n + m)
;; n es el numero de estados
;; m es el numero de transiciones
(define (validate-states-transitions states transitions)
  (and (validate-states-in-transitions states transitions) ; Verifica si los estados de la lista estan presentes en las transiciones
       (validate-transitions-states states transitions))) ; Verifica si los estados en la lista de transiciones estan en la lista de estados

;; validate-states-transitions, toma la lista de estados y la lista de transiciones
;; Complejidad O(n + m)
;; n es el numero de transiciones
;; m es el numero de estados
(define (validate-states-in-transitions states transitions)
  (define state-list (map car transitions)) ; map para extraer la primera parte de cada transicion y lo almacen en state-list
  (let loop ((states states)) ; bucle recursivo loop para verificar que los estados en la lista de states esten en state-list
    (cond
      ((null? states) #t) 
      ((not (member (car states) state-list)) #f) ; Verifica si el primer estado en la lista de estados no esta presente en state-list, si es asi, devuelve f
      (else (loop (cdr states)))))) ; Hace lo mismo para el resto de las transiciones

;; validate-transitions-states, toma la lista de estados y la lista de transiciones
;; Complejidad O(n)
;; n es el numero de transiciones del automata
(define (validate-transitions-states states transitions)
  (let loop ((transitions transitions)) ; bucle recursivo para verificar si los estados estan presentes en la lista states
    (cond
      ((null? transitions) #t) ; Si la lista de transiciones esta vacia, significa que terminó y las transiciones son válidad
      ((not (member (caddr (car transitions)) states)) #f) ;; Verificar si el tercer elemento, el estado de destino, esta en la lista de estados, de lo contrario, false ya que indica que al menos una transicion tiene un estado no valido
      (else (loop (cdr transitions)))))) ; Hace lo mismo para el resto de transiciones


;; validar alfabeto y transiciones
;; search-alphabet-transitions, toma la letra del alfabeto a buscar y la lista de transiciones
;; Complejidad O(n)
;; n es el numero de transiciones del automata
(define (search-alphabet-transitions letter transitions)
  (ormap (lambda (transition) ; utiliza ormap para lambda a cada elemento de transitions
           (equal? letter (cadr transition))) ; verifica si el segundo elemento, el simbolo, es igual a la letra del alfabeto a buscar
         transitions))

;; validate-alphabet-transitions, toma el alfabeto de entrada y la lista de transiciones
;; Complejidad O(n * m)
;; n es la longitud del alfabeto de entrada
;; m es el numero de transiciones
(define (validate-alphabet-transitions alphabet transitions)
  (if (null? alphabet) ; Si el alfabeto está vacío
      #t               ; Siempre devuelve verdadero
      (andmap (lambda (letter) (search-alphabet-transitions letter transitions)) ; andmap para aplicar lambda a cada letra del alfabeto
              alphabet))) ; Verifica que la letra del alfabeto este presente en alguna de las transiciones del automata con ayuda de search-alphabet-transitions


;; Funcion validate, toma el autómata en el formato establecido y la lista de las cadenas a evaluar
;; La extrancción de los elementos es O(1)
;; La validación usando validate-states-transitions y validate-alphabet-transitions es de O(n), donde n es el numero de transiciones
;; La evaluación con evaluate-string es de O(m), donde m es el total de símbolos en la cadena a evaluar
;; La creación de la lista con map es de O(k), donde k es el numero de cadenas
;; La validación final es de O(1)
;; La complejidad total es de O(n + m + k), depende de los tamaños de los estados, el alfabeto, las transiciones y las cadenas
(define (validate automaton strings)
  (display "Estados: ") (display (car automaton)) (newline)
  (display "Alfabeto: ") (display (cadr automaton)) (newline)
  (display "Transiciones: ") (display (caddr automaton)) (newline)
  (display "Estado inicial: ") (display (cadddr automaton)) (newline)
  (display "Estados de aceptación: ") (display (cadr (cdddr automaton))) (newline)
  ;;; Extraer los componentes del autómata y las cadenas a evaluar
  (let* ((states (car automaton)) ; El primer elemento del automata
         (alphabet (cadr automaton)) ; El segundo elemento del automata
         (transitions (caddr automaton)) ; El tercer elemento del automata
         (initial-state (cadddr automaton)) ; El cuarto elemento del automata
         (accepting-states (cadr (cdddr automaton))) ; El quinto elemento del automata
         (states-valid? (validate-states-transitions states transitions)) ; Valida los estados
         (alphabet-valid? (validate-alphabet-transitions alphabet transitions)) ; Valida el alfabeto
         (result (map (lambda (string) ; Se usa map para aplicar evaluate-string a cada cadena de la lista de cadenas
                        (evaluate-string string transitions initial-state accepting-states))
                      strings)))
    (display "Estados válidos: ") (display states-valid?) (newline)
    (display "Alfabeto válido: ") (display alphabet-valid?) (newline)
    (display "Resultados de las cadenas: ") (display result) (newline)
    result)) ; Se verifica que las validaciones son verdaderas y devuelve el resultado

;; La complejidad total del programa es O(n + m + k)
;; n es el numero de estados o transiciones
;; m es el numero de simbolos en todas las cadenas
;; k es el numero de cadenas




