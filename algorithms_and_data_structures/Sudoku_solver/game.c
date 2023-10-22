#include <stdio.h>
#include <stdlib.h>

#include "game.h"


STATUS* new_status(int** data){
    STATUS* p_s= (STATUS*)malloc(sizeof(STATUS));
    
    int** new_data= (int**)malloc(N_ELEM*sizeof(int*));
    for(int i=0; i<N_ELEM; i++){
        new_data[i]= (int*)calloc(N_ELEM, sizeof(int));
    }

    for(int i=0; i<N_ELEM; i++){
        for(int j=0; j<N_ELEM; j++){
            new_data[i][j]= data[i][j];
        }
    }

    p_s->matrix= new_data;
    p_s->tryal = NULL;

    return p_s;
}


int* next_elem(int** data){
    int* vect= (int*)calloc(2, sizeof(int));

    for(int i=0; i<N_ELEM; i++){
        for(int j=0; j<N_ELEM; j++){
            if(data[i][j]==0){
                vect[x]= i;
                vect[y]= j;

                return vect;
            }
        }
    }

}

/*funzioni di supporto*/

int row_check(int value, int row, int** data){ //se trova la value nella riga restituisce 1

    for(int col= 0; col<9; col++){
        //printf("Vedo riga: %d\n", data[row][col]);
        if(data[row][col]==value)
            return 1;
    }

    return 0;
}

int col_check(int value, int col, int** data){ //se trova la value nella colonna restituisce 1

    for(int row= 0; row<N_ELEM; row++){
        //printf("Vedo colonna: %d\n", data[row][col]);
        if(data[row][col]==value)
            return 1;
    }

    return 0;
}

int mat_check(int value, int row, int col, int** data){ //se trova la value nella colonna restituisce 1
    
    int mat_r= row/3;
    int mat_c= col/3;

    if(mat_r==1)
        mat_r= 3;

    else if(mat_r==2)
        mat_r= 6;

    if(mat_c==1)
        mat_c= 3;
        
    else if(mat_c==2)
        mat_c= 6;      

    for(int i=mat_r; i<mat_r+3; i++){
        for(int j=mat_c; j<mat_c+3; j++){
            //printf("Vedo matrice: %d\n", data[i][j]);
            if(data[i][j]==value)
                return 1;
        }
    }

    return 0;
}

void* elem_data(int value){
    int* temp= (int*)malloc(sizeof(int));
    *temp = value;
    return (void*) temp;
}


void elem_analyze(int** data, int row, int col, LIST* p_l){

    for(int i=1; i<N_ELEM+1; i++){

        if(!row_check(i, row, data) && !col_check(i, col, data) && !mat_check(i, row, col, data)){
            //printf("Accetto l'elemento: %d\n", i);
            push(p_l, elem_data(i));
        }
    }
}

int is_complete(int** data){
    for(int i=0; i<N_ELEM; i++){
        for(int j=0; j<N_ELEM; j++){
            if(data[i][j]==0)
                return 0;
        }
    }

    return 1;
}