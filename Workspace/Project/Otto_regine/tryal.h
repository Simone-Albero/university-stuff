#ifndef _TRYAL_H
#define _TRYAL_H

#include "list.h"

int evaluate_row(int data[8][8], int row);
int evaluate_col(int data[8][8], int col);
int evaluate_diag(int data[8][8],int row, int col);

int new_try(T_NODE* p_n, LIST* p_l); //preso un nodo padre crea tutti i possibili figli
int evaluate_try(T_NODE* p_n);

int chek_solution(LIST p_l, T_NODE* p_n);

#endif