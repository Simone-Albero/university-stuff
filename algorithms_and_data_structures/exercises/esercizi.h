#ifndef _ESERCIZI_H
#define _ESERCIZI_H

#include "grafo_ob.h"
#include "grafo_list.h"
#include "tree.h"

//esercizi prova di esame alberi
int verifica(T_NODE* p_n);
int conta_discendenti(T_NODE* p_n);
int verifica_profondita_nodi(TREE p_t, T_NODE* p_n, int depth);


//esercizi prova di esame alberi e grafi
int figli_connessi(TREE p_t, OB_GRAPH* p_g);
int comp_min_figli_singoli(TREE p_t, OB_GRAPH* p_g);
int comp_max_nodi_altezza(int h, TREE p_t, OB_GRAPH* p_g);
int comp_min_figli_h(int h, TREE p_t, OB_GRAPH* p_g);
int nodi_prof_connessi(TREE p_t, OB_GRAPH* p_g);
int foglie_comp(TREE p_t, OB_GRAPH* p_g); 
int comp_albero_omogeneo(TREE p_t, OB_GRAPH* p_g);
int comp_max_prof_max(TREE p_t, OB_GRAPH* p_g);

#endif