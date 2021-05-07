#include <stdlib.h>
#include <stdio.h>

#include "list.h"
#include "elem.h"

int main(){
    LIST p_l = NULL;
    LIST p_l2 = NULL;

    for(int i = 0; i < 50; i++){
        ordered_insertion (&p_l, new_data(i+1));
        print_list(p_l);
    }


    for(int i = 0; i <= 10; i++){
        printf("creco e cancello l'elemento %d: \n", (i+1)*3);
        NODE* temp = search(p_l, (i+1)*3);
        delete(&p_l, temp);
        print_list(p_l);
    }

    ordered_insertion (&p_l, new_data(3));
    print_list(p_l);

    delete_last(p_l);
    print_list(p_l);    

    printf("Creo la seconda lista: \n");
    for(int i = 0; i <= 4   ; i++){
        ordered_insertion (&p_l2, new_data(i+1));
        print_list(p_l2);
    }

    printf("Merge delle liste: \n");
    LIST p_l3 = merge_ordered_list (p_l, p_l2); 
    print_list(p_l3);

    printf("Reverse della lista: \n");
    reverse_list(&p_l2);
    print_list(p_l2);

}