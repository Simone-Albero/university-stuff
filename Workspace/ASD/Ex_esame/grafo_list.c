#include <stdlib.h>
#include <stdio.h>

/*
#include "list.h"
#include "grafo_mat.h"
*/

#include "grafo_list.h"


LIST_GRAPH* new_list_graph(int n_node){
    LIST_GRAPH* p_g = (LIST_GRAPH*)malloc(sizeof(LIST_GRAPH));

    p_g->node = (LIST*)malloc(n_node * sizeof(LIST));
    p_g->n_node= n_node;

    return p_g;
}

void new_list_edge(int node, int value, int flag, LIST_GRAPH* p_g){
    if(flag == 1){ //il grafo è indiretto
        int* elem= (int*)malloc(sizeof(int));
        *elem= value;
        push(&(p_g->node[node]), (void*)elem); 

        if(node != value){
            elem= (int*)malloc(sizeof(int));
            *elem= node;
            push(&(p_g->node[value]), (void*)elem); 
        }

    }

    else{
        int* elem= (int*)malloc(sizeof(int));
        *elem= value;
        push(&(p_g->node[node]), (void*)elem); 
    }
    
}

void list_graph_print(LIST_GRAPH* p_g){
    for(int i = 0; i < p_g->n_node; i++){
        printf("[%d] --> ", i);
        NODE* curr_node= p_g->node[i];

        while(curr_node!=NULL){
            printf("%d ", *((int*)curr_node->data));

            curr_node= curr_node->next;
        }
        printf("\n");
    }
}

MAT_GRAPH* to_matrix(LIST_GRAPH* p_g){

    MAT_GRAPH* p_g2 = new_mat_graph(p_g->n_node);

    for(int i = 0; i < p_g->n_node; i++){
        NODE* p_n= p_g->node[i];

        while(p_n != NULL){
            new_mat_edge(i, *((int*)p_n->data), 0, p_g2);
            p_n= p_n->next;
        }
    }

    return p_g2;
}

int edge_chek(LIST_GRAPH* p_g, int node, int value){
    NODE* p_n= p_g->node[node];

    while(p_n != NULL){
        if(*((int*)p_n->data) == value)
            return 1;
        p_n = p_n->next;
    }

    return 0;
}

int source_chek(LIST_GRAPH* p_g, int node){
    for(int i = 0; i < p_g->n_node; i++){
        NODE* p_n = p_g->node[i];

        while(p_n != NULL){
            if(*((int*)p_n->data) == node)
                return 0;
            p_n = p_n->next;
        }
    }

    return 1;
    
}

int well_chek(LIST_GRAPH* p_g, int node){
    return p_g->node[node] == NULL;
}

//struttura di supporto
typedef struct elem_queue{
    int* array;
    int head;
    int tail;
    int n_elem;
}ELEM_QUEUE;

ELEM_QUEUE* new_elem_queue(int n_elem){
    ELEM_QUEUE* p_q = (ELEM_QUEUE*)malloc(sizeof(ELEM_QUEUE)); 
    p_q->array= (int*)calloc(n_elem, sizeof(int));
    p_q->head = 0;
    p_q->tail= 0;
    p_q->n_elem = n_elem;
    return p_q;
}

void elem_enqueue(ELEM_QUEUE* p_q, int elem){
    if((p_q->tail+1)%p_q->n_elem == p_q->head)
        return; //coda piena

    p_q->array[p_q->tail]= elem;
    p_q->tail= (p_q->tail+1)%p_q->n_elem;
}

int elem_dequeue(ELEM_QUEUE* p_q){
    int elem= p_q->array[p_q->head];
    p_q->head = (p_q->head+1)%p_q->n_elem;

    return elem;
}


void bfs_list(int n, LIST_GRAPH* p_g, int* color, int mark){
    ELEM_QUEUE* p_q = new_elem_queue(p_q->n_elem); //coda di appoggio

    //metto in coda il primo elemento
    elem_enqueue(p_q, n);

    //finchè trovo componenti connesse
    while(p_q->tail != p_q->head){
        int elem = elem_dequeue(p_q);
        NODE* p_n = p_g->node[elem];

        while(p_n != NULL){
            int curr = *((int*)p_n->data);
            if(color[curr] == 0){
                color[curr] = mark;
                elem_enqueue(p_q, curr);
            }
            p_n = p_n->next;
        }
    }
}

void dfs_list(int n, LIST_GRAPH* p_g, int* color, int mark){
    NODE* p_n= p_g->node[n];
    
    while(p_n != NULL){
        int curr= *((int*)p_n->data);
        if(color[curr]==0){
            color[curr]= mark;
            dfs_list(curr, p_g, color, mark);
        }
        p_n= p_n->next;
    }

}

int connected_node(int n, LIST_GRAPH* p_g, int* color, int mark){
    NODE* p_n= p_g->node[n];
    int flag= 1;
    color[n]= mark;


    while(p_n != NULL){
        int curr= *((int*)p_n->data);
        if(color[curr]==0){
            color[curr]= mark;
            flag= flag + connected_node(curr, p_g, color, mark);
        }
        p_n= p_n->next;
    }
    return flag;
}