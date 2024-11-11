#include <stdio.h>
#include <stdlib.h>

#include "grafo_mat.h"


int main(){
    MAT_GRAPH* p_g = new_mat_graph(6);

    new_edge(1, 1, 1, p_g);
    new_edge(1, 2, 1, p_g);
    new_edge(3, 1, 1, p_g);
    new_edge(2, 5, 1, p_g);
    new_edge(3, 5, 1, p_g);

    mat_print(p_g);

    printf("grado di entrata del nodo %d: %d\n", 2, in_degree(2, p_g));
    printf("grado di uscita del nodo %d: %d\n", 2, out_degree(2, p_g));
}