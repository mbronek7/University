lengt(X, Y):-
  lengt(X, Y, 0).
lengt([], Y, Y).
lengt([_|T], Y, X):-
  X \== Y,  % inaczej program sie nawraca i outof global stack
  C is X+1,
  lengt(T,Y,C).
  
