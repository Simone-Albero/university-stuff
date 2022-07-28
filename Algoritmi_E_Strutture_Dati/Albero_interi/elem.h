#ifndef _ELEM_H
#define _ELEM_H

#include "list.h"

void* new_data (int elem);
int elem_compare(NODE* p_n, void* value);

/*operazioni su lista*/
void print_list (LIST p_l);
NODE* search (LIST p_l, int value);

void ordered_insertion (LIST* p_l, void* value);
LIST merge_ordered_list (LIST p_l1, LIST p_l2);


#endif