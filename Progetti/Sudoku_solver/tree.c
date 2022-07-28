#include <stdlib.h>
#include <stdio.h>

#include "tree.h"




/*funzione di supporto*/
T_NODE* new_node(){
    T_NODE* p_n= (T_NODE*)malloc(sizeof(T_NODE));
    p_n->brother= NULL;
    p_n->child= NULL;
    p_n->data= NULL;
    p_n->parent= NULL;

    return p_n;
}


TREE* new_tree(int** data){
    TREE* p_t= (TREE*)malloc(sizeof(TREE));
    T_NODE* p_n= new_node();

    p_n->data= new_status(data);
    p_t->root= p_n;

    return p_t;
}

T_NODE* new_child(T_NODE* p_t, int row, int col){

    if(p_t->data->tryal==NULL)
        return NULL;

    T_NODE* new_n= new_node();
    new_n->parent= p_t;
    p_t->child= new_n;

    new_n->data= new_status(p_t->data->matrix);
    new_n->data->matrix[row][col]= *((int*)pop(&p_t->data->tryal));

    return new_n;
}



T_NODE* new_brother(T_NODE* p_t, int row, int col){

    T_NODE* new_n= new_node();
    new_n->parent= p_t->parent;
    p_t->brother= new_n;

    new_n->data= new_status(p_t->parent->data->matrix);
    new_n->data->matrix[row][col]= *((int*)pop(&(p_t->parent->data->tryal)));

    return new_n;
}


