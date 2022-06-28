/**
 * @brief 
 * Si scriva una funzione C con la seguente interfaccia void file_check(char *file_name, int num_threads).
 * Tale funzione dovrà lanciare num_thread nuovi threads, in modo che ciascuno di essi legga stringhe dallo standard input,
 * e per ogni stringa letta verifichi l’occorrenza di tale stringa all’interno di ciascuna riga del file il cui path è identificato 
 * tramite il parametro file_name, e stampi la stringa su standard output in caso affermativo.
 * 
 * @param file_name 
 * @param num_threads 
 */

#include<stdio.h>
#include<stdlib.h>
#include<fcntl.h>
#include<unistd.h>
#include<pthread.h>
#include<string.h>

#define abort(msg)do{printf(msg); exit(0);}while(0)
#define STD_IN 0

int ifd;
pthread_spinlock_t th_lock;

void* th_func(void* param){
    int size_r = 0;
    char buffer[BUFSIZ];

    lseek(ifd, 0, SEEK_SET);
    while ((size_r = read(ifd, buffer, BUFSIZ)) > 0)
    {
        if(strstr(buffer, (char*)param) != NULL) {
            printf("found: %s\n", (char*)param);
            return NULL;
        }
    }
    
}


void file_check(char *file_name, int num_threads){

    ifd = open(file_name, O_RDONLY);
    if(ifd == -1) abort("unable to open the file\n");

    pthread_spin_init(&th_lock, PTHREAD_PROCESS_PRIVATE);

    char inp_str[num_threads][30];

    for(int i = 0; i < num_threads; i++) {
        read(STD_IN, inp_str[i], 30);
    }

    pthread_t ptids[num_threads];
    for(int i = 0; i < num_threads; i++) pthread_create(ptids+i, NULL, th_func, inp_str+i);

    for(int i = 0; i < num_threads; i++) pthread_join(ptids[i], NULL);

    printf("done...\n");
    close(ifd);
}

int main(int argc, char *argv[])
{
    if(argc != 3) abort("usage: fileCheck <input_file> <thread_number> \n");

    file_check(argv[1], atoi(argv[2]));

    return 0;
}
