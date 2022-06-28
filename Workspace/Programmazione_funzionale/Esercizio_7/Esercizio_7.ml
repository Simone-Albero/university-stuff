(*Parte 1*)
type direzione = Su | Giu | Destra | Sinistra;;

type posizione = int * int * direzione;;

type azione = Gira | Avanti of int;;

(* gira : direzione -> direzione *)
let gira = function
Su -> Destra
| Giu -> Sinistra
| Destra -> Giu
| Sinistra -> Su;;

(* avanti : posizione -> int -> posizione *)
let avanti (x,y,dir) n =
match dir with
Su -> (x,y+n,dir)
| Giu -> (x,y-n,dir)
| Destra -> (x+n,y,dir)
| Sinistra -> (x-n,y,dir);;

(* sposta : posizione -> azione -> posizione *)
let sposta (x,y,dir) act =
match act with
Gira -> (x,y,gira dir)
| Avanti n -> avanti (x,y,dir) n;;

(* esegui : posizione -> azione list -> posizione *)
let rec esegui pos = function 
    [] -> pos
    |x::rest -> esegui (sposta pos x) rest;;

(*Parte 2*)
type nat = Zero | Succ of nat;;

(*nat_of_int: int -> nat*)
exception NotNat;;

let rec nat_of_int = function 
    0 -> Zero
    |x -> if (x < 0) 
          then raise NotNat 
          else Succ (nat_of_int (x-1));;

let rec int_of_nat = function 
    Zero -> 0
    | Succ k -> succ (int_of_nat k);;

(* somma : nat -> nat -> nat *)
let rec somma n m =
match n with
Zero -> m
| Succ k -> Succ(somma k m);;

(* prodotto: nat -> nat -> nat *)
let rec prodotto n = function 
Zero -> Zero
|Succ k -> somma n (prodotto k n);;

(*Parte 3*)
type chiave = Aperta | Chiusa;;

type cassaforte = chiave list;; 

exception EmptyList;;
exception BadFormat;;

let giraPrima = function
    [] -> raise EmptyList
    | x::rest -> match x with
                 Aperta -> Chiusa::rest
                 |Chiusa -> Aperta::rest;;

let rec giraDopoChiusa = function 
    [] -> raise EmptyList
    | [x] -> raise BadFormat
    | x::(y::rest as tail) -> if (x <> Chiusa) 
                               then x::giraDopoChiusa tail
                               else match y with
                                    Aperta -> x::Chiusa::rest
                                    |Chiusa -> x::Aperta::rest;;

let successori clst = try [giraPrima clst; giraDopoChiusa clst] 
                      with BadFormat -> [giraPrima clst];;

(*Parte 4*)
type obj = Miss | Cann | Barca;;

type situazione = obj list * obj list;;

let initial = ([Miss;Miss;Miss;Cann;Cann;Cann;Barca], []);;

type azione =
    From_left of obj list
    | From_right of obj list

(* safe: situazione -> bool *)
let rec count = function 
    [] -> (0, 0)
    |x::rest -> let (a, b) = count rest 
                in match x with 
                    Cann -> (a+1, b)
                    |Miss -> (a, b+1)
                    | _ -> (a,b);; 

let river_safe lst = 
    let river = count lst 
    in if ((fst river)>(snd river) && snd river <> 0) 
        then false
        else true;; 

let safe sit = river_safe (fst sit) && river_safe (snd sit);;

(* applica: azione -> situazione -> situazione *)
let chek river lst = (List.exists (function x -> x = Barca) river) && (count river >= count lst) && ((List.length lst)<3);; 

let rec remove this = function
    [] -> []
    |x::rest -> if x = this 
                then rest
                else x::remove this rest;; 

let rec remove_all fst = function   
    [] -> remove Barca fst
    |x::rest -> remove_all (remove x fst) rest;;


let prova act sit = match act with
    From_left x -> if chek (fst sit) x 
                   then (remove_all (fst sit) x, x @ (snd sit) @ [Barca]) 
                   else raise BadFormat
    |From_right x -> if chek (snd sit) x 
                     then (x @ (fst sit) @ [Barca], remove_all (snd sit) x)
                     else raise BadFormat;;    

exception NotSafe;;

let applica act sit = let new_sit = prova act sit 
                      in if safe new_sit
                         then new_sit
                         else raise NotSafe;;

let actions =
    let elems =
    [[Miss];[Cann];[Miss;Cann];[Miss;Miss];[Cann;Cann]]
    in (List.map (function x -> From_left x) elems)
    @ (List.map (function x -> From_right x) elems)

let from_sit sit = List.filter (fun x -> x<>([],[])) (List.map (function x -> try applica x sit with _ -> ([], [])) actions);;

(*Parte 5*)
type ’a pattern = Jolly | Val of ’a;;     