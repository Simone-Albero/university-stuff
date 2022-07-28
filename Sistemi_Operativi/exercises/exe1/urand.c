
/* 
Nei sistemi operativi UNIX, /dev/urandom è un dispositivo a 
caratteri (char device) virtuale in grado di generare numeri casuali. 
Nello specifico, l’operazione di lettura dal relativo file produce 
byte casuali. Scrivere un programma C che genera un file con 
contenuto interamente randomico. 

Il programma:
    -prende come parametri da linea di comando: 
   	    -un numero N e 
    	-una stringa S da usare come nome del file da creare;
    -crea un file S contenente N byte randomici;
    -utilizza il dispositivo /dev/random come sorgente di numeri 
     pseudo-casuali.
*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#include <linux/random.h>

#define abort(msg) do{printf(msg);exit(1);}while(0)
#define STDOUT 1


int main(int argc, char *argv[]){

    if (argc != 3) abort("usage: urand <random_numbers> <target_file>\n");

    int n_rand = atoi(argv[1]);
    int ifd, ofd, size_r, size_w = 0;
    char buffer[n_rand];
    

    /**Apro il generatore di numeri casuali**/
    ifd=open("/dev/random", O_RDONLY);
    if (ifd == -1) abort("input loading error\n");

    /**Inizializzo il file di output**/
    ofd=open(argv[2],O_WRONLY|O_CREAT|O_TRUNC,0660);
    if (ofd == -1) abort("output creation error\n");

    /**Leggo i numeri casuali**/
    size_r = read(ifd, buffer, n_rand);
    if(size_r == -1) abort("read error\n");

    size_w = write(ofd, buffer, size_r);
	if(size_w == -1) abort("writing output file error...\n");
	printf("written: %d byte\n", size_w);
     
    close(ifd);
    close(ofd);
}
