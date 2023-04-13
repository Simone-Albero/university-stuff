#include <stdio.h>
#include <stdlib.h>

#include "tree.h"

/*funzioni nascoste*/

T_NODE* create_node(int value){
    T_NODE* new_n = (T_NODE*)malloc(sizeof(T_NODE));
    new_n->info = value;
    new_n->left = NULL;
    new_n->right = NULL;
    new_n->parent = NULL;

    return new_n;
}

void add_root(TREE* p_t, int value){
    T_NODE* new_n = create_node(value);
    *p_t = new_n;
}

T_NODE* add_left(T_NODE* p_t, int value){
    T_NODE* new_n = create_node(value);
    new_n->parent = p_t;
    p_t->left = new_n;

    return new_n;
}

T_NODE* add_right(T_NODE* p_t, int value){ 
    T_NODE* new_n = create_node(value);
    new_n->parent = p_t;
    p_t->right = new_n;

    return new_n;
}

T_NODE* tree_search(TREE p_t, int value){
    if(p_t == NULL) 
        return NULL;

    if(p_t->info == value)
        return p_t;

    T_NODE* temp = tree_search(p_t->left, value);
    if(temp != NULL)
        return temp;

    return tree_search(p_t->right, value);
        
}

int node_count(TREE p_t){
    if(p_t == NULL)
        return 0;
    
    return 1 + node_count(p_t->left) + node_count(p_t->right);
}

int path(TREE p_t){
    if(p_t == NULL)
        return 1;

    if(p_t->left != NULL && p_t->right != NULL)
        return 0;
    
    /*almeno uno tra right e left e non NULL*/
    return path(p_t->left) && path(p_t->right);
}

int height(TREE p_t){

    if(p_t == NULL)
        return -1;
    
    int left_heigh = 1 + height(p_t->left);
    int right_heigh = 1 + height(p_t->right);

    if(left_heigh > right_heigh)
        return left_heigh;
    else
        return right_heigh;
        
}

/*funzione di supplemento ad average*/

int summ(TREE p_t){
    if(p_t == NULL)
        return 0;

    return p_t->info + summ(p_t->left) + summ(p_t->right);
}


float average(TREE p_t){
    if(p_t == NULL){
        printf("Albero vuoto!!\n");
        exit(-1);
    }

    int t_summ = summ(p_t);
    printf("Summ: %d\n", t_summ);
    int t_node = node_count(p_t);

    return (float)t_summ / t_node;

}


/*funzione di supplemento*/

int node_complete(TREE p_t){
    if (p_t == NULL)
        return 1;
    if((p_t->left != NULL && p_t->right == NULL) || (p_t->right != NULL && p_t->left == NULL))
        return 0;
    else
        return node_complete(p_t->left) && node_complete(p_t->right);

}


int complete(TREE p_t){

    int n_complete = node_complete(p_t);

    int same_height = height(p_t->left) == height(p_t->right);

    return n_complete && same_height ;
}

void tree_remove(TREE p_t){
    if(p_t == NULL)
        return;
    
    else{
        tree_remove(p_t->left); 
        tree_remove(p_t->right); 
        free(p_t);
    }

}

void sub_tree_remove(TREE p_t, T_NODE* p_n){
    tree_remove(p_n->left);
    tree_remove(p_n->right);
    p_n->left = NULL;
    p_n->right = NULL;
}



void tree_print(TREE p_t){
    if(p_t == NULL)
        return;
    
    else{
        printf("%d ", p_t->info);
        tree_print(p_t->left); 
        tree_print(p_t->right); 
       
    }
    
}

/*funzioni per albero arbitrario*/

T_NODE* add_child(T_NODE* p_t, int value){
    return add_left(p_t, value);
}


T_NODE* add_brother(T_NODE* p_t, int value){
    T_NODE* p_n= add_right(p_t, value); 
    p_n->parent= p_t->parent;

    return p_n;
}