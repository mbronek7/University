#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <pthread.h>
#include <semaphore.h>
#include <stdio.h>
#include <unistd.h>
#include<time.h>
#define SIZE 500     

pthread_mutex_t mutex;  
sem_t skradziono, uroslo,skradziono2;     

int jablko_z_A = 10,jablko_z_B = 10,zA,zB;         

void *zlodziej()
{   
    while(1)
    {
      sem_wait(&uroslo);
      pthread_mutex_lock(&mutex);
      int polityk = (rand()%2)+1; 
      if(polityk == 1)
      {
          if(jablko_z_A < 1)
          {
              printf("Nie ukradnę z sadu A - nie mają już jabłek\n");
              return 0;
          } 
          else
          {
          --jablko_z_A;
          zA++;
          printf("Kradnę jabłko z sadu A mam już %d jabłek z sadu A i %d jabłek z sadu B \n ",zA,zB);
          }
          sem_post(&skradziono2);
      }
      else
      {   if(jablko_z_B < 1)
          {
              printf("Nie ukradnę z sadu B - nie mają juz jabłek\n");
              return 0;
          }
          else
          {
          --jablko_z_B;
          zB++;
          printf("Kradnę jabłko z sadu B mam już %d jabłek z sadu A i %d jabłek z sadu B \n ",zA,zB);
          }
          sem_post(&skradziono);
      }
          pthread_mutex_unlock(&mutex);
    }
}
void *sadB() {
    while (1)
    {
        sem_wait(&skradziono);
        pthread_mutex_lock(&mutex);
        printf("Jestem z sadu  B i mam %d jabłek\n", ++jablko_z_B);
        pthread_mutex_unlock(&mutex);
        sem_post(&uroslo);
    }
}

void *sadA() {
    while (1)
    {
        sem_wait(&skradziono2);
        pthread_mutex_lock(&mutex);
        printf("Jestem z sadu A i mam %d jabłek\n", ++jablko_z_A);
        pthread_mutex_unlock(&mutex);
        sem_post(&uroslo);
    }
}

int main()
{
    srand(time(0));              
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);

    pthread_mutex_init(&mutex, NULL);
    sem_init(&skradziono, 0, 5);
    sem_init(&skradziono2, 0, 5);
    sem_init(&uroslo, 0, 0);
     
    pthread_t threads[3];
    pthread_create(&threads[0], &attr, sadA, NULL);
    pthread_create(&threads[2], &attr, sadB, NULL);
    pthread_create(&threads[1], &attr, zlodziej, NULL);
    pthread_create(&threads[2], &attr, sadB, NULL);
    pthread_join(threads[0], NULL);
    pthread_join(threads[1], NULL);
    pthread_join(threads[2], NULL);

    pthread_attr_destroy(&attr);
    pthread_mutex_destroy(&mutex);
    sem_destroy(&skradziono);
    sem_destroy(&uroslo);
    sem_destroy(&skradziono2);

    pthread_exit(NULL);
    return 0;
}
