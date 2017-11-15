
#include <semaphore.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <time.h>
#define SIZE 500    
int pid,sad;

struct Zasob_Dzielony
{
    sem_t skradziono ;
    sem_t uroslo ;
    int jablko_z_A ;
    int jablko_z_B ;
    int zA,zB;  
    int gdzie;
} *z_dz ;

void zlodziej()
{   
    while(1)
    {
      sem_wait(&z_dz->uroslo);
      
      sad = rand()%2+1; 
      if(sad == 1)
      {
          if(z_dz->jablko_z_A < 1)
          {
              printf("Nie ukradnę z sadu A - nie mają już jabłek\n");
             
          } 
          else
          {
            --z_dz->jablko_z_A;
            z_dz->zA++;
          printf("Kradnę jabłko z sadu A mam już %d jabłek z sadu A i %d jabłek z sadu B \n ",z_dz->zA,z_dz->zB);
          }
          sem_post(&z_dz->skradziono);
          z_dz->gdzie=1;
      }
      else
      {   if(z_dz->jablko_z_B < 1)
          {
              printf("Nie ukradnę z sadu B - nie mają juz jabłek\n");
          }
          else
          {
          --z_dz->jablko_z_B;
          z_dz->zB++;
          printf("Kradnę jabłko z sadu B mam już %d jabłek z sadu A i %d jabłek z sadu B \n ",z_dz->zA,z_dz->zB);
          }
          sem_post(&z_dz->skradziono);
          z_dz->gdzie=2;
      }
         
    }
}

void rosnij()
{
    while (1)
    {
        sem_wait(&z_dz->skradziono);
        if((z_dz->gdzie) == 1)
        {
            printf("Jestem z sadu A i mam %d jabłek\n", ++z_dz->jablko_z_A);
        }
        else
        {
            printf("Jestem z sadu  B i mam %d jabłek\n", ++z_dz->jablko_z_B); 
        }
        sem_post(&z_dz->uroslo);
    }
}


int main()
{
    z_dz = mmap( NULL , sizeof( struct Zasob_Dzielony ) , PROT_READ | PROT_WRITE , MAP_SHARED | MAP_ANONYMOUS , -1 , 0 );
    sem_init( & z_dz->uroslo , 1 , 5 );
    sem_init( & z_dz->skradziono , 1 , 5 );
    z_dz->jablko_z_A = 5;
    z_dz->jablko_z_B = 5;
    pid = fork();
 
    if (pid < 0)
    {
        perror ("Niestety coś się zepsuło :( \n");
        exit(1);
    } 
    else if (pid == 0)
    {
        rosnij();
        exit(0);
    }

    zlodziej();
    return 1;
}
