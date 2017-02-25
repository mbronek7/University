polaczenie(wroclaw,warszawa).
polaczenie(wroclaw,krakow).
polaczenie(wroclaw,szczecin).
polaczenie(szczecin,lublin).
polaczenie(szczecin,gniezno).
polaczenie(warszawa,katowice).
polaczenie(gniezno,gliwice).
polaczenie(lublin,gliwice).
/*
1: poaczenie(wroclaw,lublin).
2: polaczenie(wroclaw,X).
3: polaczenie(X,Z),polaczenie(Z,gliwice).
4: polaczenie(X,Y), polaczenie(Y, Z), polaczenie(Z,gliwice).
*/
connection(X,Y) :- polaczenie(X,Y).
connection(X,Y) :- polaczenie(X,Z),connection(Z,Y). /*
rekurencja patrz notatki.pdf
moze sie zapetlac poniewaz przy polaczeniach z A do B
i z B do A bedziemy sie pytali gdzie mozna dojechac z A odp do B a gdzie z B znowu do A
i się zapętla*/
