#ifndef _BST_H
#define _BST_H

typedef struct t_node{
    struct t_node* parent;
    struct t_node* left;
    struct t_node* right;
    int info;
}T_NODE;


typedef T_NODE* TREE;

int tree_insert(TREE *p_t, int info);

T_NODE* tree_minimum(TREE p_t);
T_NODE* tree_maximum(TREE p_t);

void tnode_delete(TREE* p_t, T_NODE* p_n);

#endif