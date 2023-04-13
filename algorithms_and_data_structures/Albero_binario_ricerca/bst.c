#include <stdio.h>
#include <stdlib.h>

#include "bst.h"


T_NODE* node_create(int info){
    T_NODE* new_n = (T_NODE*)malloc(sizeof(T_NODE));
    new_n->parent = NULL;
    new_n->left = NULL;
    new_n->right = NULL;
    new_n->info = info;

    return new_n;
}


int bst_insert(T_NODE* p_t, T_NODE* p_n){
    if(p_n->info < p_t->info){
        if(p_t->left == NULL){
            p_t->left = p_n;
            p_n->parent = p_t;
            return 1;
        }

        else
            return bst_insert(p_t->left, p_n);
        
    }

    else if(p_n->info > p_t->info){
        if(p_t->right == NULL){
            p_t->right = p_n;
            p_n->parent = p_t;
            return 1;
        }

        else
            return bst_insert(p_t->right, p_n);
                
    }

    return 0;
}



int tree_insert(TREE* p_t, int info){
    T_NODE* new_n = node_create(info);

    if(*p_t == NULL){
        *p_t = new_n;
        return 1;
    }

    else{
        return bst_insert(*p_t, new_n);
    }
}


T_NODE* tree_minimum(TREE p_t){
    while(p_t->left != NULL)
        p_t = p_t->left;

    return p_t;
}



T_NODE* tree_maximum(TREE p_t){
    while(p_t->right != NULL)
        p_t = p_t->right;

    return p_t;  
}


void node_delete(T_NODE* p_n){
    free(p_n);
}



void tree_bypass(TREE* p_t, T_NODE* p_n){
    T_NODE* child;

    if(p_n->left != NULL)
        child = p_n->left;
    else 
        child = p_n->right;
    
    if(child != NULL){ //è NULL se p_n non ha filgi
        child->parent = p_n->parent;
    } //ho aggiornato il figlio

    if(p_n->parent != NULL){//aggiorno il padre
        if(p_n == p_n->parent->left)
            p_n->parent->left = child;
        else
            p_n->parent->right = child;
        
        node_delete(p_n);
    }

    else{
        *p_t = child;
        node_delete(p_n);
    }
}


void tnode_delete(TREE* p_t, T_NODE* p_n){
    if(p_n->left != NULL && p_n->right != NULL){
        T_NODE* temp = tree_minimum(*p_t);
        p_n->info = temp->info;
        tree_bypass(p_t, temp);
    }

    else{
        tree_bypass(p_t, p_n);
    }

}