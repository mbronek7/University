exp(X, Y, Z):-
  Z is X^Y.
%-----------------------------------
/*
  count(Elem,List, Count):-
  select(Elem,List,X),
  Count is Count + 1,
  count(Elem,X,Count).
*/
count(_,[],0).
count(X, [X|T], N):-
  count(X,T,C),!,
  N is C + 1.
count(X,[_|T],N):-
  count(X,T,N).
%-----------------------------------
filter([],[]).
filter([H|T],[H|S]):-
  H >= 0,
   !,
  filter(T,S).
filter([H|T],S):-
  H < 0,
  filter(T,S).
