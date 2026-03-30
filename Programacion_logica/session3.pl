%% Listas con prolog

%% X es miembro de una lista?

%% Guion bajo no me interesa
mmember(X, [X|_]).
mmember(X, [_ | Tail]) :-
    mmember(X, Tail).


count([], 0).
count([_ | Tail], Result) :-
    count(Tail, R1),
    Result is R1 + 1.

%% Crear una lista con el append de la lista uno y dos
%% mappend(L1, L2, List_Result)
mappend([], L2, L2).
mappend([Head | Tail], L2, [Head | R1]) :-
    mappend(Tail, L2, R1).

%% 
%% mreverse(L1, List_Result)
mreverse([], []). %% Si la lista esta vacia, el mreverse es una lista vacia
mreverse([Head | Tail], Result) :- %% Separar en dos, la cabeza y el resto de la lista
    mreverse(Tail, R1),
    mappend(R1, [Head], Result).