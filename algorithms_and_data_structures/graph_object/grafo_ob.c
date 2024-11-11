#include <stdlib.h>
#include <stdio.h>

#include "list.h"
#include "grafo_ob.h"


OB_GRAPH* new_ob_graph(){
    OB_GRAPH* p_g= (OB_GRAPH*)malloc(sizeof(OB_GRAPH));
    p_g->edge = NULL;
    p_g->node = NULL;
    p_g->n_edge = 0;
    p_g->n_node = 0;

    return p_g;
}


void new_ob_node(OB_GRAPH* p_g){
    G_NODE* p_n = (G_NODE*)malloc(sizeof(G_NODE));

    //inizializzo l'ID del nodo
    if(p_g->node == NULL)
        p_n->key = 0;
    else{
        p_n->key = (((G_NODE*)p_g->node->data)->key)+1;
    }

    //inizializzo il nodo (manca la posizione in lista)
    p_n->color = 0;
    p_n->in_edge = NULL;
    p_n->out_edge = NULL;
    //inserisco il nodo nel grafo
    p_g->n_node++;
    NODE* n_pos= insert(&(p_g->node), (void*)p_n);

    //inizializzo la posizione del nodo in lista
    p_n->pos = n_pos;

}


void new_ob_edge(OB_GRAPH* p_g, G_NODE* n_from, G_NODE* n_to){
    G_EDGE* p_e= (G_EDGE*)malloc(sizeof(G_EDGE));
    
    //inizializzo l'arco (manca la posizione in lista)
    p_e->from = n_from;
    p_e->to = n_to;

    //inserisco l'arco uscente nel nodo form
    NODE* e_pos= insert(&(n_from->out_edge), (void*)p_e);
    p_e->from_pos = e_pos;

    //inserisco l'arco nel nodo to
    e_pos= insert(&(n_to->in_edge), (void*)p_e);
    p_e->to_pos = e_pos;

    //inserisco l'arco nel grafo
    p_g->n_edge++;
    NODE* g_pos= insert(&(p_g->edge), (void*)p_e);

    //inizializzo la posizione dell'arco in lista
    p_e->pos = g_pos;

}



void ob_edge_destroy(OB_GRAPH* p_g, G_EDGE* p_e){
    //cancello l'arco dal grafo
    delete(&(p_g->edge), p_e->pos);
    p_g->n_edge--;
    //cancello l'arco dal nodo from
    delete(&(p_e->from->out_edge), p_e->from_pos);

    //cancello l'arco dal nodo to
    delete(&(p_e->to->in_edge), p_e->to_pos);

    //cancello l'arco
    free(p_e);
}


//funzione di supporto
//cancella ricorsivamenti tutti gli archi da una lista
void node_edge_destroy(OB_GRAPH* p_g, NODE* p_n){
    if(p_n == NULL)
        return;
    else{
        node_edge_destroy(p_g, p_n->next);
        ob_edge_destroy(p_g, (G_EDGE*)p_n->data);
    }

}

void ob_node_destroy(OB_GRAPH* p_g, G_NODE* p_n){
    //cancello il nodo dal grafo
    delete(&(p_g->node), p_n->pos);
    p_g->n_node--;

    //cancello gli archi uscenti dal nodo
    node_edge_destroy(p_g, p_n->out_edge);
    
    //cancello gli archi entranti nel nodo
    node_edge_destroy(p_g, p_n->in_edge);

    free(p_n);
}






void ob_graph_print(OB_GRAPH* p_g){

    NODE* cur_n = p_g->node;
    while(cur_n != NULL){
        //stampo il nodo
        printf("[%d]-->", ((G_NODE*)cur_n->data)->key);
        
        //stampo gli archi uscenti
        NODE* cur_e = ((G_NODE*)cur_n->data)->out_edge; 
        while(cur_e != NULL){
            
            printf(" %d", ((G_EDGE*)cur_e->data)->to->key);
            cur_e = cur_e->next;
        }

        printf("\n");
        cur_n= cur_n->next;
    }
}


int ob_grapg_dfs(G_NODE* p_n, int mark){
    printf("visto il nodo: %d\n", p_n->key);
    p_n->color =  mark;
    NODE* curr_n= p_n->out_edge;

    int flag = 1;

    while(curr_n != NULL){
        G_EDGE* curr_e = (G_EDGE*)curr_n->data;
        if(curr_e->to->color == 0){
            flag= flag + ob_grapg_dfs((G_NODE*)curr_e->to, mark);
        }

        curr_n = curr_n->next;  
    }

    return flag;
}