#include <stdio.h>
#include <stdlib.h>

#include "bst.h"



int main(){
    TREE p_t = NULL;
    tree_insert(&p_t, 5);
    tree_insert(&p_t, 6);
    tree_insert(&p_t, 2);
    tree_insert(&p_t, 3);
    tree_insert(&p_t, 8);

    printf("minimo: %d\n",(tree_minimum(p_t))->info);
    printf("massimo: %d\n",(tree_maximum(p_t))->info);

    tnode_delete(&p_t, tree_maximum(p_t));
    printf("massimo: %d\n",(tree_maximum(p_t))->info);
}