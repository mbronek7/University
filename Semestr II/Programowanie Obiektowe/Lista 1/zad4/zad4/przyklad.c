//Michał Bronikowski 292227
#include<stdlib.h>
#include<stdio.h>
#include "drzewo.h"

/*
Moduł zawierający krótki przykład dzialania mojej implementacji drzewa binarnego
*/
void przyklad()
{
    struct str dobl;
    wezel *korzen;
    wezel *drzewo_do_znajdowania_tu_bedzie_wskaznik;
    korzen=init(korzen);
    for(int i=0; i<10; ++i)
    {
        dobl.val=i;
        wstaw(&korzen,dobl);
    }
    printf("Rozmiar\n");
    printf("%d\n",rozmiar(korzen));
    struct str szuk;
    szuk.val=9;
    drzewo_do_znajdowania_tu_bedzie_wskaznik = szukaj(&korzen, szuk);
    if (drzewo_do_znajdowania_tu_bedzie_wskaznik)
    {
        printf("W drzewie jest 9", drzewo_do_znajdowania_tu_bedzie_wskaznik->data.val);
        return;
    }
    puts("W drzewie nie ma 9");
}
