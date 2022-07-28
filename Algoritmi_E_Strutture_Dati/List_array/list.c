#include <stdio.h>
#include <stdlib.h>

#include "list.h"



LIST* new_list(int size){
    LIST* pl= (LIST*)malloc(sizeof(LIST));
    pl->head = -1;
    pl->free = 0;
    pl->size = size;
    pl->info = (int*)calloc(size, sizeof(int));
    pl->next = (int*)malloc(size*sizeof(int));
    pl->prev = (int*)malloc(size*sizeof(int));

    for(int i = 0; i < size; i++){
        pl->next[i] = i+1;
        pl->prev[i] = i-1;
    }  
    pl->next[size-1] = -1;
    return pl;
}

void insert(LIST* pl, int elem){
    int index = allocate_column(pl);
    pl->next[index] = pl->head;
    pl->prev[index] = -1;

    if(pl->head != -1)
        pl->prev[pl->head] = index;

    pl->head = index;
    pl->info[pl->head] = elem;

}

/* next  [  ] [  ] [-1]   head[ 1 ]

   info  [  ] [  ] [  ]

   prev  [-1] [  ] [  ]
*/




void delete(LIST* pl, int index){
    if(is_empty(pl)){
        printf("Lista vuota!!\n\n");
        exit(-1);
    }

    if(pl->prev[index] != -1){
        pl->next[pl->prev[index]] = pl->next[index];
    }
    else{
        pl->head = pl->next[index];
    }
       
   
    if(pl->next[index] != -1){
        pl->prev[pl->next[index]] = pl->prev[index];
    }
    
    free_column(pl, index);
    
}

int allocate_column(LIST* pl){
    if(pl->free == -1){
        printf("Lista piena!!\n");
        exit(-1);
    }

    int output = pl->free;
    pl->free = pl->next[pl->free];

    if(pl->free != -1)
        pl->prev[pl->free] = -1;

    return output;
}

void free_column(LIST* pl, int index){
    pl->next[index] = pl->free;
    pl->prev[index] = -1;

    if(pl->free != -1)
        pl->prev[pl->free] = index;

    pl->free = index;
}

int is_empty(LIST* pl){
    return pl->head == -1; 
}

void empty(LIST* pl);

void list_print(LIST* pl){

    if(is_empty(pl)){
        printf("Lista vuota!!\n");
        exit(-1);
    }

    printf("[ ");
    int index = pl->head;
    while(index != -1){
        printf("%d, ", pl->info[index]);
        index = pl->next[index];

    }
    printf("]\n\n");

}


