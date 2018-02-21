polaczenie(wroclaw,warszawa).
polaczenie(wroclaw,krakow).
polaczenie(wroclaw,szczecin).
polaczenie(szczecin,lublin).
polaczenie(szczecin,gniezno).
polaczenie(warszawa,katowice).
polaczenie(gniezno,gliwice).
polaczenie(lublin,gliwice).


trip(Z_Kad, Dokad, [Z_Kad|Trasa]):-
  trip(Z_Kad, Dokad, Trasa, [Dokad]).

trip(Z_Kad,Z_Kad,Trasa,Trasa).
trip(Z_Kad, Dokad, Trasa, Odwiedzone):-
  polaczenie(Teraz, Dokad),
  \+ memberchk(Teraz, Odwiedzone), % not provable operator
  trip(Z_Kad, Teraz, Trasa, [Teraz|Odwiedzone]).
