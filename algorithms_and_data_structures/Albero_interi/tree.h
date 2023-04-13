#ifndef _TREE
#define _TREE


typedef struct node{
    int info; 
    struct node* parent; 
    struct node* left; 
    struct node* right;
}NODE;

typedef NODE* TREE;

void add_root(TREE* p_t, int value);
NODE* add_left(NODE* p_t, int value);
NODE* add_right(NODE* p_t, int value);

NODE* tree_search(TREE p_t, int value);

int node_count(TREE p_t); //conta i nodi
int path(TREE p_t); //verifica sell'albero è un cammino
int height(TREE p_t); //altezza albero
float average(TREE p_t); //media valori albero
int complete(TREE p_t); //verifica se l'albero è completo

void tree_remove(TREE p_t);
void tree_print(TREE p_t);
void sub_tree_remove(TREE p_t, NODE* p_n);


//esercizi prova di esame
int verifica(NODE* p_n);
int conta_discendenti(NODE* p_n);
int verifica_profondita_nodi(TREE p_t, NODE* p_n, int depth);
#endif