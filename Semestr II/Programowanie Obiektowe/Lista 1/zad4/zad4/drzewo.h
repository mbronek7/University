//Michał Bronikowski 292227
#include<stdlib.h>
#include<stdio.h>

struct str
{
    int val;
};
struct DrzewoBinarne
{
    struct str data;
    struct DrzewoBinarne * prawy;
    struct DrzewoBinarne * lewy;
};
typedef struct DrzewoBinarne wezel;
wezel * init( wezel *korzen);
void wstaw(wezel ** drzewo, struct str val);
wezel* szukaj(wezel ** drzewo, struct str val);
int  rozmiar(wezel * drzewo);
void przyklad();
