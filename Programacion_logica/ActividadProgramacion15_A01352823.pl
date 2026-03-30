
%% Esta es la actividad de programación 15 con prolog
%% Ian Julián Estrada Castro - A01352823 

%% La relación how_many_positives establece la correspondencia entre una lista de entrada Lst y un valor N. 
%% El valor N es la cantidad de números positivos dentro de la lista.

%% how_many_positives(Lista, N)

how_many_positives([], 0).
how_many_positives([Head | Tail], N):-
 Head > 0, 
 how_many_positives(Tail, N1),
 N is N1 + 1.

%% Si el primer elemento es negativo, no se incrementa el contador
how_many_positives([Head | Tail], N):-
 Head =< 0,
 how_many_positives(Tail, N).



%% La relación count establece la correspondencia entre un número B y una lista de entrada Lst y un valor N. 
%% El número N  es la cantidad de veces que B se encuentra dentro de Lst. 

%% count(B, Lista, N)

count(_, [], 0). %% Si la lista esta vacia, es 0
count(B, [B | Tail], N):- %% Caso en el que el primer elemento es igual que B
 count(B, Tail, N1), 
 N is N1 + 1. %% Se incrementa el contador

%% Si el primer elemento no es B, no incrementa el contador
count(B, [Head | Tail], N):-
 B \= Head, %% Si B y Head son distintos, no incrementa el contador
 count(B, Tail, N).


%% La relación duplicateo establece la correspondencia entre dos listas Lst1 y Lst2. 
%% La lista Lst2 es una lista en donde cada elemento de Lst1 está duplicado.

%% duplicateo(Lista1, Lista2)

duplicateo([], []). 
duplicateo([Head | Tail], [Head, Head | Tail2]):- %% Es el mismo Head pero diferente Tail
 duplicateo(Tail, Tail2). %% Se llena la lista con el resto de elementos duplicados
  

%% La relación positives establece la correspondencia entre dos lista de números Lst1 y Lst2. 
%% La lista Lst2 es una lista que solo contiene los números positivos de Lst1.

%% positives(Lista1, Lista2)

positives([], []).
positives([Head | Tail], [Head | Tail2]):-
 Head > 0,
 positives(Tail, Tail2).

%% Head es negativo, se excluye de la lista resultante
positives([Head | Tail], L2):-
 Head =< 0,
 positives(Tail, L2).


%% La relación dot_product establece la correspondencia entre dos lista de números, Lst1, Lst2 y un valor Res. 
%% El valor Res es el resultado de realizar el producto punto de Lst1 por Lst2. 
%% El producto punto es una operación algebraica que toma dos secuencias de números de igual longitud y 
%% devuelve un solo número que se obtiene multiplicando los elementos en la misma posición y luego sumando esos productos. 

%% dot_product(Lista1, Lista2, Res)
dot_product([], [], 0).
dot_product([Head1 | Tail1], [Head2 | Tail2], Res):-
 dot_product(Tail1, Tail2, ResTail),
 Res is Head1 * Head2 + ResTail.