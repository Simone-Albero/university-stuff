#include <stdlib.h>
#include <stdio.h>

#include "grafo_ob.h"


int main(){

    OB_GRAPH* p_g= new_ob_graph();

    new_ob_node(p_g);
    new_ob_node(p_g);
    new_ob_node(p_g);
    new_ob_node(p_g);
    new_ob_node(p_g);
    new_ob_node(p_g);
    new_ob_node(p_g);
    new_ob_node(p_g);

    new_ob_edge(p_g, (G_NODE*)p_g->node->data, (G_NODE*)p_g->node->next->data);
    new_ob_edge(p_g, (G_NODE*)p_g->node->data, (G_NODE*)p_g->node->data);

    new_ob_edge(p_g, (G_NODE*)p_g->node->next->data, (G_NODE*)p_g->node->next->next->next->data);
    new_ob_edge(p_g, (G_NODE*)p_g->node->next->data, (G_NODE*)p_g->node->next->next->next->next->data);
    
    new_ob_edge(p_g, (G_NODE*)p_g->node->next->next->data, (G_NODE*)p_g->node->next->next->data);
    new_ob_edge(p_g, (G_NODE*)p_g->node->next->next->data, (G_NODE*)p_g->node->next->next->next->data);

    new_ob_edge(p_g, (G_NODE*)p_g->node->next->next->next->data, (G_NODE*)p_g->node->next->next->next->data);
    new_ob_edge(p_g, (G_NODE*)p_g->node->next->next->next->data, (G_NODE*)p_g->node->next->next->next->next->data);
    
    
    
    ob_graph_print(p_g);

    //printf("Cancello un nodo: \n");
    //ob_edge_destroy(p_g, (G_EDGE*)p_g->edge->data); 
    //ob_node_destroy(p_g, (G_NODE*)p_g->node->data);   
    //ob_graph_print(p_g);


    printf("BFS su grafo: \n");
    NODE* p_n = p_g->node;
    int mark = 0;
    
    while(p_n != NULL){
        if(((G_NODE*)p_n->data)->color == 0){
            mark++;
            printf("numero di componenti connesse: %d\n", ob_grapg_dfs((G_NODE*)p_n->data, mark));
        }

        p_n = p_n->next;

    }

}