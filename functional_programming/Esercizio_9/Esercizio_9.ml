type 'a ntree = Ntree of 'a * 'a ntree list;;

(*Parte 1*)
type multi_expr =
    MultiInt of int
    | MultiVar of string
    | MultiDiff of multi_expr * multi_expr
    | MultiDiv of multi_expr * multi_expr
    | MultiSum of multi_expr list
    | MultiMult of multi_expr list

(*Parte 1a*)
let rec subexpr e1 e2 = 
    e1 = e2 || match e1 with        
        MultiDiff (x,y) | MultiDiv (x,y) -> subexpr x e2 || subexpr y e2
        | MultiSum lst | MultiMult lst ->  subexprlst lst e2
        |_ -> false
and subexprlst lst expr = match lst with 
    [] -> false
    |x::rest -> subexpr x expr || subexprlst rest expr;;

let test = subexpr (MultiDiff(MultiInt 3, MultiSum [MultiInt 3;MultiInt 5;MultiInt 4])) (MultiInt 5);;

(*Parte 1b*)
let rec subst e1 var e2 = match e1 with
    MultiVar x -> if x = var then e2 else MultiVar x
    |MultiDiff (x,y) -> MultiDiff ((subst x var e2), (subst y var e2))
    |MultiDiv (x,y) -> MultiDiv ((subst x var e2), (subst y var e2))
    |MultiSum lst -> MultiSum (List.map (function x -> subst x var e2) lst) 
    |MultiMult lst -> MultiMult (List.map (function x -> subst x var e2) lst)
    |expr -> expr;;

let test = subst (MultiDiff(MultiInt 3, MultiSum [MultiInt 3;MultiVar "y";MultiInt 4])) "y" (MultiInt 5);;

(*Parte 2a*)
let rec postorder = function
    Ntree(x,[]) -> [x] 
    |Ntree(x,tlst) -> postorderlst tlst @ [x]

and postorderlst = function 
    [] -> []
    |x::rest -> postorder x @ postorderlst rest;;

let test = postorder (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 2b*)

let rec innorder = function
    Ntree(x,[]) -> [x] 
    |Ntree(x,t::rest) -> innorder t @ [x] @ innorderlst rest

and innorderlst = function  
    [] -> []
    |t::rest -> innorder t @ innorderlst rest;;

let test = innorder (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 3*)
let rec foglie_in_lista lst = function 
    Ntree(x,[]) -> List.mem x lst 
    |Ntree(x,tlst) -> foglie_alberi lst tlst 

and foglie_alberi lst = function
    [] -> true
    |t::rest -> foglie_in_lista lst t && foglie_alberi lst rest;; 

let test = foglie_in_lista [5;6;2;3] (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 4*)
let rec num_di_foglie = function
    Ntree(x,[]) -> 1
    |Ntree(x,tlst) -> subt_foglie tlst

and subt_foglie = function 
    [] -> 0
    |t::rest -> num_di_foglie t + subt_foglie rest;;

let test = num_di_foglie (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;


(*Parte 5*)
let rec listaGuida lst (Ntree(r,tlst)) = match lst with
    [] -> r
    |x::rest -> scorri x rest tlst

and scorri x lst tlst = match (x, tlst) with
    (0, t::rest)-> listaGuida lst t
    |(x, t::rest) -> scorri (x-1) lst rest
    |_ -> failwith "WrongPath";; 

let test = listaGuida [0] (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 6*)
let max_pair a b = if snd a > snd b then a 
                    else b;;

let rec foglia_costo = function
    Ntree(x,[]) -> (x,x)
    |Ntree(x,tlst) -> let (a,b) = foglia_max tlst in (a,b+x)

and foglia_max = function
    [t] -> foglia_costo t
    |t::rest -> let (a,b) = foglia_costo t
                in let (c,d) = foglia_max rest
                in max (a,b) (c,d)
    |_ -> failwith "qc";; (*non arrivo mai in questo caso*)

let test = foglia_costo (Ntree(2, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 7*)
let rec tutte_foglie_costi = function
    Ntree(r, []) -> [(r,r)]
    |Ntree(r,tlst) ->  List.map (fun (a,b) -> (a,b+r)) (foglie_costi tlst)

and foglie_costi = function
    [] -> []
    |t::rest -> tutte_foglie_costi t @ foglie_costi rest;;

let test = tutte_foglie_costi (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 8*)
let rec remove k = function 
    [] -> failwith "NotFound"
    |x::rest -> if x = k then rest else x::remove k rest;;

let rec ramo_da_lista t lista x =
  match t with
    Ntree(y,[]) ->
      if x=y && lista=[y] then [y]
      else failwith "NotFound"
  | Ntree(y,tlist) ->
      y::cerca_ramo (remove y lista) x tlist
and cerca_ramo lista x = function
    [] -> failwith "NotFound"
  | t::rest ->
      try ramo_da_lista t lista x
      with _ -> cerca_ramo lista x rest;;


let test = ramo_da_lista (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])])) [1;2] 2;;

(*Parte 9*)
let is_primo x = 
    let rec aux = function 
        1 -> true 
        |n -> (x mod n) <> 0 && aux (n-1) 
in x=1 || x>1 && aux (x-1);;

let rec ramo_di_primi = function
    Ntree(r,[]) -> if is_primo r then r
                    else failwith "NotFound"
    |Ntree(r, tlst) -> if is_primo r then sub_primi tlst
                        else failwith "NotFound"

and sub_primi = function 
    [] -> failwith "NotFound"
    |t::rest -> try ramo_di_primi t
                with _ -> sub_primi rest;;

let test = ramo_di_primi (Ntree(1, [Ntree(6,[]); Ntree(4,[]); Ntree(3,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 10*)
let rec path_non_pred p = function 
    Ntree (r,[]) -> if not(p r) then [r] 
                    else failwith "NotFound"
    |Ntree (r,tlst) -> if not (p r) then r::sub_path p tlst
                        else failwith "NotFound"

and sub_path p = function
    [] -> failwith "NotFound"
    |t::rest -> try path_non_pred p t 
                with _ -> sub_path p rest;;

let test = path_non_pred (fun x -> x mod 2 <> 0) (Ntree(1, [Ntree(6,[]); Ntree(4,[]); Ntree(3,[Ntree(5,[]); Ntree(6,[])])]));;

(*Parte 11*)
let rec same_structure t1 t2 = match (t1,t2) with 
    (Ntree(_,[]), Ntree(_,[])) -> true
    |(Ntree(_,tlst1), Ntree(_,tlst2)) -> same_substruct tlst1 tlst2

and same_substruct tlst1 tlst2 = match (tlst1,tlst2) with 
    ([],[]) -> true
    |(t1::rest1, t2::rest2) -> same_structure t1 t2 && same_substruct rest1 rest2
    |_ -> false;;

let test = same_structure (Ntree(1, [Ntree(6,[]); Ntree(4,[]); Ntree(3,[Ntree(5,[]); Ntree(6,[])])])) (Ntree(1, [Ntree(3,[]); Ntree(5,[Ntree(7,[]); Ntree(6,[])])]));;

(*Parte 12*)
type col = Rosso | Giallo | Verde | Blu;;
type 'a col_assoc = (col * 'a list) list;;

let rec find_col x = function 
    [] -> failwith "NotFound"
    |(a,b)::rest -> if List.mem x b then a 
                    else find_col x rest;;

let rec ramo_colorato x cols = function
    Ntree (r,[]) -> if r = x then [r]
                    else failwith "NotFound"
    |Ntree (r,tlst) -> let col = find_col r cols in r::sub_cols x cols (List.filter (function Ntree(a,_) -> (find_col a cols) <> col)  tlst)

and sub_cols x cols = function
    [] -> failwith "NotFound"
    |t::rest -> try ramo_colorato x cols t 
                with _ -> sub_cols x cols rest;;

let test = ramo_colorato 6 [(Rosso, [1;6;2;3]); (Verde, [5;4])] (Ntree(1, [Ntree(2,[]); Ntree(3,[]); Ntree(4,[Ntree(5,[]); Ntree(6,[])])]));;
