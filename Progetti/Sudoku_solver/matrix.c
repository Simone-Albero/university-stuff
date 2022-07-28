#include <stdio.h>
#include <stdlib.h>

#include "matrix.h"
#define N_ELEM 9


int** file_read(){
    int** new_m= (int**)malloc(N_ELEM * sizeof(int*));
    for(int i=0; i<N_ELEM; i++){
        new_m[i]= (int*)calloc(N_ELEM, sizeof(int));
    }
    
    FILE* fp= fopen("matrice.txt", "r");
    
    for(int i=0; i<N_ELEM; i++){
        for(int j=0; j<N_ELEM; j++){
            fscanf(fp, "%d", &(new_m[i][j]));
        }
    }
    
    fclose(fp);
    return new_m;
}