head(H,[H|_]).

last([H|[]],H).
last([_|T],H):-
  last(T,H).

tail(H,[_|H]).

init([_|[]],[]).
init([H|X],[H|T]):-
  init(X,T).

prefix([X|[]],[X|_]).
prefix([X|T],[X|Y]) :-
  prefix(T,Y).

suffix(X,X).
suffix([_|X],Y) :-
  suffix(X,Y).
