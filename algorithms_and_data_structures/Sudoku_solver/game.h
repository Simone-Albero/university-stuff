#ifndef _GAME_H
#define _GAME_H

#define N_ELEM 9
#define x 0
#define y 1

#include "list.h"

typedef struct status{
    int** matrix;
    LIST tryal;
}STATUS;

STATUS* new_status(int** data);

int* next_elem(int** data); // 0->cordinata x 1->cordinata y

void elem_analyze(int** data, int row, int col, LIST* p_l);

int is_complete(int** data);

#endif