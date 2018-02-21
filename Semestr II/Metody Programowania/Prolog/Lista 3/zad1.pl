% Michał Bronikowski
perm([],[]). % permutacja listy pustej jest lista pusta
perm([H|T],X) :-
  perm(T,Y),
  select(H,X,Y).
