#include <stdio.h>
#include <stdlib.h>

#include "tree.h"
#include "matrix.h"


//#include "game.h"

void list_print(LIST p_l){
    while(p_l!=NULL){
        printf("%d ", *((int*)p_l->data));
        p_l= p_l->next;
    }
    printf("\n");
}

int main(){
    TREE* p_t= new_tree(file_read());
    LIST p_l = NULL; //stack
    int cont= 0;

    printf("Matrice di partenza:\n");
    for(int i=0; i<9; i++){
        for(int j=0; j<9; j++){
            printf("%d ", p_t->root->data->matrix[i][j]);
        }
        printf("\n");
    }



    T_NODE* curr_n= p_t->root;
    push(&p_l, (void*)curr_n);
    
    while(!is_complete(curr_n->data->matrix)){
        
        cont++;
        /*printf("\nStato attuale:\n");
        for(int i=0; i<9; i++){
            for(int j=0; j<9; j++){
                printf("%d ", curr_n->data->matrix[i][j]);
            }
            printf("\n");
        }*/


        int* index= next_elem(curr_n->data->matrix);
        elem_analyze(curr_n->data->matrix, index[x], index[y], &curr_n->data->tryal);
        
        /*printf("Tentativi: ");
        list_print(curr_n->data->tryal);*/
        
        T_NODE* p_n= new_child(curr_n, index[x], index[y]);
        if(p_n!=NULL)
            push(&p_l, (void*)p_n);
        /*else
            printf("Pop da lista!\n");*/


        while(curr_n->data->tryal != NULL){
            new_brother(p_n, index[x], index[y]);
            p_n= p_n->brother;

            push(&p_l, (void*)p_n);  
        }
        curr_n= (T_NODE*)pop(&p_l);
    }

    printf("\nSoluzione in %d tentativi:\n", cont);
    for(int i=0; i<9; i++){
        for(int j=0; j<9; j++){
            printf("%d ", curr_n->data->matrix[i][j]);
        }
        printf("\n");
    }

}

