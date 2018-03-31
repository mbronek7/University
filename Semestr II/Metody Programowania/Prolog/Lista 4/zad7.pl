
revall(X,Y):-
  revall(X,[],Y).

revall([],A,A).% baza indukcji

revall([H|T],A,Y):-
  is_list(H), !,
  revall(H, R),
  revall(T,[R|A],Y).
revall([H|T],A,Y):-
  revall(T,[H|A],Y).
