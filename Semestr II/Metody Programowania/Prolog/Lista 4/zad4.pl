
mirror(leaf, leaf). %stale zapisuje sie malymi literami
mirror(node(Left, Value, Right), node(MirrorRight, Value, MirrorLeft)):-
  mirror(Left, MirrorLeft),
  mirror(Right, MirrorRight).


flatten(leaf, []).
flatten(node(L,E,R),List):-
  flatten(R,List1),
  flatten(L,List2),
  append(List1,[E|List2],List).
