
permutacja([],[]). % permutacją listy pustej jest lista pusta
permutacja(X,[H|T]) :-
  select(H,X,Y),  % Lista X bez elementu H to
  permutacja(Y,T). % ta lista bez tego elementu  z ogonem listy.
