#ifndef _LIST_H
#define _LIST_H

typedef struct list{
    int size;
    int head;
    int free;
    int* info;
    int* prev;
    int* next;
}LIST;


LIST* new_list(int size);

void insert(LIST* pl, int elem);
void delete(LIST* pl, int index);

int allocate_column(LIST* pl);
void free_column(LIST* pl, int index);

int is_empty(LIST* pl);
void empty(LIST* pl);
void list_print(LIST* pl);



#endif