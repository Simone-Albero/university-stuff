#ifndef _QUEUE_H
#define _QUEUE_H

typedef struct queue{
    int* data;
    int size; 
    int head; 
    int tail;

}QUEUE;

QUEUE* new_queue(int size);
void empty(QUEUE* pq);

void enqueue(QUEUE* pq, int elem);
int dequeue(QUEUE* pq);

int is_empty(QUEUE* pq);
int front(QUEUE* pq);

void queue_print(QUEUE* pq);


#endif