// Michał Bronikowski 292227
#include "zespolone.h"
#include <stdio.h>
#include <stdlib.h>
Zespolona Dodaj(Zespolona A, Zespolona B)
{
    Zespolona C;
    C.Rzeczywista=A.Rzeczywista+B.Rzeczywista;
    C.Urojona=A.Urojona+B.Urojona;
    return C;
}
Zespolona Odejmij(Zespolona A, Zespolona B)
{
    Zespolona C;
    C.Rzeczywista=A.Rzeczywista-B.Rzeczywista;
    C.Urojona=A.Urojona-B.Urojona;
    return C;
}
Zespolona Pomnoz(Zespolona A, Zespolona B)
{
    Zespolona C;
    C.Rzeczywista=A.Rzeczywista*B.Rzeczywista-A.Urojona*B.Urojona;
    C.Urojona=A.Urojona*B.Rzeczywista+A.Rzeczywista*B.Urojona;
    return C;
}
Zespolona Podziel(Zespolona A, Zespolona B)
{
    Zespolona C;
    double ar=A.Rzeczywista,au=A.Urojona,br=B.Rzeczywista,bu=B.Urojona;
    double dzielnik=br*br+bu*bu;
    C.Urojona=(au*br-ar*bu)/dzielnik;
    C.Rzeczywista=(ar*br+au*bu)/dzielnik;
    return C;
}
void DodajzWskaznik(Zespolona A, Zespolona *B)
{
    B->Rzeczywista=A.Rzeczywista+B->Rzeczywista;
    B->Urojona=A.Urojona+B->Urojona;
}
void OdejmijzWskaznik(Zespolona A, Zespolona *B)
{
    B->Rzeczywista=A.Rzeczywista-B->Rzeczywista;
    B->Urojona=A.Urojona-B->Urojona;
}
void PomnozzWskaznik(Zespolona A, Zespolona *B)
{
    double r;
    r=A.Rzeczywista*B->Rzeczywista-A.Urojona*B->Urojona;
    double u;
    u=A.Urojona*B->Rzeczywista+A.Rzeczywista*B->Urojona;
    B->Rzeczywista=r;
    B->Urojona=u;
}
void PodzielzWskaznik(Zespolona A, Zespolona *B)
{
    double a=A.Rzeczywista,b=A.Urojona,c=B->Rzeczywista,d=B->Urojona;
    double e=c*c+d*d;
    A.Rzeczywista=(a*c+b*d)/e;
    A.Urojona=(b*c-a*d)/e;

}
Zespolona Nowa()
{
    Zespolona A;
    printf("Podaj część Rzeczywistą nowej liczby zespolonej:");
    scanf("%lf",&A.Rzeczywista);
    printf("Podaj część Urojoną nowej liczby zespolonej:");
    scanf("%lf",&A.Urojona);
    return A;
}
void Wypisz(Zespolona A)
{
    printf("%g %gi\n",A.Rzeczywista,A.Urojona);
}
