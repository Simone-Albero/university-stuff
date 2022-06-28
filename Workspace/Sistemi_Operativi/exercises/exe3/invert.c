/*
Scrivere un programma C invert che dato un file A ne inverte il contenuto e lo memorizza 
in nuovo file B. Il programma deve:
    -riportare il contenuto di A in memoria;
    -invertire la posizione di ciascun byte utilizzando un numero N 
     di thread/processi concorrenti;
    -scrivere il risultato in un nuovo file B.

A, B e N sono parametri che il programma deve acquisire da linea di comando.
*/

#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <pthread.h>

#define abort(msg) do{printf(msg); exit(1);}while(0)

int ifd, ofd, size_r, size_w, f_size;
volatile int sw_count = 0;

char* f_content;


void* th_func(){
    int sw_cur;
    
    while((sw_cur = __sync_fetch_and_add(&sw_count, 1)) < f_size/2){
        /*eseguo lo swap*/
        char tmp = f_content[sw_cur];
        f_content[sw_cur] = f_content[f_size-sw_cur];
        f_content[f_size-sw_cur] = tmp;
    }

    return NULL;
}


int main(int argc, char const *argv[]){
    if(argc != 4) abort("usage: invert <input_file> <target_file> <thread_number>\n");

    int th_num = atoi(argv[3]);

    ifd = open(argv[1], O_RDONLY);
    if(ifd == -1) abort("unable to open the input file\n");

    ofd = open(argv[2], O_WRONLY | O_CREAT | O_TRUNC, 0660);
    if(ofd == -1) abort("unable to open/create the target file\n");

    /*ricavo la dimensione in byte del file*/
    /*il -2 occorre per scartare i byte di fine file*/
    f_size = lseek(ifd, 0, SEEK_END)-2;
    lseek(ifd, 0, SEEK_SET); //riporto il file alla posizione iniziale

    /*alloco lo spazio in memoria*/
    f_content = malloc(f_size);

    /*popolo lo spazio in memoria con il contenuto del file*/
    size_r = 0;
    while((size_r += read(ifd, f_content+size_r, BUFSIZ)) < f_size){
        if(size_r < 0) abort("reading error\n");
    }
    printf("readed: %d\n", size_r);
    close(ifd);

    /**creo l'array di threads**/
    pthread_t ptids[th_num];

    /**inizializzo l'array di threads creandoli**/
    for(int i=0; i<th_num; i++) pthread_create(ptids+i, NULL, th_func, NULL);
    

    for(int i=0; i<th_num; i++)	pthread_join(ptids[i],  NULL);

    printf("swapping done...\n");

    /*scrivo su file*/
    
    /*scrivo su file*/
    size_w =  write(ofd, f_content, f_size);


    printf("written: %d\n", size_w);
    close(ofd);
    free(f_content);
}


/**
 * @brief 
 * apro il file
 * salvo in memoria il suo contenuto
 * cero n tread
 * inverto il contenuto presente in memoria
 * scrivo sul nuovo file
 * 
 */