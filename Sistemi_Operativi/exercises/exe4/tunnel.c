/**
 * @brief 
 * Si scriva il codice di una funzione C con la seguente interfaccia void tunnel(int descriptors[], int count) 
 * tale che, se eseguita, porti l’applicazione a gestire, per ogni file-descriptor dell’array descriptors 
 * l’inoltro del flusso dei dati in ingresso verso il canale di standard-output dell’applicazione. 
 * Il parametro count indica di quanti elementi è costituito l’array descriptors. 
 * L’inoltro dovrà essere attuato in modo concorrente per i diversi canali.
 * 
 * @param descriptors 
 * @param count 
 * @return void 
 */


#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

#define STD_OUT 1
#define abort(msg)do{printf(msg); exit(0);}while (0)

pthread_spinlock_t th_lock;

void* th_func(void* param){
    int fd = *((int*)param);
    int size_r, size_w = 0;
    char buffer[BUFSIZ];

    

    while ((size_r = read(fd, buffer,BUFSIZ)) > 0)
    {   
        pthread_spin_lock(&th_lock);
        size_w = write(STD_OUT, buffer, size_r); //sezione critica (più thread potrebbero scrivere allo stesso momento)
        pthread_spin_unlock(&th_lock);
    }

}



void tunnel(int descriptors[], int count){

    pthread_t ptids[count];
    pthread_spin_init(&th_lock, PTHREAD_PROCESS_PRIVATE);

    for(int i = 0; i < count; i++){
        pthread_create(ptids+i, NULL, th_func, descriptors+i);
    }

    for(int i = 0; i < count; i++){
        pthread_join(ptids[i], NULL);
    }

    printf("done...\n");
}


int main(int argc, char const *argv[])
{
	// checking command line arguments
	if(argc <= 1)  abort("use : exe2 <sourcefile> <...>\n");
	int count = argc-1;

	int *descriptors = malloc(count * sizeof(int));
	for(int i=0; i<count; i++){
		descriptors[i] = open(argv[i+1], O_RDONLY);
		if(descriptors[i] == -1) abort("open file error\n");
	}

	tunnel(descriptors,count);
	free(descriptors);
	return 0;
}