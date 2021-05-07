#ifndef _TREE_H
#define _TREE_H


typedef struct t_node{
    int info; 
    struct t_node* parent; 
    struct t_node* left; 
    struct t_node* right;
}T_NODE;

typedef T_NODE* TREE;

void add_root(TREE* p_t, int value);
T_NODE* add_left(T_NODE* p_t, int value);
T_NODE* add_right(T_NODE* p_t, int value);

T_NODE* tree_search(TREE p_t, int value);

int node_count(TREE p_t); //conta i nodi
int path(TREE p_t); //verifica sell'albero è un cammino
int height(TREE p_t); //altezza albero
float average(TREE p_t); //media valori albero
int complete(TREE p_t); //verifica se l'albero è completo

void tree_remove(TREE p_t);
void tree_print(TREE p_t);
void sub_tree_remove(TREE p_t, T_NODE* p_n);

/*funzioni per albero arbitrario*/
T_NODE* add_child(T_NODE* p_t, int value);
T_NODE* add_brother(T_NODE* p_t, int value);


#endif