#include <stdlib.h>
#include <stdio.h>

#include "list.h"

/*funzioni nascoste*/
NODE* node_init(void* value){
    NODE* new_n = (NODE*)malloc(sizeof(NODE));
    new_n->data = value;
    new_n->next = NULL;
    new_n->prev = NULL;
    return new_n;
}

void node_remove(NODE* p_n){
    free(p_n);
}





void insert (LIST* p_l, void* value){ //inserimento in testa
    NODE* new_n = node_init(value);
    new_n->next = *p_l;

    if(*p_l != NULL) //se la lista non è vuota aggiorno il prev di p_l
        (*p_l)->prev = new_n;

    *p_l = new_n;
}

void insert_before (LIST* p_l, void* value, NODE* index){ //inserimento prima dell'indice
    if(!find(*p_l, index)){
        printf("Elemento esterno alla lista!!\n");
        exit(-1);
    }

    if(*p_l == NULL || index == NULL){
        printf("Lista vuota o indice nullo!!\n");
        exit(-1);
    }

    if(index == *p_l){ //se l'indice è il primo elemento;
        insert(p_l, value);
    }

    else{
        NODE* new_n = node_init(value);
        NODE* temp_index = *p_l;

        while(temp_index != index)
            temp_index = temp_index->next;

        
        /*aggiorno gli indici di new_n*/
        new_n->next = temp_index;
        new_n->prev = temp_index->prev;
        /*aggiorno gli indici del prev e next di new_n*/
        temp_index->prev->next = new_n;
        temp_index->prev= new_n;

    }
}

void add (LIST* p_l, void*  value){ //inserimento in coda
    NODE* new_n = node_init(value);

    if(*p_l == NULL) //la lista è vuota
        *p_l = new_n;

    else{ //la lista non è vuota
        NODE* index = *p_l; 
        while(index->next != NULL){
            index = index->next;
        }
        new_n->prev = index;
        index->next = new_n;
        
    }
}

void add_after (LIST p_l, void* value, NODE* index){ //inserimento dopo l'indice
    if(!find(p_l, index)){
        printf("Elemento esterno alla lista!!\n");
        exit(-1);
    }
    
    if(p_l == NULL || index == NULL){
        printf("Lista vuota o indice nullo!!\n");
        exit(-1);
    }

    NODE* new_n = node_init(value);

    while(p_l != index)
        p_l = p_l->next;
    
    if(p_l->next == NULL){//se l'indice è l'ultimo elemento
        p_l->next = new_n;
        new_n->prev = p_l;
    }
    else{
        /*aggiorno gli indici di new_n*/
        new_n->next = p_l->next;
        new_n->prev = p_l;
        /*aggiorno gli indici del prev e next di new_n*/
        p_l->next->prev = new_n;
        p_l->next = new_n;   
    }
   
}

NODE* delete_first (LIST* p_l){ //rimozione primo elemento
    if(*p_l == NULL){
        printf("Lista vuota!!\n");
        exit(-1);
    }
    
    NODE* temp = *p_l;
    *p_l = temp->next;
    (*p_l)->prev = NULL;
    return temp;
}

NODE* delete_last (LIST p_l){   //rimozione in coda (implementa)
    if(p_l == NULL){
        printf("Lista vuota!!\n");
        exit(-1);
    }

    while(p_l->next != NULL)
        p_l = p_l->next;
    
    p_l->prev->next = NULL;
    return p_l;
}

void delete (LIST* p_l, NODE* index){ //rimozione elemento per riferimento
    if(!find(*p_l, index)){
        printf("Elemento esterno alla lista!!\n");
        exit(-1);
    }
    if(*p_l == NULL || index == NULL){
        printf("Lista vuota o puntatore nullo!!\n");
        exit(-1);
    }

    if(index == *p_l)//se l'indice è il primo elemento
        delete_first(p_l);
    else{
        NODE* temp_index = *p_l;
        while(temp_index != index)   
            temp_index = temp_index->next;
        
        if(temp_index->next == NULL){// se l'indice è l'ultimo elemento
            temp_index->prev->next = NULL;
        }
        else{
            temp_index->next->prev = temp_index->prev;
            temp_index->prev->next = temp_index->next;
        }
        node_remove(temp_index);
    }
    
    

}

int is_empty (LIST p_l){
    return p_l == NULL;
}

void empty (LIST* p_l);

int find(LIST p_l, NODE* index){

    while(p_l != NULL){
        if(p_l == index)
            return 1;

        p_l = p_l->next;
    }

    return 0;
}


//printf("p_l: (%d) \n", *((int*)p_l->data));
/*
void reverse_list(LIST p_l){

    NODE* p_n1 = p_l;
    NODE* p_n2 = p_l->next;

    if(p_n2->next == NULL){//se ho solo due elementi, li inverto
        void* temp = p_n2->data;
        p_n2->data = p_n1->data;
        p_n1->data = temp;
    }
    
    else{

        //p_n1 = p_l;
        //p_n2 = p_l->next;  

        reverse_list(p_l->next); 


        printf("p_l1: (%d) \n", *((int*)p_n1->data));
        printf("p_l2: (%d) \n", *((int*)p_n2->data));

        void* temp = p_n2->data;
        p_n2->data = p_n1->data;
        p_n1->data = temp;  
    }
}*/



NODE* reverse_list_ric(LIST* p_l, NODE* p_n){

    
    if(p_n->next->next == NULL){ //passo base: 
        *p_l = p_n->next;
        (*p_l)->next = p_n;
        return p_n;
    }


    else{ //passo ricorsivo:
        NODE* temp = reverse_list_ric(p_l, p_n->next);
        temp->next = p_n;
        return p_n;
        
    }
}


void reverse_list(LIST* p_l){
    NODE* p_n = (*p_l);
    reverse_list_ric(p_l, p_n)->next = NULL;
}



/*definizione alternativa funzioni*/

void push(LIST* p_l, void* value){
    add(p_l, value);
}

NODE* pop(LIST p_l){
   NODE* p_n = delete_last(p_l);
   return p_n;
}

void enqueue(LIST* p_l, void*  value){
    add(p_l, value);
}

void dequeue(LIST* p_l){
    delete_first(p_l);
}

