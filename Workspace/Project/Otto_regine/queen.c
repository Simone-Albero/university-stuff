#include <stdlib.h>
#include <stdio.h>

#include "queen.h"

#define NULL_VALUE 0
#define QUEEN 1
/*funzione nascosta*/

T_NODE* create_node(){ //crea un nuovo nodo con tutti i valori nulli
    T_NODE* new_n = (T_NODE*)malloc(sizeof(T_NODE));
    new_n->parent = NULL;
    new_n->child = NULL;
    new_n->brother = NULL;

    for(int i = 0; i < SIZE; i++){
        for(int j = 0; j < SIZE ; j++)
            new_n->data[i][j] = NULL_VALUE;
    }

    return new_n;
}

void new_root(TREE* p_t){
    T_NODE* new_n = create_node();
    p_t->root = new_n;
} 

/*funzioni nascoste*/


T_NODE* new_child(T_NODE* p_n, int raw, int col){ //inserisce il nuovo figlio in cascata al padre
    T_NODE* new_n = create_node();
    new_n->parent = p_n;

    for(int i = 0; i < SIZE; i++){ //copia la matrice del padre
        for(int j = 0; j < SIZE ; j++)
            new_n->data[i][j] = p_n->data[i][j];
    }

    new_n->data[raw][col] = QUEEN; //inserisce una nuova regina

    p_n->child = new_n;
    return new_n;
}

T_NODE* new_brother(T_NODE* p_n, int raw, int col){ //inserisce il nuovo figlio in cascata al fratello
    T_NODE* new_n = create_node();
    new_n->parent = p_n->parent;
    p_n->brother = new_n;

    for(int i = 0; i < SIZE; i++){ //copia la matrice del padre
        for(int j = 0; j < SIZE ; j++)
            new_n->data[i][j] = p_n->parent->data[i][j];
    }

    new_n->data[raw][col] = QUEEN; //inserisce una nuova regina
    return new_n;
}

int height(T_NODE* p_n){
    if(p_n == NULL)
        return 0;

    else{
        int h_1 = 1 + height(p_n->child);
        int h_2 = height(p_n->brother);

        if(h_1 > h_2)
            return h_1;
        else 
            return h_2; 
    }

}