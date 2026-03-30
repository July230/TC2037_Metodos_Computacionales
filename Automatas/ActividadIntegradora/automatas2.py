"""
Ian Julián Estrada Castro - A01352823
Implementación de Métodos Coputacionales
Actividad Integradora 1: Convetir una expresión regular a un AFD
"""

# Prioridades de 0 a 3, donde 0 es el de mayor prioridad
# +, * => 0
# °(signo de producto punto) => 1
# | => 2
# ( ) => 3

# Pedir una entrada
alfabeto_entrada = input("Alphabet: ")
while len(alfabeto_entrada) == 0: # len es longitud de variable
    print("Alfabeto de entrada inválido")
    alfabeto_entrada = input("Alphabet: ")

regex = input("RegEx: ")


# Función que convierte las concatenaciones de la expresion regular al operador definido, en este caso °
# Complejidad: O(n)
# n es la cantidad de elementos en la cadena
def convertirConcatenaciones(regex):
    # Expresion vacía 
    expresion_con_concatenacion = ""

    for i in range(len(regex)): # Leer el string
        if i > 0 and (regex[i].isalnum() or regex[i] == '(') and (regex[i-1].isalnum() or regex[i-1] == '*' or regex[i-1] == ')' or regex[i-1] == '+'): # Condiciones que cumplen las concatenaciones correctas
            expresion_con_concatenacion += '°' # Se agrega el operador en su lugar respectivo
        expresion_con_concatenacion += regex[i] # Se agrega el siguiente caracter
    return expresion_con_concatenacion # Deuelve la expresion con la concatenacion


# Funcion que convierte la expresion de expresion infijo a expresion posfijo
# Mejor caso: O(n)
# Peor caso: O(n^2)
# n es la cantidad de caracteres en la cadena
def infijo_a_posfijo(regex):
    # Diccionario con prioridades de operandos
    prioridades = {'+': 0, '*': 0, '°': 1, '|': 2, '(' : 3, ')': 3}
    fila = []
    pila = []

    for caracter in regex:
        if caracter.isalnum(): # Si es una letra, se pone en la fila
            fila.append(caracter)
        elif caracter == '(': # Si es ( se pone en la pila
            pila.append(caracter)
        elif caracter == ')': 
            while pila and pila[-1] != '(': # Mientras el ultimo elemento de la pila no sea (
                fila.append(pila.pop()) # Se guardan todos los operadores de la pila en la fila hasta que se encuentra un (
            pila.pop() # Quitar ( de la pila
        else: # Es un operador
            while pila and prioridades.get(pila[-1], 0) <= prioridades[caracter] and pila[-1] != '(': # Mientras la prioridad de los operadores en la pila sea menor o igual a los de la expresion y el ultimo elemento no sea un (
                fila.append(pila.pop())
            pila.append(caracter)
        
    while pila:
        fila.append(pila.pop()) # Poner los elementos restantes de la pila hasta que este vacía

    posfijo = ''.join(fila) # Convertir una lista de caracteres en un string con join

    return posfijo 

print("RegEx:", regex)

Regex_modificado = convertirConcatenaciones(regex)
print("RegEx_modificado:", Regex_modificado)

posfijo = infijo_a_posfijo(Regex_modificado)
print("RegEx en formato posfijo:", posfijo)

# Obtener alfabeto
# Ejemplo: a.*b.(a|b) -> {a, b}
# Complejidad: O(n)
# n es la cantidad de elementos en el arreglo
alfabeto = set() # Crea una lista donde los elementos no se repiten

for i in range(len(Regex_modificado)):
    if Regex_modificado[i].isalnum():
        alfabeto.add(Regex_modificado[i])

print("Alfabeto: ", sorted(alfabeto))


# Funcion que construye el NFA
# Complejidad: O(n^2)
# n es la cantidad de caracteres en la cadena
def construirNFA(posfijo, alfabeto):
    expresiones = [] # pila que guarda los estados actuales e iniciales, los nodos 
    transiciones = {} # Diccionario que guarda las transiciones 

    # Se crean los estados, los cuales serán contadores
    estados = 0 # Contador de estados
    estado_inicial = 1 # Estado inicial
    estado_final = 1 # Estado final

    for caracter in posfijo:
        # Si es un símbolo del alfabeto, generar un autómata finito no determinista con un estado inicial, un estado final y una transición con el símbolo.
        if caracter in alfabeto:
            estado_inicial = estados
            estado_final = estados + 1  

            # Se agrega el nodo con sus estados
            expresiones.append((estado_inicial, estado_final))

            # Agregar transición vacía de estado inicial a estado final
            transiciones[estado_inicial] = []

            # Agregar transicion de estado inicial a estado binal bajo el simbolo
            transiciones[estado_inicial].append((estado_final, caracter))

            estados += 2
        
        if caracter == '*': # Cerradura de Kleene, ninguna o muchas ocurrencias
            # Tomar la última expresión generada (para repetición es necesario tener una expresión)
            [e1, e2] = expresiones.pop()


            # Actualizar los estados 
            estado_inicial = estados
            estado_final = estados + 1

            # Se agrega el nodo con sus estados
            expresiones.append((estado_inicial, estado_final))

            # Agregar transiciones vacías
            transiciones[estado_inicial] = []
            transiciones[e2] = []

            # Agregar transiciones de acuerdo al algoritmo de Thomson
            # Hay dos estados que van a dos estados bajo epsilon
            transiciones[estado_inicial].append((e1, "#"))
            transiciones[e2].append((estado_final, "#"))
            transiciones[estado_inicial].append((estado_final, "#"))
            transiciones[e2].append((e1, "#"))

            estados += 2

        if caracter == '+': # Cerradora positiva, una o mas ocurrencias
            # Tomar la última expresión generada (para repetición es necesario tener una expresión)
            [e1, e2] = expresiones.pop()

            # Crear los estados
            estado_inicial = estados
            estado_final = estados + 1

            # Se agrega el nodo con sus estados
            expresiones.append((estado_inicial, estado_final))

            # Agregar transiciones vacías
            transiciones[estado_inicial] = []
            transiciones[e2] = []

            # Agregar las transiciones para la cerradura positiva
            transiciones[e2].append((e1, "#"))
            transiciones[estado_inicial].append((e1, "#"))
            transiciones[e2].append((estado_final, "#"))

            estados += 2

        if caracter == '°': # Concatenacion, unir los ultimos dos AFN generados
            # Tomar las dos ultimas expresiones generadas
            # Al ser pilas, el automata en el fondo es el primero que se creo
            [e1, e2] = expresiones.pop() # La segunda
            [e3, e4] = expresiones.pop() # La primera

            # Agregar transición vacía 
            transiciones[e4] = []

            # Agregar las transiciones
            transiciones[e4].append((e1, "#")) 

            # Agregar estados a expresiones
            expresiones.append([e3, e2])

            # Actualizar estado inicial y final
            estado_inicial = e3
            estado_final = e2
        
        if caracter == "|": # Alternativa, una u otra ocurrencia
            # Tomar las dos últimas expresiones generadas (para elección es necesario tener dos expresiones)
            [e1, e2] = expresiones.pop()
            [e3, e4] = expresiones.pop()
            
            # Crear estados
            estado_inicial = estados
            estado_final = estados + 1
            
            # Agregar estados a expresiones
            expresiones.append([estado_inicial, estado_final])
            
            # Agregar transiciones vacías
            transiciones[estado_inicial] = []
            transiciones[e2] = []
            transiciones[e4] = []
            
            # Agregar transiciones de acuerdo al algoritmo de Thomson
            transiciones[estado_inicial].append((e1, "#"))
            transiciones[estado_inicial].append((e3, "#"))
            transiciones[e2].append((estado_final, "#"))
            transiciones[e4].append((estado_final, "#"))

            estados += 2

        estado_final = max([estado for expresion in expresiones for estado in expresion])

    return estado_inicial, estado_final, transiciones


estado_inicial, estado_final, transiciones = construirNFA(posfijo, alfabeto)

# Funcion que obtiene los estados a los que se llega bajo épsilon, realiza un recorrido por profundidad
# Complejidad: O(n^2 * v)
# n es el número total de transiciones bajo epsilon 
# v es en numero total de estados del automata
def epsilonClosure(estado, transiciones):
    closure = set() # Conjunto para almacenar los estados alcanzables mediante epsilon
    pila = [estado] # Pila para guardar los nodos visitados, inicia con el estado de inicio

    while pila: # Mientras la pila tenga algo
        estado_actual = pila.pop() # Pop del estado en la pila
        closure.add(estado_actual) # El estado de la pila se agrega en el conjunto de closure

        # Verifica si hay transiciones epsilon desde el estado actual
        if estado_actual in transiciones:
            # Ver en cada par en una llave, su estado y el simbolo, que las llaves concuerden. ¿A que estado puedo ir bajo #?

            for estado_siguiente, simbolo in transiciones[estado_actual]:
                if simbolo == '#' and (estado_siguiente not in closure):
                    pila.append(estado_siguiente)

    return closure

# Función que obtiene los estados a los que un estado puede llegar bajo un determinado símbolo
# Complejidad: O(n^2 * v)
# n es el número total de transiciones bajo epsilon 
# v es el tamaño del conjunto de la entrada
def move(conjunto_estados, simbolo, transiciones):
    # Conjunto para almacenar los estados alcanzables bajo un determinado simbolo
    estados_alcanzables = set()

    # Iterar sobre cada estado en el conjunto de estados inicial
    for estado in conjunto_estados:
        # Verificar si hay mas transiciones para el simbolo dado desde el estado actual
        if estado in transiciones:
            # Ver en cada par en una llave, su estado y el simbolo, que las llaves concuerden. ¿A que estado puedo ir bajo "x" simbolo?
            for estado_siguiente, simbolo_transicion in transiciones[estado]:
                # Si el simbolo de un estado es igual al simbolo del diccionario
                if simbolo_transicion == simbolo:
                    estados_alcanzables.add(estado_siguiente)
                    
    if not estados_alcanzables: # Si el conjunto de estados alcanzables esta vacio
        return None # Devolver none para indicar la ausencia de transicones
    else:
        return estados_alcanzables
    
# Función que obtiene los conjuntos epsilon
# Complejidad: O(n^2 * v * u)
# n son los estados del automata
# v es cada uno de los simbolos del alfabeto
# u son el numero de transiciones bajo cierto simbolo
def conjuntosEpsilon(estado_inicial, transiciones, alfabeto):
    # Ordenar el alfabeto para que a sea el primer simbolo
    alfabeto = sorted(alfabeto)

    # Paso 1: Obtener el primer conjunto de estados bajo epsilon-cierre
    primer_conjunto = epsilonClosure(estado_inicial, transiciones)

    # Inicializar el conjunto de estados finales y las etiquetas de los conjuntos
    conjuntos_finales = {tuple(primer_conjunto): None}
    etiquetas = {'A': primer_conjunto}

    # Inicializar una lista para almacenar los conjuntos nuevos
    conjuntos_procesados = set()
    conjuntos_procesados.add(tuple(primer_conjunto))  # Agregar el primer conjunto

    # Lista para crear los conjuntos nuevos
    conjuntos_nuevos = [primer_conjunto]
    
    # Paso 2: Iterar sobre los conjuntos nuevos hasta que ya no haya nuevos conjuntos
    while conjuntos_nuevos:
        # Obtener el primer conjunto de la lista
        conjunto_actual = conjuntos_nuevos.pop(0)
        
        # Marcar el conjunto actual como procesado
        conjuntos_procesados.add(tuple(conjunto_actual))

        # Paso 3: Iterar sobre cada símbolo en el alfabeto
        for simbolo in alfabeto:
            # Obtener el conjunto de estados alcanzables bajo el símbolo actual
            conjunto_transicion = move(conjunto_actual, simbolo, transiciones)

            # Verificar si el conjunto de transición tiene estados alcanzables bajo el simbolo actual
            if conjunto_transicion:
                # Aplicar epsilonClosure al conjunto de transición
                conjunto_epsilon = set()
                # Iterar en cada estado de los conjuntos
                for estado in conjunto_transicion:
                    conjunto_epsilon = conjunto_epsilon | epsilonClosure(estado, transiciones) # Aplicar union de conjuntos del conjunto existente y el conjunto epsilon nuevo cada iteracion

                # Convertir el conjunto epsilon en una tupla para la verificación
                conjunto_epsilon_tupla = tuple(conjunto_epsilon)

                # Verificar si el conjunto ya ha sido procesado
                if conjunto_epsilon_tupla not in conjuntos_procesados:
                    # Agregar el nuevo conjunto a los conjuntos finales y etiquetarlo
                    conjuntos_finales[conjunto_epsilon_tupla] = None # Agrega el conjunto a los conjuntos finales sin etiqueta
                    etiqueta_nueva = chr(ord(max(etiquetas)) + 1)  # Se le asigna la próxima etiqueta en orden
                    etiquetas[etiqueta_nueva] = conjunto_epsilon

                    # Agregar el nuevo conjunto a la lista de conjuntos nuevos
                    conjuntos_nuevos.append(conjunto_epsilon) # Agrega el nuevo conjunto epsilon a la lista de de conjuntos nuevos para seguir procesandolos
                    conjuntos_procesados.add(conjunto_epsilon_tupla)  # Marcar el nuevo conjunto como procesado


    return conjuntos_finales, etiquetas

# Función que recibe los conjuntos epsilon y el estado final del AFN oiginal
# Complejidad: O(n)
# n es la cantidad de conjuntos en la lista
def estadosAceptacion(conjuntos_epsilon, estado_final):
    estados_aceptacion = [] # Lista vacia donde se guardan las etiquetas del estado de aceptación

    # Recorrer los conjuntos epsilon y verificar si el estado final está presente en alguno de ellos
    for etiqueta, conjunto in conjuntos_epsilon.items():
        # Verificar que el estado final este presente en el conjunto actual
        if estado_final in conjunto:
            # Agregar la etiqueta a la lista de estados de aceptacion
            estados_aceptacion.append(etiqueta)

    return estados_aceptacion

# Función que obtiene los estados a los que van y bajo que simbolo, se construye el DFA
# Complejidad: O(n * v)
# n es la cantidad de estados en el automata
# v es la cantidad de elementos en el alfabeto
def tablaEstados(conjuntos_epsilon, alfabeto, transiciones):
    # Ordenar el alfabeto 
    alfabeto = sorted(alfabeto)

    # Iniciar un diccionario con los estados
    tabla_estados = {}

    # Iterar sobre cada par (etiqueta, conjunto) en el diccionario conjuntos_epsilon
    for etiqueta, conjunto in conjuntos_epsilon.items():
        # Diccionario que guarda las transiciones y bajo que simbolo
        transiciones_estados = {}

        # Iterar sobre cada simbolo del alfabeto
        for simbolo in alfabeto:
            # Iniciar el conjunto de estados alcanzables bajo el simbolo actual
            conjunto_transicion = move(conjunto, simbolo, transiciones)

            # Verificar que el conjunto de transicion no este vacio 
            if conjunto_transicion:
                # Aplicar epsilon closure al conjunto de transición
                conjunto_epsilon = set() 
                # Iterar en cada estado de los conjuntos
                for estado in conjunto_transicion:
                    # Aplicar union de conjuntos del conjunto_epsilon existente y el conjunto_epsilon nuevo cada iteracion
                    conjunto_epsilon = conjunto_epsilon | epsilonClosure(estado, transiciones)
                    
                # Buscar si el conjunto de transición pertenece a algún conjunto epsilon
                etiqueta_destino = None
                # se aplica el mismo proceso al nuevo conjunto epsilon
                for etiq, conj in conjuntos_epsilon.items():
                    # Si el conjunto del nuevo conjunto_epsilon es igual a uno ya existente
                    if conj == conjunto_epsilon:
                        # Asignar la misma etiqueta
                        etiqueta_destino = etiq
                        break
                
                # Verificar si se encontró una etiqueta destino
                if etiqueta_destino:
                    # Asignar el símbolo al estado destino
                    transiciones_estados[etiqueta_destino] = simbolo

        # Agregar las transiciones del estado actual a la tabla de estados
        tabla_estados[etiqueta] = transiciones_estados
    
    return tabla_estados

# Funcion que toma los conjuntos generados por construirDFA 
# Imprimir resultado
print("Estado inicial: ", estado_inicial)
print("Estado final: ", estado_final)

# Usar la funcion sort para ordenar las llaves de las transiciones
transiciones_ordenadas = dict(sorted(transiciones.items()))

print("\n NFA")
for transicion in transiciones_ordenadas:
    print("Transición: ", transicion, " -> ", transiciones_ordenadas[transicion])
print("Estado de aceptación: ", estado_final)

# resultado = recorridoProfundidad(transiciones, estado_inicial)
# print(resultado)

print("\n DFA")
etiquetas, conjuntosepsilon = conjuntosEpsilon(estado_inicial, transiciones, alfabeto)
# for etiqueta, conjunto in conjuntosepsilon.items():
#     print(etiqueta, " -> ", conjunto)

tabla_estados = tablaEstados(conjuntosepsilon, alfabeto, transiciones)
# print(tabla_estados)
estado_aceptado = estadosAceptacion(conjuntosepsilon, estado_final)
for etiqueta, transiciones in tabla_estados.items():
    print(etiqueta, " -> ", end="")
    print("[", end="")
    for estado_destino, simbolo in transiciones.items():
        print("(", estado_destino, ": ", simbolo, ")", end="")
    print("]")
print("Estado/s de aceptación: ", estado_aceptado)

# Dado que la complejidad más alta es de conjuntosEpsilon con O(n^2 * u * v)
# En el peor de los casos, el programa realiza O(n^2 * u * v) iteraciones
# donde n es la cantidad de estados en el automata
# v es la cantidad de simbolos en el alfabeto
# u es la cantidad de transiciones que un estado puede tener bajo cierto simbolo, incluyendo epsilon
