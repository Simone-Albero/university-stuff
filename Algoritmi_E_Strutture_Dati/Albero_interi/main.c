#include <stdio.h>
#include <stdlib.h>

#include "tree.h"



int main(){
    TREE p_t;

    add_root(&p_t, 10);

    NODE* a_1 = add_left(p_t, 6);
    NODE* a_2 = add_right(p_t, 2);
    NODE* b_1 = add_left(a_1, 4);
    NODE* b_2 = add_right(a_1, 7);
    NODE* b_3 = add_left(a_2, 5);
    //NODE* b_4 = add_right(a_2, 2);
    NODE* c_1 = add_left(b_1, 12);
    NODE* c_2 = add_right(b_1, 13);
    NODE* c_3 = add_left(b_2, 14);


    printf("Cerco nell'albero il numero %d: %d\n", 3, (tree_search(p_t, 3)) != NULL);
    printf("Cerco nell'albero il numero %d: %d\n", 12, (tree_search(p_t, 12)) != NULL);


    printf("Verifico che esista un sotto albero con n/2 nodi: %d\n", verifica(p_t));
    printf("Conto i nodi aventi i discendenti pari al campo info: %d\n", conta_discendenti(p_t));
    printf("Verifico che un livello di porofndita sia pari ai suoi nodi: %d\n", verifica_profondita_nodi(p_t, p_t, 0));

    printf("Conto il numero di nodi: %d\n", node_count(p_t));
    printf("Verifico se l'albero è un cammino: %d\n", path(p_t));
    printf("Calcolo l'altezza dell'albero: %d\n", height(p_t));
    printf("Calcolo la media dei valori contenuti nell'albero: %f\n", average(p_t));
    printf("Verifico se l'albero e' completo: %d\n", complete(p_t));

    printf("stampo l'albero: ");
    tree_print(p_t);
    printf("\n");


    sub_tree_remove(p_t, p_t);
    printf("stampo l'albero: ");
    tree_print(p_t);
    printf("\n");

    tree_remove(p_t);
}