//Michał Bronikowski 292227
#include <stdio.h>
#include <stdlib.h>
#include "zespolone.h"
int main()
{
    Zespolona B,A,C;
    B=Nowa();
    A=Nowa();
    OdejmijzWskaznik(A,&B);
    Wypisz(B);
    return 0;
}
