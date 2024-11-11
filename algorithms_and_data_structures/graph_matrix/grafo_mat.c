#include <stdio.h>
#include <stdlib.h>

#include "grafo_mat.h"



MAT_GRAPH* new_mat_graph(int n_node){
    MAT_GRAPH* p_g = (MAT_GRAPH*)malloc(sizeof(MAT_GRAPH));
    int** new_mat = (int**)malloc(n_node * sizeof(int*));

    for(int i = 0; i < n_node; i++){
        new_mat[i]= (int*)calloc(n_node, sizeof(int));
    } 

    p_g->n_node = n_node;
    p_g->mat = new_mat;


    return p_g;
}

void new_mat_edge(int row, int col, int flag, MAT_GRAPH* p_g){
    if(flag == 1){ //grafo indiretto
        p_g->mat[row][col]= 1;
        p_g->mat[col][row]= 1;
    }

    else{   
        p_g->mat[row][col]= 1;
    }
}


void mat_print(MAT_GRAPH* p_g){

    if(p_g == NULL){
        exit(-1);
        printf("Grafo vuoto!! \n");
    }

    for(int i = 0; i < p_g->n_node; i++){
        for(int j = 0; j < p_g->n_node; j++){
            printf("%d ", p_g->mat[i][j]);
        }
        printf("\n");
    }
}

int in_degree(int node, MAT_GRAPH* p_g){
    int c= 0;
    
    for(int i = 0; i < p_g->n_node; i++){
        if(p_g->mat[i][node] == 1)
            c++;
    }

    return c;
}



int out_degree(int node, MAT_GRAPH* p_g){
    int c= 0;
    
    for(int i = 0; i < p_g->n_node; i++){
        if(p_g->mat[node][i] == 1)
            c++;
    }

    return c;
}