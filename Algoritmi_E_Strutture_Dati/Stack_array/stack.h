#ifndef _STACK_H
#define _STACK_H

typedef struct stack{
    int* data;
    int size;
    int top;
} STACK;

STACK* new_stack(int size);
void push(STACK* ps, int elem);
int pop(STACK* ps);

int is_empty(STACK* ps);
int top(STACK* ps);
void empty(STACK* ps);

void stack_print(STACK* ps);

#endif