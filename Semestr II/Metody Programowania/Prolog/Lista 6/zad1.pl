% Stos w Prologu

put_S(E, S, [E|S]).	% dodajemy nowy element na poczatek listy
get_S([H|S], H, S).	% usuwamy pierwszy element z listy
empty_S([]).  % jak jest pusta to jest pusta
ojciec(Jan,2).% przykład
ojciec(Jan,2).% przyklad
addall_S(E, G, S, R):-
	findall(E, G, L),	% znajdz wszystkie takie E, żę spełnia G i umieść w L
	append(L, S, R). 	% dodaj L na początek S - dostajemy nowy stos R

% Kolejka w Prologu (na listach różnicowych)

snoc(X-[E|Y],E,X-Y).
put(E, S, R) :- snoc(E, S, R).

get([H|T]-X,H,T-X). % usuwam pierwszy bo łatwo sie dostać

empty(X-X). %jak odejme tosamo od siebie to bedzie puste

addAll(E,G,X-Z,X-Y):-
    findall(E,G,Y,Z).% znajdz wszystkie takie E, żę spełnia G i umieść w Y skonczone
