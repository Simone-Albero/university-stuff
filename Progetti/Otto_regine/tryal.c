#include <stdlib.h>
#include <stdio.h>

#include "queen.h"
#include "tryal.h"
#include "list.h"


int evaluate_row(int data[8][8], int row){

    for(int i = 0; i < SIZE; i++){
        if(data[row][i] == 1){
            return 0;
        }
    }

    return 1;
}

int evaluate_col(int data[8][8], int col){

    for(int i = 0; i < SIZE; i++){
        if(data[i][col] == 1){
            return 0;
        }
    }

    return 1;
}

/*funzioni nascoste*/

int front_diag_1(int data[8][8], int row, int col){ //controllo la parte anteriore della prima diagonale

    while(row < SIZE && col < SIZE){ 
        if(data[row][col] == 1)
            return 0;
        row++;
        col++;
    }

    return 1;
}

int back_diag_1(int data[8][8], int row, int col){ //controllo la parte posteriore della prima diagonale

    while(row >= 0 && col >= 0){ 
        if(data[row][col] == 1)
            return 0;
        row--;
        col--;
    }

    return 1;    
}

int front_diag_2(int data[8][8], int row, int col){  //controllo la parte anteriore della seconda diagonale

    while(row >= 0 && col < SIZE){ 
        if(data[row][col] == 1)
            return 0;
        row--;
        col++;
    }

    return 1;    
}

int back_diag_2(int data[8][8], int row, int col){  //controllo la parte posteriore della seconda diagonale

    while(row < SIZE && col >= 0){ 
        if(data[row][col] == 1)
            return 0;
        row++;
        col--;
    }

    return 1;    
}


int evaluate_diag(int data[8][8], int row, int col){
    return front_diag_1(data, row, col) && back_diag_1(data, row, col) && front_diag_2(data, row, col) && back_diag_2(data, row, col);  
}

int new_try(T_NODE* p_n, LIST* p_l){
    T_NODE* temp;

    for(int i = 0; i < SIZE; i++){
        for(int j = 0; j < SIZE; j++){ 
            if(evaluate_col(p_n->data, j) && evaluate_diag(p_n->data, i, j) && evaluate_row(p_n->data, i)){ //se la posizione è accettabile 
                if(p_n->child == NULL){ //se non ho figli 
                    temp = new_child(p_n, i, j); //creo un figlio
                    push(p_l, (void*)temp);
                }
                else{
                    temp = new_brother(p_n->child, i, j); //creo un fratello
                    push(p_l, (void*)temp);
                }
            }
        }
    }

}

int evaluate_try(T_NODE* p_n){
    int flag = 0;

    for(int i = 0; i < SIZE; i++){
        for(int j = 0; j < SIZE; j++){ 
            if(p_n->data[i][j] == 1)
                flag++;
        }
    }

    if(flag == 8)
        return 1;
    else 
        return 0;
}


int chek_solution(LIST p_l, T_NODE* p_n){
    int flag = 1;


    while(p_l!=NULL){

        for(int i = 0; i < SIZE; i++){
            for(int j = 0; j < SIZE ; j++){
                if(p_n->data[i][j] != ((T_NODE*)p_l->data)->data[i][j])
                    flag = 0;
            }
        }

        if(flag == 1)
            return 0;

        p_l = p_l->next;
        flag = 1;
    }

    return flag;
}