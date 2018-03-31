
rev(X,Y):-
  rev(X,[],Y).
rev([],A,A):-!.
rev([H|T],A,Y):-
  rev(T,[H|A],Y).
