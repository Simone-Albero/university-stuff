/* 
Dato un file binario contenente un sequenza di 2^15 interi di 
tipo short, scrivere un programma che crea N processi 
o threads, i quali leggono il contenuto del file ed individuano 
il valore minimo e massimo contenuto nel file.

Nel fornire una soluzione rispettare i seguenti vincoli:
    -ciascun intero non può essere letto da più di un thread/processo;
    -ciascun thread/processo può leggere il medesimo intero al più 
     una volta;
    -ciascun thread/processo può allocare memoria nell’heap per 
     al più 512 byte;
    -N è un parametro definito a tempo di compilazione o tramite 
     linea di comando;
    -N è minore o uguale a 8;
-    è ammesso allocare di variabili globali (data) e locali (stack) 
     per memorizzare tipi primitivi (puntatori, int, short, char, 
     long, etc.) per al più 128 byte.

Per generare il file è possibile utilizzare la soluzione 
dell’esercizio 1.
*/

#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>

#define abort(msg) do{printf(msg); exit(1);} while(0)
#define NUMBERS 32768 
#define MEM_UPPER_BOUND 512

short min = SHRT_MAX;
short max = SHRT_MIN;

pthread_spinlock_t th_lock;
pthread_barrier_t th_barrier;

int ifd;

void* th_func(){

    short lc_min = SHRT_MAX;
    short lc_max = SHRT_MIN;

    short* buffer = malloc(MEM_UPPER_BOUND);
    int size_r;

    pthread_barrier_wait(&th_barrier);

    /**ricerco il massimo e minimo locale**/
    do{
        pthread_spin_lock(&th_lock);
        size_r = read(ifd,buffer,MEM_UPPER_BOUND); //sezione critica
        pthread_spin_unlock(&th_lock);

        if(size_r <= 0) break;

        for(int i=0; i<size_r/sizeof(short); i++){
            if(buffer[i] > lc_max) lc_max = buffer[i];
            if(buffer[i] < lc_max) lc_min = buffer[i];
        }

    } while(size_r > 0);

    /**confronto i valori locali con quelli globali**/
    pthread_spin_lock(&th_lock);
        if(min > lc_min) min = lc_min; //sezione critica
        if(max < lc_max) max = lc_max; //sezione critica
    pthread_spin_unlock(&th_lock);

    return NULL;
}



int main(int argc, char const *argv[])
{
    if(argc != 3) abort("usage: minMax <thread_number> <target_file>\n");

    int th_num = atoi(argv[1]);
    if(th_num > 8) abort("usage: thread_number <= 8\n");

    /**apro il file in lettura**/
    ifd= open(argv[2], O_RDONLY);
    if(ifd == -1)abort("unable to open file\n");

    /**inizializzo la barriera**/
    pthread_barrier_init(&th_barrier, NULL, th_num);

    /**inizializzo lo spinlock**/
    pthread_spin_init(&th_lock, PTHREAD_PROCESS_PRIVATE);

    /**creo l'array di threads**/
    pthread_t threads[th_num];

    /**inizializzo l'array di threads creandoli**/
    for(int i=0; i<th_num; i++){
        pthread_create(threads+i, NULL, th_func, NULL);
    }

    for(int i=0; i<th_num; i++)	pthread_join(threads[i],  NULL);

    printf("Obtained output:\n\tMIN:%d\n\tMAX:%d\n", min, max);

    pthread_spin_destroy(&th_lock);
    pthread_barrier_destroy(&th_barrier);
    close(ifd);

    return 0;
}
