#regex = input("RegEx: ")

regex = '(a|b)*abb'

# Función que convierte las concatenaciones de la expresion regular al operador definido, en este caso °
def convertirConcatenaciones(regex):
    # Expresion vacía 
    expresion_con_concatenacion = ""

    for i in range(len(regex)): # Leer el string
        if i > 0 and (regex[i].isalnum() or regex[i] == '(') and (regex[i-1].isalnum() or regex[i-1] == '*' or regex[i-1] == ')' or regex[i-1] == '+'): # Condiciones que cumplen las concatenaciones correctas
            expresion_con_concatenacion += '°' # Se agrega el operador en su lugar respectivo
        expresion_con_concatenacion += regex[i] # Se agrega el siguiente caracter
    return expresion_con_concatenacion # Deuelve la expresion con la concatenacion


# Funcion que convierte la expresion de expresion infijo a expresion posfijo
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

Regex_modificado = convertirConcatenaciones(regex)
print("RegEx_modificado:", Regex_modificado)

posfijo = infijo_a_posfijo(Regex_modificado)
print("RegEx en formato posfijo:", posfijo)

# Obtener alfabeto
# Ejemplo: a.*b.(a|b) -> {a, b}

alfabeto = set() # Crea un arreglo donde los elementos no se repiten

for i in range(len(Regex_modificado)):
    if Regex_modificado[i].isalnum():
        alfabeto.add(Regex_modificado[i])

print("Alfabeto: ", alfabeto)

# Funcion que construye el NFA
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
            transiciones[e2].append((estado_inicial, "#"))
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
                if simbolo == '#':
                    if estado_siguiente not in closure:
                        pila.append(estado_siguiente)
    return closure

primerConjunto = epsilonClosure(estado_inicial, transiciones)
segundoConjunto = epsilonClosure(estado_inicial + 1, transiciones)
#tercerconjunto = {primerConjunto, segundoConjunto}


def guardarConjuntos(conjunto):
    etiquetas = {}  # Diccionario que guarda las etiquetas para cada conjunto
    proxima_etiqueta = 'A'

    # Verificar si el conjunto ya tiene una etiqueta asignada
    etiqueta_existente = None
    for clave, valor in etiquetas.items():
        if conjunto == set(clave):
            etiqueta_existente = valor
            break

    # Asignar una nueva etiqueta única al conjunto o reutilizar una existente
    if etiqueta_existente is None:
        etiquetas[proxima_etiqueta] = conjunto
        proxima_etiqueta = chr(ord(proxima_etiqueta) + 1)
    else:
        etiquetas[etiqueta_existente] = proxima_etiqueta

    return etiquetas

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
    
# Función que sigue los pasos para construir un DFA
def construirDFA(estado_inicial, transiciones, alfabeto):
    # Paso 1: Obtener el primer conjunto de estados bajo epsilon-cierre
    primer_conjunto = epsilonClosure(estado_inicial, transiciones)

    # Inicializar el conjunto de estados finales y las etiquetas de los conjuntos
    conjuntos_finales = {tuple(primer_conjunto): None}
    etiquetas = {'A': primer_conjunto}

    # Inicializar una lista para almacenar los conjuntos nuevos
    conjuntos_nuevos = [primer_conjunto]

    # Paso 2: Iterar sobre los conjuntos nuevos hasta que ya no haya nuevos conjuntos
    while conjuntos_nuevos:
        # Obtener el primer conjunto de la lista
        conjunto_actual = conjuntos_nuevos.pop(0)
        print(conjunto_actual)

        # Paso 3: Iterar sobre cada símbolo en el alfabeto
        for simbolo in alfabeto:
            # Obtener el conjunto de estados alcanzables bajo el símbolo actual
            conjunto_transicion = move(conjunto_actual, simbolo, transiciones)

            # Verificar si el conjunto de transición no está vacío y no está en los conjuntos finales
            if conjunto_transicion and tuple(conjunto_transicion) not in conjuntos_finales:
                # Agregar el nuevo conjunto a los conjuntos finales y etiquetarlo
                etiqueta_nueva = chr(ord(max(etiquetas)) + 1)  # Obtener la próxima etiqueta en orden alfabético
                conjuntos_finales[tuple(conjunto_transicion)] = None
                etiquetas[etiqueta_nueva] = conjunto_transicion

                # Agregar el nuevo conjunto a la lista de conjuntos nuevos
                conjuntos_nuevos.append(conjunto_transicion)

    return conjuntos_finales, etiquetas


# Imprimir resultado
print("Estado inicial: ", estado_inicial)
print("Estado final: ", estado_final)

for transicion in transiciones:
    print("Transición: ", transicion, " -> ", transiciones[transicion])

# Usar la funcion sort para ordenar las llaves de las transiciones
transiciones_ordenadas = dict(sorted(transiciones.items()))

print("Transiciones ordenadas \n")
for transicion in transiciones_ordenadas:
    print("Transición: ", transicion, " -> ", transiciones_ordenadas[transicion])
print("Accepting State: ", estado_final)

#resultado = recorridoProfundidad(transiciones, estado_inicial)
#print(resultado)

print(primerConjunto)
print(segundoConjunto)


estados_alcanzables_con_a = move(primerConjunto, 'a', transiciones)
estados_alcanzables_con_b = move(primerConjunto, 'b', transiciones)

print("Estados alcanzables con 'a':", estados_alcanzables_con_a)
print("Estados alcanzables con 'b':", estados_alcanzables_con_b)

conjunto = guardarConjuntos(primerConjunto)
conjunto2 = guardarConjuntos(segundoConjunto)
#conjunto3 = guardarConjuntos(tercerconjunto)
print("Conjunto 1", conjunto)
print("Conjunto 2", conjunto2)
#print("Conjunto 3: ", tercerconjunto)

estados_alcanzables_con_a2 = move(segundoConjunto, 'a', transiciones)
estados_alcanzables_con_b2 = move(segundoConjunto, 'b', transiciones)

print("Estados alcanzables con 'a':", estados_alcanzables_con_a2)
print("Estados alcanzables con 'b':", estados_alcanzables_con_b2)

DFA = construirDFA(estado_inicial, transiciones, alfabeto)
print(DFA)