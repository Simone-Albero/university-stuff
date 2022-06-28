(*Parte 1*)
type expr =
    Int of int
    | Var of string
    | Sum of expr * expr
    | Diff of expr * expr
    | Mult of expr * expr
    | Div of expr * expr;;

(*Parte 1a*)
(*subexpr: expr -> expr -> bool *)
let rec subexpr e1 e2 = 
    e1 = e2 || match e1 with
    | Sum (x,y) | Diff (x,y) | Mult (x,y)  | Div (x,y)  -> subexpr x e2 || subexpr y e2 
    | _ -> false;;

(*Parte 1b*)
(*subst_in_expr: expr -> string -> expr -> expr*)

let rec subst_in_expr e1 x e2 = match e1 with
    Int _ -> e1
    |Var a -> if a=x 
             then e2
             else e1
    | Sum (a,b) -> Sum (subst_in_expr a x e2, subst_in_expr b x e2)
    | Diff (a,b) -> Sum (subst_in_expr a x e2, subst_in_expr b x e2)
    | Mult (a,b) -> Sum (subst_in_expr a x e2, subst_in_expr b x e2)
    | Div (a,b) -> Sum (subst_in_expr a x e2, subst_in_expr b x e2);;

(*Parte 2*)
type 'a tree = Empty | Tr of 'a * 'a tree * 'a tree;;

(*Parte 2a*)
let rec reflect = function 
    Empty -> Empty
    |Tr(x, t1, t2) -> Tr(x, reflect t2, reflect t1) 

(*Parte 2b*)
let fulltree n = 
    let rec aux k = function
    0 -> Empty (*mi fermo*)
    |x -> Tr (k, aux (2*k) (x-1), aux (2*k+1) (x-1)) 
in aux 1 n;;

(*Parte 2c*)
let rec deep = function 
    Empty -> 0
    |Tr (x, t1, t2) -> 1 + max (deep t1) (deep t2);;

let rec balanced = function 
    Empty -> true   
    |Tr (_, t1, t2) -> balanced t1 && balanced t2 &&  (abs (deep t1 - deep t2)) <= 1

(*Parte 2d*)
(*prima si visita il nodo e poi i suoi sottoalberi *)
let rec preorder = function 
    Empty -> []
    |Tr(x, t1, t2) -> x::(preorder t1 @ preorder t2);;

(*prima si visitano i sottoalberi, poi il nodo *)
let rec postorder = function 
    Empty -> []
    |Tr(x, t1, t2) -> (postorder t1 @ postorder t1) @ [x];;

(*prima si visita il sottoalbero sinistro, poi il nodo e infine il sottoalbero destro *)
let rec inorder = function 
    Empty -> []
    |Tr(x, t1, t2) -> inorder t1 @ (x::inorder t2);;

(*Parte 2e*)

let rec take n = function
    [] -> []
  | x::xs -> if n<=0 then []
             else x::take (n-1) xs

(* drop : int -> 'a list -> 'a list *)
let rec drop n = function
    [] -> []
  | x::xs -> if n<=0 then x::xs
             else drop (n-1) xs;;
let rec balpreorder = function 
    [] -> Empty
    |x::rest as lst -> let len = (List.length lst)/2 
                        in Tr(x, balpreorder (take len rest), balpreorder (drop len rest));;

(*
let rec balinorder = function 
    [] -> Empty
    |lst -> let len = (List.length lst)/2 
            in let x::rest = drop len lst 
                in Tr(x, balinorder (take len lst), balinorder rest);; 
*)

(*Parte 3*)
let rec foglie_in_lista lst = function 
    Empty -> true
    |Tr(x, Empty, Empty) -> List.mem x lst
    |Tr(x, t1, t2) -> foglie_in_lista lst t1 && foglie_in_lista lst t2;;

(*Parte 4*)
let rec num_foglie = function 
    Empty -> 0
    |Tr(x, Empty, Empty) -> 1 
    |Tr(x, t1, t2) -> num_foglie t1 + num_foglie t2;;
    
(*Parte 5*)
let rec segui_bool lst tree = match (lst, tree) with 
    (_, Empty) -> Empty
    |([], Tr(x,_,_)) -> x 
    |(x::rest, Tr(r, left, right)) -> if x 
                                      then segui_bool rest left
                                      else segui_bool rest right;;

(*Parte 6*)
let rec foglia_costo = function 
    Empty -> failwith "albero vuoto"
    |Tr(x, Empty, Empty) -> (x, x)
    |Tr(x, t1, Empty) -> let (a, b) = foglia_costo t1 in (a, x+b)
    |Tr(x, Empty, t2) -> let (a, b) = foglia_costo t2 in (a, x+b)
    |Tr(x, t1, t2) ->   let (a, b) = 
                            let ((c,d),(e,f)) = (foglia_costo t1 ,foglia_costo t2) 
                            in if d > f 
                                then (c,d)
                                else (e,f)
                        in (a, x+b);;


(*Parte 7*)
let rec foglie_costi = function 
    Empty -> failwith "qc"
    |Tr(x, Empty, Empty) -> [(x, x)]
    |Tr(x, t1, t2) -> List.map (function (a,b) -> (a, b+x)) (foglie_costi t1 @ foglie_costi t2);;

(*Parte 8*)
type expr =
    Jolly
    | Int of int
    | Var of string
    | Sum of expr * expr
    | Diff of expr * expr
    | Mult of expr * expr
    | Div of expr * expr

let rec pattern_matching e1 e2 = 
    match (e1, e2) with
     (_ , Jolly) -> true 
    | (Sum (a,b), Sum (c,d)) | (Diff (a,b), Diff (c,d)) | (Mult (a,b), Mult (c,d)) | (Div (a,b), Div (c,d)) -> pattern_matching a c && pattern_matching b d
    |(x, y) -> x = y ;;

(*Parte 10*)
let rec stessa_struttura t1 t2 = match (t1,t2) with 
    (Empty, Empty) -> true
    |(Tr(_,ta,tb),Tr(_,tc,td)) -> stessa_struttura ta tc && stessa_struttura tb td
    |_ -> false;; 

(*Parte 11*)
let rec cerca_funzione t1 t2 = match (t1,t2) with   
    (Empty, Empty) -> []
    |(Tr(x,ta,tb),Tr(y,tc,td)) -> (x,y) :: (cerca_funzione ta tc @ cerca_funzione tb td)
    |_ -> failwith "qc";; 

let rec is_function = function
    [] -> true
  | (x,y)::rest -> 
      List.for_all (function (z,w) -> z<>x || w=y) rest && is_function rest

let rec esiste_mapping t1 t2 = 
    try is_function (cerca_funzione t1 t2)
    with _ -> false;;

(*Parte 12*)

let rec path p = function 
    Empty -> failwith "qc"
    |Tr(x, Empty, Empty) -> if p x then failwith "qc" else [x]
    |Tr(x, t1, t2) -> if p x then failwith "qc"
                        else  try x::path p t1 
                               with _ -> x::path p t2;;

(*Parte 13*)
type 'a sostituzione = ('a * 'a tree) list;;

let rec applica sost = function 
    Empty -> Empty
    |Tr(x, Empty, Empty) as leaf -> (try List.assoc x sost 
                                    with _-> leaf)
    |Tr(x, t1, t2) -> Tr(x, applica sost t1, applica sost t2);;  

(*Parte 14*)
type col = Rosso | Giallo | Verde | Blu;;
type 'a col_assoc = (col * 'a list) list;;

let rec colore x = function 
    [] -> failwith "NotFound"
    |(a,b)::rest -> if List.mem x b 
                    then a 
                    else colore x rest;;

let rec path_to x cols = function 
    Empty -> failwith "NotFound"
    |Tr(r,Empty,Empty)-> if r = x 
                           then [x]
                           else failwith "NotFound"
    |Tr(r,t1,t2) -> try let curr = path_to x cols t1 
                        in if (colore r cols) <> (colore (List.hd curr) cols) 
                            then r::curr
                            else failwith "NotFound"
                    with _->  let curr = path_to x cols t2 
                              in if (colore r cols) <> (colore (List.hd curr) cols) 
                                  then r::curr
                                  else failwith "NotFound";;

let t_prova = Tr(1,Tr(14,Empty,Empty),Tr(2,Empty,Tr(14,Empty,Empty)));;

(*Parte 15*)
let abr_prova = Tr((20,1),Tr((14,2),Empty,Empty),Tr((22,3),Empty,Tr((35,4),Empty,Empty)))

let (<<) a = function
    None -> true
  | Some b -> a<b

let (>>) a = function
    None -> true
  | Some b -> a>b

let abr_chek tree = 
    let rec aux minv maxv = function
        Empty -> true
        |Tr((k,_),t1,t2)-> k << maxv && k >> minv && aux minv (Some k) t1 && aux (Some k) maxv t2
    in aux None None tree;;

let rec abr_search t x = match t with
    Empty-> failwith "NotFound"
    |Tr((k,v),t1,t2)-> if x=k then v
                        else if k > x then abr_search t1 x 
                            else abr_search t2 x;;

let rec abr_update t x = match t with
    Empty -> Tr(x,Empty,Empty)
    |Tr((k,v),t1,t2) -> let (a,b) = (fst x, snd x) 
                        in if k = a then Tr((a,b),t1,t2) 
                            else if k>a then Tr((k,v), abr_update t1 x, t2)
                                    else Tr((k,v), t1, abr_update t2 x);;

let rec abr_delmin = function
    Empty -> failwith "EmptyTree"
    |Tr(x,Empty,_)-> (x,Empty)
    |Tr(x,t1,t2)-> let (a,b) = abr_delmin t1 in (a, Tr(x,b,t2));;

let rec abr_delete t x = match t with 
    Empty-> Empty
    |Tr((k,v),t1,Empty)-> if k=x then t1 else failwith "qc"
    |Tr((k,v),Empty,t2)-> if k=x then t2 else failwith "qc"
    |Tr((k,v),t1,t2) -> if k = x then let (a,b) = abr_delmin t2 in Tr(a,t1,b)
                            else if k>x then Tr((k,v), abr_delete t1 x, t2)
                                    else Tr((k,v), t1, abr_delete t2 x);;

let rec abr_insert t x = match t with
    Empty -> Tr(x,Empty,Empty)
    |Tr(k,t1,t2) -> if k = x then Tr(x,t1,t2) 
                            else if k>x then Tr(k, abr_insert t1 x, t2)
                                    else Tr(k, t1, abr_insert t2 x);;
                
let tree_sort lst =
    let rec aux = function
        [] -> Empty
        |x::rest -> abr_insert (aux rest) x 
    in inorder (aux lst);;
