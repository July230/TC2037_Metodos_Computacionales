%% Esta es la actividad de programación 14 con prolog
%% Ian Julián Estrada Castro - A01352823
%% La relación pow establece la correspondencia entre los números, A, B y el número Res. 
%% El número Res es el resultado de calcular A elevado a la potencia B.

%% pow(A, B, Res)
%% Hecho innegable
pow(_, 0, 1).
pow(A, B, Res):-
 B > 0, %% B es positivo
 B1 is B - 1,
 pow(A, B1, Res1), %% calcular A^(B-1)
 Res is A * Res1. %% Res es A multiplicado por A^(B-1)


%% La relación fib establece la correspondencia entre un entero positivo N y un valor X. 
%% El valor X es el N-ésimo elemento de la secuencia de Fibonacci.

%% fib(N, X)
%% Hecho innegable
fib(0, 0).
fib(1, 1).
fib(N, X):- 
 N > 1, %% mientras n sea mayor a 1
 N1 is N - 1, %% calcular el termino de los dos anteriores
 N2 is N - 2,
 fib(N1, F1), %% Obtener el termino anterior de F1 y los dos anteriores de N2
 fib(N2, F2),
 X is F1 + F2. %% Obtener la suma de los dos numeros