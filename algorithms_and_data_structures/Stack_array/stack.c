#include <stdio.h>
#include <stdlib.h>

#include "stack.h"

STACK* new_stack(int size){
    STACK* ps = (STACK*)malloc(sizeof(STACK));
    ps->data = (int*)calloc(size, sizeof(int)); 
    ps->size = size;
    ps->top = -1;
}

void push(STACK* ps, int elem){
    if(ps->top+1 == ps->size){
        printf("Realloco array!!\n");
        ps->size = 2 * ps->size;
        int* new_data = (int*)realloc(ps->data, ps->size*sizeof(int));
        ps->data = new_data;
    }

    ps->data[ps->top+1] =  elem;
    ps->top = ps->top+1;
}

int pop(STACK* ps){
    if(ps->top == -1){
        printf("Pila vuota!!\n");
        exit(1);
    }
    int temp = ps->data[ps->top];
    ps->top = ps->top -1;
    return temp;
}

int is_empty(STACK* ps){
    return ps->top == -1;
}

int top(STACK* ps){
    if(ps->top == -1){
        printf("Pila vuota!!\n");
        exit(1);
    }
    return ps->data[ps->top];
}

void empty(STACK* ps){
    printf("Cancello Pila!!\n");
    free(ps->data);
    free(ps);
}

void stack_print(STACK* ps){
    printf("[ ");
    for(int i = 0; i <= ps->top; i++){
        printf("%d, ", ps->data[i]);
    }
    printf("]\n\n");
}

