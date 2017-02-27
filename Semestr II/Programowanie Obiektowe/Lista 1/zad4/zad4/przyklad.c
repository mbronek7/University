//Michał Bronikowski 292227
#include<stdlib.h>
#include<stdio.h>
#include "drzewo.h"

/*
Moduł zawierający krótki przykład dzialania mojej implementacji drzewa binarnego
*/
void przyklad()
{
    wezel *korzen;
    wezel *drzewo_do_znajdowania_tu_bedzie_wskaznik;
    korzen=init(korzen);
    for(int i=0;i<10;++i)
    wstaw(&korzen,i);
    printf("Rozmiar\n");
    printf("%d\n",rozmiar(korzen));
    drzewo_do_znajdowania_tu_bedzie_wskaznik = szukaj(&korzen, 9);
    if (drzewo_do_znajdowania_tu_bedzie_wskaznik)
    {
        printf("W drzewie jest 9", drzewo_do_znajdowania_tu_bedzie_wskaznik->data.val);
        return;
    }
     puts("W drzewie nie ma 9");
}
