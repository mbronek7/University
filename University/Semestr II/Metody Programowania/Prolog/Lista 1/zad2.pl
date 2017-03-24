nieszczesliwy(X) :-
  mieszkawzoo(X),
  smok(X).

szczesliwy(X) :-
  stykasie(X,Y),
  mily(Y).

mily(X) :-
  czlowiek(X),
  odwiedzazoo(X).

stykasie(X,Y) :-
   zwierze(X),
   czlowiek(Y),
   odwiedzazoo(Y).
/*
Brakuje:
1)  smok to zwierze
2)  istnieje czlowiek,ktory odwiedza zoo wtedy ?- stykasie(X,jan). 
*/
