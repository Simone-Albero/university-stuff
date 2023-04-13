#include <stdlib.h>
#include <stdio.h>

#include "queue.h"
#define DEF_SIZE 10

int main(){
    QUEUE* pq = new_queue(DEF_SIZE);

    for(int i = 0; i < 20; i++){
        if((i+1)% 5 == 0){
            printf("Dequeue di: %d\n", front(pq));
            dequeue(pq);
            queue_print(pq);
        }

        else{
            printf("Enqueue di %d:\n", i+1);
            enqueue(pq, i+1);
            queue_print(pq);
        }

    } 



}