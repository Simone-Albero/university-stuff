(*Luglio 2019*)
type 'a tree = Empty | Tr of 'a  * 'a tree * 'a tree;;

let rec n_ramo_bin n = function 
    Empty -> failwith "NotFound"
    |Tr(x,Empty,Empty) -> if x = n then [x]
                         else failwith "NotFound"
    |Tr(x,t1,t2) -> if x<n then try x::n_ramo_bin (n-x) t1
                                with _ -> x::n_ramo_bin (n-x) t2
                    else failwith "NotFound";;   

type 'a ntree = Ntree of 'a * 'a ntree list;;

let rec n_ramo n = function 
    Ntree(x,[]) -> if x = n then [x] 
                    else failwith "Notfound"
    |Ntree(x,tlst) -> if x < n then x::n_sub_ramo (n-x) tlst
                        else failwith "NotFound"

and n_sub_ramo n = function 
    [] -> failwith "NotFound"
    |t::rest -> try n_ramo n t 
                with _ -> n_sub_ramo n rest;;

let bin_test = n_ramo_bin 4 (Tr(1, Tr(2,Tr(4,Empty,Empty),Tr(5,Empty,Empty)), Tr(3,Empty,Empty)));;
let n_test = n_ramo 11 (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;    

(*Settembre 2019*)
type 'a tree = Empty | Tr of 'a * 'a tree * 'a tree;;

let rec labels = function
    |Empty -> []
    |Tr(x,t1,t2) -> x::(labels t1 @ labels t2);;

let rec discendenti n = function
    Empty -> []
    |Tr(x,t1,t2) as t -> if x = n then labels t @ discendenti n t1 @ discendenti n t2
                            else discendenti n t1 @ discendenti n t2;;
                        
let bin_test = discendenti 2 (Tr(1, Tr(2,Tr(4,Empty,Empty),Tr(5,Empty,Empty)), Tr(2,Tr(7,Empty,Empty),Tr(8,Empty,Empty))));;

type 'a ntree = Ntree of 'a * 'a ntree list;;

let rec n_labels = function 
    Ntree(x,[]) -> [x]
    |Ntree(x,tlst) -> x::n_sub_labels tlst

and n_sub_labels = function 
    [] -> []
    |t::rest -> n_labels t @ n_sub_labels rest;;

let rec n_discendenti n = function
    Ntree(x,tlst) as t -> if x = n then n_labels t @ n_sub_discendenti n tlst
                            else n_sub_discendenti n tlst

and n_sub_discendenti n = function 
    [] -> []
    |t::rest -> n_discendenti n t @ n_sub_discendenti n rest;;

let n_test = n_discendenti 2 (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(2,[Ntree(5,[]); Ntree(6,[])])]));; 


(*Febbraio 2021*)
type 'a ntree = Ntree of 'a * 'a ntree list;;

let rec pesi = function 
    Ntree(r,[]) -> [r]
    |Ntree(r,tlst) -> List.map (fun x -> x+r) (sub_pesi tlst)

and sub_pesi = function 
    [] -> []
    |t::rest -> pesi t @ sub_pesi rest;;

let n_test = pesi (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(2,[Ntree(5,[]); Ntree(6,[])])]));; 

type 'a tree = Tr of 'a * 'a tree * 'a tree;;

let rec bin_pesi = function 
    Empty -> []
    |Tr(r,Empty,Empty) -> [r]
    |Tr(r,t1,t2) -> List.map (fun x -> x+r) (bin_pesi t1 @ bin_pesi t2);;

let bin_test = bin_pesi (Tr(1, Tr(2,Tr(4,Empty,Empty),Tr(5,Empty,Empty)), Tr(2,Tr(7,Empty,Empty),Tr(8,Empty,Empty))));;

(*Settembre 2021*)
type 'a ntree = Ntree of 'a * 'a ntree list;;

let rec cerca_foglia lst = function 
    Ntree(x,[]) -> x
    |Ntree(x,tlst) -> try cerca_sub_foglia (List.assoc x lst) lst tlst
                        with _ -> failwith "NotFound"

and cerca_sub_foglia n lst tlst = match (n,tlst) with 
    (x,[]) -> failwith "NotFound"
    |(1,t::rest) -> cerca_foglia lst t
    |(x,t::rest) -> cerca_sub_foglia (x-1) lst rest

let n_test = cerca_foglia [(1,3);(4,2);(5,1)] (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));; 
   
let rec bin_cerca_foglia lst = function
    Empty -> failwith "NotFound"
    |Tr(x,Empty,Empty) -> x
    |Tr(x,t1,t2) -> let n = List.assoc x lst 
                    in if n = 1 then bin_cerca_foglia lst t1
                        else bin_cerca_foglia lst t2;; 

let bin_test = bin_cerca_foglia [(1,1);(2,2)] (Tr(1, Tr(2,Tr(4,Empty,Empty),Tr(5,Empty,Empty)), Tr(2,Tr(7,Empty,Empty),Tr(8,Empty,Empty))));; 

(*Luglio 2015*)
let rec radici = function
    [] -> []
    |Ntree(x,tlst)::rest -> let cur = radici rest in if not(List.mem x cur) then x::cur
                            else cur;;

let test =  radici [Ntree(6,[]);Ntree(1,[]);Ntree(0,[]);Ntree(0 ,[])];;

let rec archi = function 
    Ntree(x,[]) -> []
    |Ntree(x,tlst) -> sub_archi x tlst 

and sub_archi x = function 
    [] -> []
    |(Ntree(r,tlst) as t)::rest -> let cur = (sub_archi x rest @ archi t) 
                                    in if not(List.mem (x,r) cur) then (x,r)::cur
                                        else cur;;
                                    
let test = archi (Ntree(1,[Ntree(2,[Ntree(5,[]); Ntree(8,[Ntree(9,[Ntree(5,[])]); Ntree(10,[])])]); Ntree(3,[Ntree(6,[]); Ntree(7,[]); Ntree(8,[Ntree(9,[]); Ntree(4,[])])]); Ntree(4,[Ntree(9,[]); Ntree(10,[]); Ntree(9,[Ntree(2,[])])])]));; 

(*Settembre 2014*)
 let rec rami = function 
    Empty -> []
    |Tr(x,Empty,Empty) -> [[x]]
    |Tr(x,t1,t2) -> List.map (fun a -> x::a) (rami t1 @ rami t2);;

let test = rami (Tr(1, Tr(2, Tr(3, Empty, Empty), Empty), Tr(4, Tr(5, Tr(3, Empty, Empty), Empty), Tr(2, Empty, Tr(6, Empty, Empty)))));;

(*Luglio 2014*)
let ramociclo t = 
    let rec aux visited = function 
        Ntree(x,tlst) -> if List.mem x visited then [x]
                            else  x::sub_ramociclo (x::visited) tlst

    and sub_ramociclo visited = function
        [] -> failwith "NotFound"
        |t::rest -> try aux visited t 
                    with _ -> sub_ramociclo visited rest

in aux [] t;;

let n_test = ramociclo (Ntree(1,[Ntree(2,[Ntree(5,[]); Ntree(8,[Ntree(9,[Ntree(5,[])]); Ntree(10,[])])]); Ntree(3,[Ntree(6,[]); Ntree(7,[]); Ntree(8,[Ntree(9,[]); Ntree(4,[])])]); Ntree(4,[Ntree(9,[]); Ntree(10,[]); Ntree(9 ,[Ntree(1,[])])])]));;

(*Febbraio 2014*)
let rec livello k (Ntree(x,tlst)) = match k with 
    0 -> [x]
    |x -> sub_livello (x-1) tlst

and sub_livello k = function 
    [] -> []
    |t::rest -> livello k t @ sub_livello k rest;;

let n_test = livello 1 (Ntree(1,[Ntree(2,[Ntree(5,[]); Ntree(8,[Ntree(9,[Ntree(5,[])]); Ntree(10,[])])]); Ntree(3,[Ntree(6,[]); Ntree(7,[]); Ntree(8,[Ntree(9,[]); Ntree(4,[])])]); Ntree(4,[Ntree(9,[]); Ntree(10,[]); Ntree(9 ,[Ntree(1,[])])])]));;

(*Febbraio 2015*)
let rec figli y = function 
    Ntree(x,[]) -> []
    |Ntree(x,tlst) -> sub_figli x y tlst 

and sub_figli x y = function 
    [] -> []
    |(Ntree(r,tlst) as t)::rest -> if x = y then r::sub_figli x y rest
                                    else figli y t @ sub_figli x y rest;; 

let n_test = figli 8 (Ntree(1,[Ntree(2,[Ntree(5,[]); Ntree(8,[Ntree(9,[Ntree(5,[])]); Ntree(10,[])])]); Ntree(3,[Ntree(6,[]); Ntree(7,[]); Ntree(8,[Ntree(9,[]); Ntree(4,[])])]); Ntree(4,[Ntree(9,[]); Ntree(10,[]); Ntree(9 ,[Ntree(1,[])])])]));;

(*Dicembre 2021*)

let root (Ntree(r,tlst)) = r;;

let rec mkset = function    
    [] -> []
    |x::rest -> let prev_lst = mkset rest in if not(List.mem x prev_lst) then x::prev_lst
                                                else prev_lst;;

let frtelli x t =
    let rec aux = function
        Ntree(r,[]) -> []
        |Ntree(r,tlst) -> if List.exists (fun y -> root y = x) tlst then List.map (fun y -> root y) tlst @ sub_fratelli tlst 
                            else sub_fratelli tlst 
    
    and sub_fratelli = function 
        [] -> []
        |t::rest -> aux t @ sub_fratelli rest

in List.filter (fun y -> y <> x) (mkset (aux t));;

let n_test = frtelli 4 (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(4,[]); Ntree(6,[])])]));;
