#ifndef _GRAFO_MAT_H
#define _GRAFO_MAT_H


typedef struct mat_graph{
    int** mat;
    int n_node;
}MAT_GRAPH;

MAT_GRAPH* new_mat_graph(int n_node);

void new_mat_edge(int row, int col, int flag, MAT_GRAPH* p_g); //la flag è 1 se il grafo è indiretto altrimenti è diretto

void mat_print(MAT_GRAPH* p_g);

int in_degree(int node, MAT_GRAPH* p_g);
int out_degree(int node, MAT_GRAPH* p_g);

#endif