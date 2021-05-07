#include <stdio.h>
#include <stdlib.h>

#include "list.h"
#define DEF_SIZE 20

int main(){
    LIST* pl = new_list(DEF_SIZE);


    for(int i = 0; i < DEF_SIZE; i++){
        if((i+1) % 5 == 0){
            printf("Cancello l'elemento con indice: %d\n", pl->head);
            delete(pl, pl->head);
            list_print(pl);
        }
        else{
            insert(pl, i+1);
            list_print(pl);
        }

    } 

}