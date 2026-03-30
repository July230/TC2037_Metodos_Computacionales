%% Este es un código para factorial

%% factorial(N, Result)

%% Hecho innegable, caso base
factorial(0, 1).

%% Los demás casos
factorial(N, Result) :-
 N > 0,
 N1 is N - 1, 
 factorial(N1, R1),
 Result is R1 * N.

%% Contar dígitos

%% Hecho innegable, caso base
count_digits(N, 1) :- N < 10.


count_digits(N, Result) :-
 N >= 10,
 N1 is N / 10,
 count_digits(N1, R1),
 Result is R1 + 1.