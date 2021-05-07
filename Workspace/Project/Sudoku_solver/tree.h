#ifndef _TREE_H
#define _TREE_H

#include "game.h"

typedef struct t_node{//inserisci pila di tentativi 
    struct t_node* parent;
    struct t_node* child;
    struct t_node* brother;

    STATUS* data;
}T_NODE;

typedef struct tree{
    T_NODE* root;
}TREE;

TREE* new_tree(int** data);

T_NODE* new_child(T_NODE* p_t, int row, int col);

T_NODE* new_brother(T_NODE* p_t, int row, int col);

#endif

