// Michał Bronikowski 292227
#include <stdio.h>
#include <stdlib.h>
typedef struct zesp
{
    double Rzeczywista;
    double Urojona;
}zespolona;
typedef zespolona Zespolona;
Zespolona Dodaj(Zespolona A, Zespolona B);
Zespolona Odejmij(Zespolona A, Zespolona B);
Zespolona Pomnoz(Zespolona A, Zespolona B);
Zespolona Podziel(Zespolona A, Zespolona B);

void DodajzWskaznik(Zespolona A, Zespolona *B);
void OdejmijzWskaznik(Zespolona A, Zespolona *B);
void PomnozzWskaznik(Zespolona A, Zespolona *B);
void PodzielzWskaznik(Zespolona A, Zespolona *B);
void przyklad();
Zespolona Nowa();
void Wypisz(Zespolona A);
