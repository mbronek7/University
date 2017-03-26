% Definiujemy moduł zawierający rozwiązanie.
% Należy zmienić nazwę modułu na {imie}_{nazwisko} gdzie za
% {imie} i {nazwisko} należy podstawić odpowiednio swoje imię
% i nazwisko bez znaków diakrytycznych
:- module(michal_bronikowski, [solve/2]).

:- op(200, fx, ~).
:- op(500, xfy, v).


is_it_a_variable(X) :- atom(X).
is_it_a_variable(~X) :- atom(X).

take_every_variable_from_one_clause([],[]) :- !.
take_every_variable_from_one_clause(v(X,Y),T) :- take_every_variable_from_one_clause(X,TF),!, take_every_variable_from_one_clause(Y,TE),!, append(TF,TE,T).
take_every_variable_from_one_clause(~X,[X]) :- is_it_a_variable(X),!.
take_every_variable_from_one_clause(X,[X]) :- is_it_a_variable(X),!.

generate_list_of_variables_from_clauses_without_duplicates([],[]) :- !.
generate_list_of_variables_from_clauses_without_duplicates([H|T], X) :- take_every_variable_from_one_clause(H,Y), generate_list_of_variables_from_clauses_without_duplicates(T,Z),!, append(Y,Z,M),!, sort(M,X).

generate_next_valuable([], []) :- !.
generate_next_valuable([X|T], [(X,f)|Y]) :- generate_next_valuable(T,Y).
generate_next_valuable([X|T], [(X,t)|Y]) :- generate_next_valuable(T,Y).

is_it_good(v(X,Y), W) :- is_it_good(X, W), !; is_it_good(Y, W).
is_it_good(X, W) :- memberchk((X,t), W).
is_it_good(~(X), W) :- memberchk((X,f), W).

check_solution([], [_|_]):-!.
check_solution([H|T], Solution) :- is_it_good(H, Solution), check_solution(T, Solution).

solve([],[]).
solve(Clauses, Solution) :-
    generate_list_of_variables_from_clauses_without_duplicates(Clauses,List_of_Variables),!,
    generate_next_valuable(List_of_Variables, Solution),
    check_solution(Clauses, Solution).
