#include <stdlib.h>
#include <stdio.h>

#include "list.h"
#include "grafo_list.h"
#include "grafo_mat.h"



int main(){
    LIST_GRAPH* p_g= new_list_graph(6);
    MAT_GRAPH* p_g2= new_mat_graph(6);


    new_mat_edge(1, 1, 1, p_g2);
    new_mat_edge(1, 2, 1, p_g2);
    new_mat_edge(3, 1, 1, p_g2);
    new_mat_edge(2, 5, 1, p_g2);
    new_mat_edge(3, 5, 1, p_g2);

    printf("Stampo la matrice di adiacenza: \n");
    mat_print(p_g2);


    new_list_edge(1, 1, 1, p_g);
    new_list_edge(1, 2, 1, p_g);
    new_list_edge(3, 1, 1, p_g);
    new_list_edge(2, 5, 1, p_g);
    new_list_edge(3, 5, 1, p_g);

    printf("Stampo la lista di adiacenza: \n");
    list_graph_print(p_g);
    

    printf("Converto la lista in matrice: \n");
    p_g2= to_matrix(p_g);
    mat_print(p_g2);

    printf("Verfico l'esistenza di una arco [%d;%d]: %d\n", 1, 2, edge_chek(p_g, 1, 2));
    printf("Verfico l'esistenza di una arco [%d;%d]: %d\n", 0, 1, edge_chek(p_g, 0, 1));

    printf("Verfico se il nodo [%d] è un pozzo: %d\n", 1, source_chek(p_g, 1));
    printf("Verfico se il nodo [%d] è una sorgente: %d\n", 1, well_chek(p_g, 1));

    
    printf("BFS su lista!\n");
    int* color= (int*)calloc(p_g->n_node, sizeof(int));
    bfs_list(3, p_g, color, 1);
    for(int i=0; i < p_g->n_node; i++)
        printf("%d ", color[i]);
    printf("\n");

    printf("DFS su lista!\n");
    int* color2= (int*)calloc(p_g->n_node, sizeof(int));
    //dfs_list(3, p_g, color2, 2);
    printf("Nodi visitati: %d\n", connected_node(3, p_g, color2, 2));
    for(int i=0; i < p_g->n_node; i++)
        printf("%d ", color2[i]);
    printf("\n");


}