//Michał Bronikowski 292227
#include<stdlib.h>
#include<stdio.h>
#include "drzewo.h"


wezel * init( wezel *korzen)
{
    korzen = NULL;
    return korzen;
}
void wstaw(wezel ** drzewo, struct str val)
{
    wezel *kopia = NULL;
    if(!(*drzewo))
    {
        kopia = (wezel *)malloc(sizeof(wezel));
        kopia->lewy = kopia->prawy = NULL;
        kopia->data.val = val.val;
        *drzewo = kopia;
        return;
    }

    if(val.val < (*drzewo)->data.val)
    {
        wstaw(&(*drzewo)->lewy, val);
    }
    else if(val.val > (*drzewo)->data.val)
    {
        wstaw(&(*drzewo)->prawy, val);
    }

}

wezel* szukaj(wezel ** drzewo, struct str val)
{
    if(!(*drzewo))
    {
        return NULL;
    }

    if(val.val < (*drzewo)->data.val)
    {
        szukaj(&((*drzewo)->lewy), val);
    }
    else if(val.val > (*drzewo)->data.val)
    {
        szukaj(&((*drzewo)->prawy), val);
    }
    else if(val.val == (*drzewo)->data.val)
    {
        return *drzewo;
    }
}


int  rozmiar(wezel * drzewo)
{
    static int rez=0;
    if (drzewo)
    {
        rez++;
        rozmiar(drzewo->lewy);
        rozmiar(drzewo->prawy);
    }
    return rez;
}
