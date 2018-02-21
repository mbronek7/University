insert([X|Lista],Element,[X|Rest]):-
  Element>X, !,
  insert(Lista,Element,Rest).
insert(Lista,Element,[Element|Lista]).

ins_sort([],[]).
ins_sort([H|T],Y):-
   ins_sort(T,Lista),
   insert(Lista,H,Y).
