#include <stdlib.h>
#include <stdio.h>
/*
#include "grafo_ob.h"
#include "grafo_list.h"
#include "tree.h"*/


#include "esercizi.h"

int main(){

    /*albero binario*/
    TREE p_t;
    add_root(&p_t, 100);
    T_NODE* a_1 = add_left(p_t, 6);
    T_NODE* a_2 = add_right(p_t, 2);
    T_NODE* b_1 = add_left(a_1, 4);
    T_NODE* b_2 = add_right(a_1, 45);
    T_NODE* b_3 = add_left(a_2, 5);
    T_NODE* b_4 = add_right(a_2, 2);
    T_NODE* c_1 = add_left(b_1, 12);
    T_NODE* c_2 = add_right(b_1, 13);
    T_NODE* c_3 = add_left(b_3, 54);
    T_NODE* d_1 = add_left(c_1, 74);
    printf("Albero binario: ");
    tree_print(p_t);
    printf("\n\n");

    /*albero arbitrario*/
    TREE p_t2;
    add_root(&p_t2, 1);
    T_NODE* ta_1 = add_child(p_t2, 10);
    T_NODE* ta_2 = add_brother(ta_1, 11);

    T_NODE* tb_1 = add_child(ta_1, 12);
    T_NODE* tb_2 = add_brother(tb_1, 13);
    T_NODE* tb_3 = add_brother(tb_2, 14);
    T_NODE* tb_4 = add_brother(tb_3, 15);

    T_NODE* tc_1 = add_child(tb_2, 16);
    T_NODE* tc_2 = add_brother(tc_1, 17);
    T_NODE* tc_3 = add_brother(tc_2, 33);

    T_NODE* td_1 = add_child(ta_2, 19);
    T_NODE* td_2 = add_brother(td_1, 21);

    T_NODE* te_1 = add_child(td_2, 22);
    T_NODE* te_2 = add_brother(te_1, 25);


    printf("Albero arbitrario: ");
    tree_print(p_t2);
    printf("\n\n");
    

    /*grafo ad ogetti*/
    OB_GRAPH* p_g= new_ob_graph();
    G_NODE* p_n1 = new_ob_node(p_g);
    G_NODE* p_n2 = new_ob_node(p_g);
    G_NODE* p_n3 = new_ob_node(p_g);
    G_NODE* p_n4 = new_ob_node(p_g);
    G_NODE* p_n5 = new_ob_node(p_g);
    G_NODE* p_n6 = new_ob_node(p_g);
    G_NODE* p_n7 = new_ob_node(p_g);

    new_ob_edge(p_g, p_n1, p_n2);
    new_ob_edge(p_g, p_n2, p_n3);
    new_ob_edge(p_g, p_n3, p_n1);

    new_ob_edge(p_g, p_n4, p_n5);
    new_ob_edge(p_g, p_n5, p_n6);
    new_ob_edge(p_g, p_n6, p_n7);
    new_ob_edge(p_g, p_n7, p_n4);
    
    ob_graph_print(p_g);
    printf("\n");

    //printf("Cancello un nodo: \n");
    //ob_edge_destroy(p_g, (G_EDGE*)p_g->edge->data); 
    //ob_node_destroy(p_g, (G_NODE*)p_g->node->data);   
    //ob_graph_print(p_g);


    /*grafo lista adiacenza*/

    /*funzioni varie*/

    //printf("Figli connessi: %d\n", figli_connessi(p_t2, p_g));
    //printf("Componente minima figli: %d\n", comp_min_figli_singoli(p_t, p_g));
    //printf("Componente massima nodi altezza: %d\n", comp_max_nodi_altezza(2, p_t, p_g));
    //printf("Componente minima figli di h: %d\n", comp_min_figli_h(3, p_t, p_g));
    //printf("Nodi profondita connessi: %d\n", nodi_prof_connessi(p_t, p_g));
    //printf("Foglie comp: %d\n", foglie_comp(p_t2, p_g));
    //printf("Comp albero omogeneo: %d\n", comp_albero_omogeneo(p_t2, p_g));
    printf("Comp max prof max: %d\n", comp_max_prof_max(p_t, p_g));
}
