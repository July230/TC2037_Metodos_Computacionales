def reescribirRegex(regex):
    expresion_con_concatenacion = ""
    for i in range(len(regex)): 
        if i > 0 and (regex[i].isalnum() or regex[i] == '(') and (regex[i-1].isalnum() or regex[i-1] == '*' or regex[i-1] == ')' or regex[i-1] == '+'): 
            expresion_con_concatenacion += '?' 
        expresion_con_concatenacion += regex[i]
    return expresion_con_concatenacion 

def obtenerPosfijo(regex):
    prioridades = {'+': 0, '*': 0, '?': 1, '|': 2, '(' : 3, ')': 3}
    fila = []
    pila = []
    for caracter in regex:
        if caracter.isalnum(): 
            fila.append(caracter)
        elif caracter == '(': 
            pila.append(caracter)
        elif caracter == ')': 
            while pila and pila[-1] != '(':
                fila.append(pila.pop()) 
            pila.pop() 
        else: 
            while pila and prioridades.get(pila[-1], 0) <= prioridades[caracter] and pila[-1] != '(': 
                fila.append(pila.pop())
            pila.append(caracter)
    while pila:
        fila.append(pila.pop()) 
    posfijo = ''.join(fila) 
    return posfijo 

def NFA(posfijo, alfabeto):
    expresiones = []  
    transiciones = {}  
    estados = 0 
    estado_inicial = 1 
    estado_final = 1 

    for caracter in posfijo:
        if caracter in alfabeto:
            estado_inicial = estados
            estado_final = estados + 1  
            expresiones.append((estado_inicial, estado_final))
            transiciones[estado_inicial] = []
            transiciones[estado_inicial].append((estado_final, caracter))
            estados += 2
        if caracter == '*': 
            [estado1, estado2] = expresiones.pop()
            estado_inicial = estados
            estado_final = estados + 1
            expresiones.append((estado_inicial, estado_final))
            transiciones[estado_inicial] = []
            transiciones[estado2] = []
            transiciones[estado_inicial].append((estado1, "#"))
            transiciones[estado2].append((estado_final, "#"))
            transiciones[estado_inicial].append((estado_final, "#"))
            transiciones[estado2].append((estado1, "#"))
            estados += 2
        if caracter == '+': 
            [estado1, estado2] = expresiones.pop()

            estado_inicial = estados
            estado_final = estados + 1

            expresiones.append((estado_inicial, estado_final))

            transiciones[estado_inicial] = []
            transiciones[estado2] = []

            transiciones[estado2].append((estado1, "#"))
            transiciones[estado_inicial].append((estado1, "#"))
            transiciones[estado2].append((estado_final, "#"))

            estados += 2

        if caracter == '?': 
            [estado1, estado2] = expresiones.pop() 
            [estado3, estado4] = expresiones.pop() 

            transiciones[estado4] = []

            transiciones[estado4].append((estado1, "#")) 

            expresiones.append([estado3, estado2])

            estado_inicial = estado3
            estado_final = estado2
        
        if caracter == "|": 
            [estado1, estado2] = expresiones.pop()
            [estado3, estado4] = expresiones.pop()
            
            estado_inicial = estados
            estado_final = estados + 1
            
            expresiones.append([estado_inicial, estado_final])
            
            transiciones[estado_inicial] = []
            transiciones[estado2] = []
            transiciones[estado4] = []
            
            transiciones[estado_inicial].append((estado1, "#"))
            transiciones[estado_inicial].append((estado3, "#"))
            transiciones[estado2].append((estado_final, "#"))
            transiciones[estado4].append((estado_final, "#"))

            estados += 2

        estado_final = max([estado for expresion in expresiones for estado in expresion])

    return estado_inicial, estado_final, transiciones


regex = input(f"Ingrese la regular expression: ")

Regex_modificado = reescribirRegex(regex)

posfijo = obtenerPosfijo(Regex_modificado)

alfabeto = set() 

for i in range(len(Regex_modificado)):
    if Regex_modificado[i].isalnum():
        alfabeto.add(Regex_modificado[i])

print("Alfabeto: ", alfabeto)

estado_inicial, estado_final, transiciones = NFA(posfijo, alfabeto)

print("Estado inicial:", estado_inicial)
print("Estado final:", estado_final)
print("Transiciones:")

for estado, transiciones_salientes in transiciones.items():
    for destino, simbolo in sorted(transiciones_salientes):
        print(f"Estado {estado} -> Estado {destino} bajo '{simbolo}'")