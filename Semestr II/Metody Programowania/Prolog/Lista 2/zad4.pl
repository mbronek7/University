even([]).
even([_,_|X]) :-
  even(X).

palindrom([_|[]]). % 1-elementowa lista jest palindromem
palindrom([]). % lista pusta jest palindromem
palindrom([H|T]):-
        append(X,[H],T), %sprawdzam czy istnieje lista która  połączona z ogonem
        palindrom(X). % T da nam całą listę wyjściową i czy jest ona palindromem

singleton([_|[]]).
