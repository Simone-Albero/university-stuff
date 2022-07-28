#ifndef _QUEEN_H
#define _QUEEN_H

#define SIZE 8


typedef struct t_node{
    struct t_node* parent; //puntatore a padre
    struct t_node* child; //puntatore a figlio
    struct t_node* brother; //puntatore a fratello
    int data[SIZE][SIZE]; //matrice di gioco 8 x 8
}T_NODE;

typedef struct tree{
    T_NODE* root;
}TREE;

void new_root(TREE* p_t); //crea la radice (la cui matrice è vuota "0")

T_NODE* new_child(T_NODE* p_n, int raw, int col); //aggiunge un figlio (inserendo una nuova regina nella matrice)

T_NODE* new_brother(T_NODE* p_n, int raw, int col); //aggiunge un fratello (inserendo un'altra regina nella matrice)

int height(T_NODE* p_n);
#endif