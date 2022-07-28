#ifndef _GRAHO_OB_H
#define _GRAFO_OB_H

#include "list.h"

typedef struct ob_graph{
    LIST node; //lista di nodi
    LIST edge; //lista di archi

    int n_node;
    int n_edge;
}OB_GRAPH;

typedef struct g_node{
    NODE* pos; //posizone nella lista dei nodi
    LIST in_edge; //archi entranti
    LIST out_edge; //archi uscenti
    int key; //ID del nodo
    int color;
}G_NODE;

typedef struct g_edge{
    NODE* pos; //posizione nella lista degli archi
    NODE* from_pos; //posizione del nodo puntato nella lista dei nodi
    NODE* to_pos;

    G_NODE* from;
    G_NODE* to;

}G_EDGE;

OB_GRAPH* new_ob_graph(); //restituisce un puntatore ad un grafo vuoto


//inserisce un nuovo nodo nel grafo inizializzando: 
//la lista di archi a NULL
//il colore a 0
void new_ob_node(OB_GRAPH* p_g); 

//inserisco un nuovo arco nel grafo inizializzando:
//i nodi from e pos
//le reispettive posizione nella lista 
void new_ob_edge(OB_GRAPH* p_g, G_NODE* n_from, G_NODE* n_to);


//prende il riferimento ad un arco e lo cancella
void ob_edge_destroy(OB_GRAPH* p_g, G_EDGE* p_e);

//prende il riferimento ad un nodo e lo concella
void node_edge_destroy(OB_GRAPH* p_g, NODE* p_n);
void ob_node_destroy(OB_GRAPH* p_g, G_NODE* p_n);

//stampa il grafo nella rappresentzione lista di adiacenza
void ob_graph_print(OB_GRAPH* p_g);

//bfs che colora i nodi e restituisce il numero di componenti connesse
int ob_grapg_dfs(G_NODE* p_n, int mark);


#endif