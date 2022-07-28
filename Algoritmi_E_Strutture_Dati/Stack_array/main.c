#include <stdio.h>
#include <stdlib.h>

#include "stack.h"
#define DEF_SIZE 10
#define E 30

int main(){
    STACK* ps = new_stack(DEF_SIZE);
    printf("Stampo \"1\" se la pila %c vuota: %d\n", E, is_empty(ps));

    for(int i = 0; i < 50; i++){
        if((i+1) % 5 == 0){
            printf("Eseguo la pop di: %d!!\n\n", pop(ps));
        }
        else{
            printf("Inerisco l'elemento: %d\n", i+1);
            push(ps,i+1);
            stack_print(ps);
        }
    }

    empty(ps);
}