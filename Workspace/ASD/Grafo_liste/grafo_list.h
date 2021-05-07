#ifndef _GRAFO_LIST_H
#define _GRAFO_LIST_H

#include "grafo_mat.h"
#include "list.h" 


typedef struct list_graph{
    NODE** node; //array dove ongi indice rappresenta un nodo
    int n_node;
}LIST_GRAPH;


LIST_GRAPH* new_list_graph(int n_node);

void new_list_edge(int node, int value, int flag, LIST_GRAPH* p_g); // node corrisponde all'indice dell'array, value indica il nodo a cui fa riferimento l'arco

void list_graph_print(LIST_GRAPH* p_g);

MAT_GRAPH* to_matrix(LIST_GRAPH* p_g);

int edge_chek(LIST_GRAPH* p_g, int node, int value);
int source_chek(LIST_GRAPH* p_g, int node); //non ha archi entranti
int well_chek(LIST_GRAPH* p_g, int node); //non ha archi uscenti

void bfs_list(int n, LIST_GRAPH* p_g, int* color, int mark);
void dfs_list(int n, LIST_GRAPH* p_g, int* color, int mark);
int connected_node(int n, LIST_GRAPH* p_g, int* color, int mark);

#endif