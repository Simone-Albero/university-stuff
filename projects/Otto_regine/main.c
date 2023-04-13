#include <stdlib.h>
#include <stdio.h>

#include "queen.h"
#include "tryal.h"
#include "list.h"

int main(){
    TREE *p_t = (TREE *)malloc(sizeof(TREE));
    new_root(p_t);

    T_NODE *p_n;
    p_n = p_t->root;
    LIST p_l = NULL;

    LIST p_l2 = NULL;
    push(&p_l2, (void*)p_n);
    int flag = 0;

    while (flag < 100){
        new_try(p_n, &p_l);
        p_n = (T_NODE*)(pop(p_l)->data);
        
        if (evaluate_try(p_n) && chek_solution(p_l2, p_n)){

            printf("Stampo la soluzione numero %d: \n", flag + 1);
            for (int i = 0; i < SIZE; i++){
                for (int j = 0; j < SIZE; j++){
                    printf("%d  ", p_n->data[i][j]);
                }
                printf("\n");
            }

            flag++;
            push(&p_l2, (void*)p_n);

            char temp;
            scanf("%c", &temp);
        }

        
    }
}


/*
    while(!evaluate_try(p_n)){
        new_try(p_n, &p_l);
        p_n = (T_NODE*)(pop(p_l)->data);
    }

    printf("Stampo la soluzione: \n");
    for(int i = 0; i < SIZE; i++){
        for(int j = 0; j < SIZE ; j++){
            printf("%d  ", p_n->data[i][j]);
        }
        printf("\n");
    }
*/

/*
    while (flag < 2){
        new_try(p_n, &p_l);
        p_n = (T_NODE*)(pop(p_l)->data);
        
        if (evaluate_try(p_n) && chek_solution(p_l2, p_n)){

            printf("Stampo la soluzione numero %d: \n", flag + 1);
            for (int i = 0; i < SIZE; i++){
                for (int j = 0; j < SIZE; j++){
                    printf("%d  ", p_n->data[i][j]);
                }
                printf("\n");
            }

            flag++;
            push(&p_l2, (void*)p_n);

            char temp;
            scanf("%c", &temp);
        }
        flag++;
    }
*/