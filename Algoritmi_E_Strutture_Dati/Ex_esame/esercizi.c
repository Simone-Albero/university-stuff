#include <stdlib.h>
#include <stdio.h>

#include "esercizi.h"

//verifica se esiste un sotto albero avente la metà dei nodi dell'albero

//funzione di supplemento   
int cerca_sottoalbero(T_NODE* p_n, int t_node){
    if(p_n == NULL)
        return 0;

    if(node_count(p_n) == t_node)
        return 1;
    else
        return cerca_sottoalbero(p_n->left, t_node) || cerca_sottoalbero(p_n->right, t_node);

}

int verifica(T_NODE* p_n){
    if(p_n==NULL)
        return 0;

    //conto i nodi dell'albero
    int t_node = node_count(p_n);
    
    if((t_node % 2) != 0)
        return 0;

    return cerca_sottoalbero(p_n, t_node/2);
}



//conta i nodi aventi come campo info la somma dei discendenti
int conta_discendenti(T_NODE* p_n){
    if(p_n == NULL)
        return 0;
    
    int flag = 0;

    if(node_count(p_n)==p_n->info)
        flag++;
    
    flag= flag + conta_discendenti(p_n->left) + conta_discendenti(p_n->right);

    return flag;


}


//verifica se esiste un livello di profondità pari al numero di nodi del livello stesso
int conta_nodi_profondita(T_NODE* p_n, int depht){
    if(p_n == NULL)
        return 0;
    
    if(depht == 0)
        return 1;
    else
        return conta_nodi_profondita(p_n->left, depht-1) + conta_nodi_profondita(p_n->right, depht-1);
}

int verifica_profondita_nodi(TREE p_t, T_NODE* p_n, int depth){
    if(p_n == NULL)
        return 0;
    
    if(conta_nodi_profondita(p_t, depth) == depth)
        return 1;
    else
        return verifica_profondita_nodi(p_t, p_n->left, depth+1) || verifica_profondita_nodi(p_t, p_n->right, depth+1);
}


//funzioni di supporto


int conta_figli(T_NODE* p_n){
    int c= 0;

    while(p_n!=NULL){
        c++;
        p_n = p_n->right;
    }

    return c;
}


int cerco_figli_connessi(TREE p_t, int* comp, int n_comp){
    if(p_t == NULL)
        return 0;
    
    for(int i=0; i<n_comp; i++)
        if(conta_figli(p_t)==comp[i])
            return 1;
    
    return cerco_figli_connessi(p_t->left, comp, n_comp) || cerco_figli_connessi(p_t->right, comp, n_comp);
}


//verifica se  se esiste nodo dell’albero con figli paria i nodi di una componente connessa 

int figli_connessi(TREE p_t, OB_GRAPH* p_g){
    NODE* p_n = p_g->node;
    int mark = 0;
    int* comp= (int*)calloc(1, sizeof(int));

    if(p_g == NULL)
        return 0;

    while(p_n != NULL){
        if(((G_NODE*)p_n->data)->color == 0){ 
            mark++;
            //printf("MARK: %d\n", mark);
            comp[mark-1]= ob_grapg_dfs((G_NODE*)p_n->data, mark);
            comp= realloc(comp, (mark+1)*sizeof(int));
        }

        p_n = p_n->next;

    }

    return cerco_figli_connessi(p_t, comp, mark);
}


//funzioni nascoste
int comp_min(OB_GRAPH* p_g){
    NODE* p_n = p_g->node;
    int mark = 0;
    int* comp= (int*)calloc(1, sizeof(int));

    while(p_n != NULL){
        if(((G_NODE*)p_n->data)->color == 0){ 
            mark++;
            //printf("MARK: %d\n", mark);
            comp[mark-1]= ob_grapg_dfs((G_NODE*)p_n->data, mark);
            comp= realloc(comp, (mark+1)*sizeof(int));
        }

        p_n = p_n->next;
    }

    int min= comp[0];

    for(int i=1; i<mark; i++)
        if(comp[i]<min)
            min=comp[i];

    return min;
}

int conta_figli_singoli(TREE p_t){
    if(p_t == NULL)
        return 0;
    
    int flag = 0;

    if((p_t->left!=NULL && p_t->right == NULL)||(p_t->left==NULL && p_t->right!=NULL))
        flag= 1;

    flag= flag + conta_figli_singoli(p_t->left) + conta_figli_singoli(p_t->right);
    
    return flag;
}

//verifica che la componente connessa minima del grafo è pari al numero di nodi con un solo figli
int comp_min_figli_singoli(TREE p_t, OB_GRAPH* p_g){
    if(p_g == 0)
        return 0;

    return conta_figli_singoli(p_t) == comp_min(p_g);
}


//funzioni di supporto

int comp_max(OB_GRAPH* p_g){
    NODE* p_n = p_g->node;
    int mark = 0;

    int max= 0;
    int comp;
    
   while(p_n != NULL){
        if(((G_NODE*)p_n->data)->color == 0){ 
            mark++;
            comp= ob_grapg_dfs((G_NODE*)p_n->data, mark);
            if(max < comp)
                max= comp;
        }

        p_n = p_n->next;
    }

    return max;
}


int nodi_altezza_h(int h, TREE p_t){
    if(p_t == NULL)
        return 0;
    
    int flag= 0;

    if(h==0)
        flag= 1;
    
    flag= flag + nodi_altezza_h(h-1, p_t->left) + nodi_altezza_h(h-1, p_t->right); 
    return flag;
}




//verifica che la componente connessa massima del grafo è pari al numero di nodi ad altezza h
int comp_max_nodi_altezza(int h, TREE p_t, OB_GRAPH* p_g){
    if(p_g == NULL)
        return 0;
    
    return nodi_altezza_h(h, p_t) == comp_max(p_g);
}


//funzioni di supporto

//verifica che un nodo è radice di un sottoalbero di profondità h
int profondita(TREE p_t){ 
    
    if(p_t == NULL)
        return -1;
    
    int prof_left= 1 + profondita(p_t->left);
    int prof_right= 1 + profondita(p_t->right);
    
    if(prof_left > prof_right)
        return prof_left;
    else
        return prof_right;
}

int n_sottoalberi_h(int h, TREE p_t){
    if(p_t == NULL)
        return 0;
    
    int flag= 0;

    if(profondita(p_t) == h)
        flag= 1;

    flag= flag + n_sottoalberi_h(h, p_t->left) + n_sottoalberi_h(h, p_t->right);

    return flag;
}




//verifica che la componente connessa minima del grafo è pari al numero di figli del nodo ad altezza h
int comp_min_figli_h(int h, TREE p_t, OB_GRAPH* p_g){

    if((p_t == NULL && p_g != NULL) || (p_t != NULL && p_g == NULL))
        return 0;

    int figli_h = n_sottoalberi_h(h, p_t); 
    printf("Figli h: %d\n", figli_h);

    if(figli_h == 0)
        return 0;

    return figli_h == comp_min(p_g);
}



//funzioni di appoggio

int conta_nodi_h(int h, TREE p_t){//conta i nodi a profondità h
    if(p_t==NULL)
        return 0;
    int flag= 0;

    if(h == 0)
        flag= 1;

    flag= flag + conta_nodi_h(h-1, p_t->left) + conta_nodi_h(h-1, p_t->left);
    return flag;

}



//verifica che esiste un livello h i cui nodi sono pari al numero dei nodi diu una componente connessa
int nodi_prof_connessi(TREE p_t, OB_GRAPH* p_g){

    if(p_t == NULL && p_g == NULL)
        return 1;
    

    if((p_t == NULL && p_g != NULL) || (p_t != NULL && p_g == NULL))
        return 0;

    NODE* p_n = p_g->node;
    int mark = 0;
    int* comp= (int*)calloc(1, sizeof(int));

    while(p_n != NULL){
        if(((G_NODE*)p_n->data)->color == 0){ 
            mark++;
            //printf("MARK: %d\n", mark);
            comp[mark-1]= ob_grapg_dfs((G_NODE*)p_n->data, mark);
            comp= realloc(comp, (mark+1)*sizeof(int));
        }

        p_n = p_n->next;
    }

    int altezza= profondita(p_t);

    for(int i=0; i<altezza; i++){
        for(int j=0; j<mark; j++){
            if(conta_nodi_h(i, p_t) == comp[j])
                return 1;
        }
    }

    return 0;

}


//funzioni di appoggio
int conta_foglie(TREE p_t){
    if(p_t == NULL)
        return 0;
    int flag= 0;

    if(p_t->left == NULL)
        flag= 1;

    flag= flag + conta_foglie(p_t->left) + conta_foglie(p_t->right);
    return flag;
}



//verifica che esiste una componente connessa di dimensione pari al numero delle foglie

int foglie_comp(TREE p_t, OB_GRAPH* p_g){

    if(p_t==NULL && p_g==NULL)
        return 1;
    
    if((p_t==NULL && p_g!=NULL) || (p_t!=NULL && p_g==NULL))
        return 0;


    int* comp= (int*)calloc(1, sizeof(int));
    NODE* p_n = p_g->node;
    int mark = 0;

    while(p_n != NULL){

        if(((G_NODE*)p_n->data)->color == 0){
            mark++;
            comp[mark-1] = ob_grapg_dfs((G_NODE*)p_n->data, mark);
            comp = realloc(comp, (mark+1) * sizeof(int));
        }

        p_n = p_n->next;
    }

    int n_foglie= conta_foglie(p_t);
    printf("N_FOGLIE: %d\n", n_foglie);

    for(int i=0; i<mark; i++){
        if(comp[i] == n_foglie)
            return 1;
    }

    return 0;

}

//funzioni di supporto
int albero_omogeneo(T_NODE* p_n){
    if(p_n==NULL)
        return 1;

    if(p_n->info != 1)
        return 0;
    
    return albero_omogeneo(p_n->left) && albero_omogeneo(p_n->right);
}

int conta_sottoalberi_omogenei(TREE p_t){
    if(p_t==NULL)
        return 0;
    
    int flag= 0;

    if(albero_omogeneo(p_t))
        flag = 1;
    
    flag= flag + conta_sottoalberi_omogenei(p_t->left) + conta_sottoalberi_omogenei(p_t->right);

    return flag;
}



//verifica se esiste una componente tale chee la sua dimesione si uguale al numero di sottolaberi omogenei
//albero omogeneo: ha tutti i campi info pari ad 1
int comp_albero_omogeneo(TREE p_t, OB_GRAPH* p_g){
    NODE* p_n= p_g->node;
    int* comp= (int*)calloc(1,sizeof(int));
    int mark= 0;

    while(p_n!=NULL){
        if(((G_NODE*)p_n->data)->color == 0){
            mark++;
            comp[mark-1]= ob_grapg_dfs((G_NODE*)p_n->data, mark);
            comp= realloc(comp, (mark+1)*sizeof(int));
        }

        p_n= p_n->next;
    }

    int n_omogenei= conta_sottoalberi_omogenei(p_t);
    printf("N_OMOGENEI: %d\n", n_omogenei);
    
    for(int i=0; i<mark; i++)
        if(comp[i]==n_omogenei)
            return 1;
    

    return 0;

}

//funzioni di supporto

T_NODE* nodo_max_key(TREE p_t){

    if(p_t == NULL)
        return NULL;    

    if(p_t->left == NULL && p_t->right == NULL)
        return p_t;

    T_NODE* sx_max= nodo_max_key(p_t->left);
    T_NODE* dx_max= nodo_max_key(p_t->right);

    if((sx_max == NULL) && (dx_max != NULL) )
        return dx_max;

    if((sx_max != NULL) && (dx_max == NULL) )
        return sx_max;


    T_NODE* curr_max= dx_max;

    if(sx_max->info > dx_max->info)
        curr_max= sx_max;
    
    if(p_t->info > curr_max->info)
        curr_max= p_t;
    
    return curr_max;


}


int nodo_prof(TREE p_t, T_NODE* p_n){
    if(p_t == p_n)
        return 0;
    else
        return 1 + nodo_prof(p_t, p_n->parent); 
}




//verifica che la componente maggiore sia pari alla profondità del nodo con chiave maggiore
int comp_max_prof_max(TREE p_t, OB_GRAPH* p_g){
    
    NODE* p_n= p_g->node;
    int mark= 1;
    int comp_max= ob_grapg_dfs((G_NODE*)p_n->data, mark);
    int curr_comp;


    while(p_n!=NULL){
        if(((G_NODE*)p_n->data)->color == 0){
            mark++;
            curr_comp= ob_grapg_dfs((G_NODE*)p_n->data, mark);

            if(curr_comp > comp_max)
                comp_max= curr_comp;
        }

        p_n= p_n->next;
    }

    T_NODE* v_max= nodo_max_key(p_t);
    int prof_max= nodo_prof(p_t, v_max);
    printf("V_MAX: %d\n", v_max->info);
    printf("PROF_MAx: %d\n", prof_max);
    printf("COMP_MAX: %d\n", comp_max);

    return prof_max==comp_max;


}