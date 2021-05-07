#include <stdio.h>
#include <stdlib.h>

#include "tree.h"

/*funzioni nascoste*/

NODE* create_node(int value){
    NODE* new_n = (NODE*)malloc(sizeof(NODE));
    new_n->info = value;
    new_n->left = NULL;
    new_n->right = NULL;

    return new_n;
}




void add_root(TREE* p_t, int value){
    NODE* new_n = create_node(value);
    new_n->parent = NULL;
    *p_t = new_n;
}

NODE* add_left(NODE* p_t, int value){
    NODE* new_n = create_node(value);
    new_n->parent = p_t;
    p_t->left = new_n;

    return new_n;
}

NODE* add_right(NODE* p_t, int value){ 
    NODE* new_n = create_node(value);
    new_n->parent = p_t;
    p_t->right = new_n;

    return new_n;
}

NODE* tree_search(TREE p_t, int value){
    if(p_t == NULL) 
        return NULL;

    if(p_t->info == value)
        return p_t;

    NODE* temp = tree_search(p_t->left, value);
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

void sub_tree_remove(TREE p_t, NODE* p_n){
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
    
//verifica se esiste un sotto albero avente la metà dei nodi dell'albero


//funzione di supplemento   
int cerca_sottoalbero(NODE* p_n, int t_node){
    if(p_n == NULL)
        return 0;

    if(node_count(p_n) == t_node)
        return 1;
    else
        return cerca_sottoalbero(p_n->left, t_node) || cerca_sottoalbero(p_n->right, t_node);

}




int verifica(NODE* p_n){
    if(p_n==NULL)
        return 0;

    //conto i nodi dell'albero
    int t_node = node_count(p_n);
    
    if((t_node % 2) != 0)
        return 0;

    return cerca_sottoalbero(p_n, t_node/2);
}

//conta i nodi aventi come campo info la somma dei discendenti

int conta_discendenti(NODE* p_n){
    if(p_n == NULL)
        return 0;
    
    int flag = 0;

    if(node_count(p_n)==p_n->info)
        flag++;
    
    flag= flag + conta_discendenti(p_n->left) + conta_discendenti(p_n->right);

    return flag;


}


//verifica se esiste un livello di profondità pari al numero di nodi del livello stesso
int conta_nodi_profondita(NODE* p_n, int depht){
    if(p_n == NULL)
        return 0;
    
    if(depht == 0)
        return 1;
    else
        return conta_nodi_profondita(p_n->left, depht-1) + conta_nodi_profondita(p_n->right, depht-1);
}

int verifica_profondita_nodi(TREE p_t, NODE* p_n, int depth){
    if(p_n == NULL)
        return 0;
    
    if(conta_nodi_profondita(p_t, depth) == depth)
        return 1;
    else
        return verifica_profondita_nodi(p_t, p_n->left, depth+1) || verifica_profondita_nodi(p_t, p_n->right, depth+1);
}

