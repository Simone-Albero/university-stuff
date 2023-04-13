/**
 * @file find.c
 * @brief 
 * 
 * Scrivere un programma C in cui dato un file A, una stringa B e un intero N, 
 * vengano creati N thread/processi che cerchino se all’interno del file A esiste una linea uguale a B.
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>

#define abort(msg)do{printf(msg); exit(0);}while(0)

FILE* ifd;
volatile int flag = 0;

void* th_func(void* param){
    char* buffer = malloc(100*sizeof(char));

    do{
        buffer[strlen(buffer)-1] = '\0';
        if(!strcmp(buffer, (char*)param)){
            printf("found: %s\n", (char*)param);
            __sync_lock_test_and_set(&flag, 1);
            free(buffer);
            return NULL;
        }

    }while(fgets(buffer, 100, ifd) != NULL && !flag);
    
    free(buffer);
    
}


int main(int argc, char *argv[]){   

    if(argc != 4)abort("usage: find <input_file> <target> <thread_number>\n");

    int th_num = atoi(argv[3]);

    ifd = fopen(argv[1], "r");
    if(ifd == NULL)abort("unable to open the file\n");

    pthread_t ptids[th_num];
    char* to_find = argv[2];
    
    for(int i = 0; i < th_num; i++) pthread_create(ptids+i, NULL, th_func, to_find);

    for(int i = 0; i < th_num; i++) pthread_join(ptids[i], NULL);
    printf("done...\n");

    fclose(ifd);
    return 0;
}
