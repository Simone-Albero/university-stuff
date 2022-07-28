#include <stdlib.h>
#include <stdio.h>

#include "list.h"



void* new_data (int elem){
    int* data = (int*)malloc(sizeof(int));
    *data = elem;

    return (void*)data;
}

int elem_compare(void* value1, void* value2){
    return (*((int*)value1)) >= (*((int*)value2));
}

void print_list (LIST p_l){
    if(p_l == NULL){
        printf("Lista vuota!!\n");
        exit(-1);
    }

    printf("Lista: [");
    while(p_l != NULL){
        printf("%d ", *((int*)p_l->data));
        p_l = p_l->next; 
    }
    printf("]\n\n");
}

NODE* search (LIST p_l, int value){ //pre_cond: value è contenuto nella lsita ed è diverso da NULL

    while(p_l != NULL){ 
        if(*((int*)p_l->data) == value)
            return p_l;

        p_l = p_l->next;
    }
    
    return p_l;
} 

void ordered_insertion (LIST* p_l, void* value){
    if(*p_l == NULL)//se la lista è vuota
        insert(p_l, value);
    else{
        if(elem_compare((*p_l)->data, value)){//se è l'elemento minore della lista
            insert(p_l, value);
        }
        else{   
            NODE* index = *p_l;
            while(index!= NULL){
                if(elem_compare(index->data, value)){
                    insert_before(p_l, value, index);
                    return;
                }
                index = index->next;
            }
            add (p_l, value);

        }
    }
}


int node_compare(NODE* n1, NODE* n2){
    
    if(n1 == NULL )
        return 0;

    if(n2 == NULL )
        return 1;

    int value1 = *((int*)n1->data);
    int value2 = *((int*)n2->data);

    if (value1 <= value2)
        return 1;

    else
        return 0;
    
    
}



LIST merge_ordered_list (LIST p_l1, LIST p_l2){
    LIST  new_l = NULL;
    NODE* p_n1 = p_l1;
    NODE* p_n2 = p_l2;

    if(p_l1 == NULL && p_l2 == NULL) //se ho due liste vuote
        return new_l;
    
    if(p_l2 == NULL) //se la lista 12 è vuota, restituisco l1
        return p_l1;
    
    if(p_l1 == NULL) //se la lista 11 è vuota, restituisco l2
        return p_l2;

    while(p_n1 != NULL || p_n2 != NULL){

        if(node_compare(p_n1, p_n2)){
            add(&new_l, p_n1->data);
            p_n1 = p_n1->next; 
        }
        
        else {
            add(&new_l, p_n2->data);
            p_n2 = p_n2->next;
        }
        
    }

    return new_l;
}





