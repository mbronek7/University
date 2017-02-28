//Michał Bronikowski 292227
#include <stdio.h>
#include <stdlib.h>
#include "zespolone.h"
//Moduł zawierający przyklad dla innych operacji jest to analogiczne
void przyklad()
{
    Zespolona B,A,C;
    B=Nowa();
    A=Nowa();
    puts("Wynik odejmowania z wskaznikiem:");
    OdejmijzWskaznik(A,&B);
    Wypisz(B);;
    puts("Wynik odejmowania bez wskaznika:");
    B=Nowa();
    A=Nowa();
    C=Odejmij(A,B);
    Wypisz(C);
}
