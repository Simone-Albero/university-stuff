#ifndef _LIST_H
#define _LIST_H

typedef struct node{
    void* data;
    struct node* next;
    struct node* prev;
}NODE;

typedef NODE* LIST;




NODE* insert (LIST* p_l, void* value); //inserimento in testa
void insert_before (LIST* p_l, void* value, NODE* index);

void add (LIST* p_l, void*  value); //inserimento in coda
void add_after (LIST p_l, void* value, NODE* index);

void delete_first (LIST* p_l); //rimozione primo elemento
void delete_last (LIST p_l);    //rimozione in coda 
void delete (LIST* p_l, NODE* index); //rimozione elemento per riferimento

int is_empty (LIST p_l);
void empty (LIST* p_l);
int find(LIST p_l, NODE* index); //confronta i nodi

void reverse_list(LIST* p_l);

/*definizione alternativa funzioni*/

void push(LIST* p_l, void* value); //richiama la insert
void pop(LIST* p_l); //richiama la delete_first

void enqueue(LIST* p_l, void*  value); //richiama la add
void dequeue(LIST* p_l); //richiama la delete_first


#endif