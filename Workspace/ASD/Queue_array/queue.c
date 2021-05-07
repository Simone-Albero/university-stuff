#include <stdio.h>
#include <stdlib.h>

#include "queue.h"


QUEUE* new_queue(int size){
    QUEUE* pq = (QUEUE*)malloc(sizeof(QUEUE));
    pq->data = (int*)calloc(size, sizeof(int));
    pq->head = 0;
    pq->tail = 0;
    pq->size = size;

    return pq;
}

void empty(QUEUE* pq);

void enqueue(QUEUE* pq, int elem){
    if(pq->head == (pq->tail+1) % pq->size){
        printf("Realloco array!!\n");
        int* new_data = (int*)calloc(pq->size*2, sizeof(int));
        for(int i = 0; i < pq->size-1; i++){
            new_data[i] = pq->data[(pq->head+i) % pq->size];
        }
        free(pq->data);
        pq->data = new_data; 
        pq->head = 0;
        pq->tail = pq->size-1;
        pq->size = pq->size*2; 
    }

    pq->data[pq->tail] = elem;
    pq->tail = (pq->tail+1) % pq->size;

}

int dequeue(QUEUE* pq){
    if( pq->head == pq->tail ){
		printf("Dequeue su coda vuota!!\n");
        exit(1);
    }
    int temp = pq->data[pq->head];
    pq->head= (pq->head+1) % pq->size;
    return temp;
}

int is_empty(QUEUE* pq){
    return pq->head == pq->tail;
}

int front(QUEUE* pq){
    return pq->data[pq->head];
}

void queue_print(QUEUE* pq){
    printf("[");
    for(int i = pq->head; i != pq->tail ; i= (i+1) % pq->size){
        printf("%d, ", pq->data[i]);
    }
    printf("]\n\n");
}