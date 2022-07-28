(*Tipo Grafo*)
type 'a graph = ('a * 'a) list;;

let rec successori x = function  
    [] -> []
    |(a,b)::rest -> if a = x then b::successori x rest
                    else successori x rest;;

let rec vicini x = function 
    [] -> []
    |(a,b)::rest -> if a = x then b::vicini x rest
                    else if b = x then a::vicini x rest 
                    else vicini x rest;;

(*Parte 1*)
let test_connessi graph n m = 
    let rec search visited = function 
        [] -> false
        |x::rest -> if List.mem x visited 
                    then search visited rest
                    else x=m || search (x::visited) ((successori x graph) @ rest)
in search [] [n];;

let test = test_connessi [(1,2); (1,3); (1,4); (2,6); (3,5); (4,6); (5,4); (6,5); (6,7)] 2 3;;

(*Parte 2*)
let esiste_ciclo graph n =
    let rec search visited = function 
        [] -> false 
        |x::rest -> if List.mem x visited
                    then search visited rest 
                    else x=n || search (x::visited) ((successori x graph) @ rest) 
in search [] [n];;

let test = esiste_ciclo [(1,2); (1,3); (1,4); (2,6); (3,5); (4,6); (5,4); (6,5); (6,2)] 2;;

(*Parte 3*)
let ciclo graph n = 
    let rec from_node visited x =
        if List.mem x visited 
        then failwith "NotFound"
        else if n = x then [x]
             else x::from_list (x::visited) (successori x graph)
    and from_list visited = function 
        [] -> failwith "NotFound"
        |x::rest -> try from_node visited x
                    with _ -> from_list visited rest
    in n::from_list [] (successori n graph);;

let test = ciclo [(1,2); (1,3); (1,4); (2,6); (3,5); (4,6); (5,4); (6,5); (6,2)] 2;;

(*Parte 4*)
type 'a s_graph = 'a list * ('a * 'a ) list;;

let raggiungibile archi n1 n2 = 
    let rec search visited = function 
        [] -> false
        |x::rest -> if List.mem x visited 
                    then search visited rest
                    else x = n2 || search (x::visited) (vicini x archi @ rest) 
    in search [] [n1];;

let grafo_connesso (nodi, archi) =  
    let rec aux = function 
        [] -> true 
        |n1::n2::rest -> (raggiungibile archi n1 n2) && aux (n2::rest) 
        |_ -> true 
    in aux nodi;;

let test = grafo_connesso ([1;2;3;4;5],[(1,2);(1,4);(2,1);(2,3);(2,5);(3,2);(4,1);(4,5);(5,2);(5,4)]);;

(*Parte 5*)
type obj = Miss | Cann | Barca
type situazione = obj list * obj list 
let initial = ([Miss;Miss;Miss;Cann;Cann;Cann;Barca], [])
type azione =
    From_left of obj list
  | From_right of obj list

(* Riporto qui il codice dell'esercizio 4 del gruppo 7,
   con le definizioni di safe, applica e from_sit *)
(* conta : 'a -> 'a list -> int *)
(* conta x list = numero di occorrenze di x in lst *)
let conta x lst =
  List.length (List.filter ((=) x) lst)

(*  safe : situazione -> bool
    safe sit = true se la situazione sit e' sicura (in nessuna delle due
        rive i missionari, se presenti, sono in numero inferiore ai cannibali *)
(* aux: obj list -> bool
   aux riva = true se nella lista riva il numero di messionari, se
      diverso da 0, non e' inferiore al numero di cannibali *)
let safe (left,right) =
  let aux riva =
    let miss = conta Miss riva
    in miss=0 || miss >= conta Cann riva
  in aux left && aux right

exception Impossible
(* togli_un : 'a -> 'a list -> 'a list *)
(* togli x lst : elimina un'occorrenza di x dalla lista lst *)
let rec togli_un x = function
    [] -> raise Impossible
  | y::rest -> 
      if y=x then rest
      else y::togli_un x rest
(* togli : 'a list -> 'a list -> 'a list
   togli source lst = elimina da source un'occorrenza di ogni elemento
                      di lst *)
let rec togli source = function
    [] -> source
  | x::rest ->
      togli (togli_un x source) rest

(* applica : azione -> situazione -> situazione 
   applica act sit riporta la situazione che si ottiene applicando
   l'azione act a sit; solleva Impossible se l'azione non e'
   applicabile o se la situazione risultante non e' sicura *)
let applica act (left,right) =
  let result = 
    match act with
      From_left lst ->
	if List.length lst > 2 || lst=[]
	then raise Impossible
	else (togli_un Barca (togli left lst),
	      Barca::lst @ right)
    | From_right lst ->
	if List.length lst > 2 || lst=[]
	then raise Impossible
	else (Barca::lst @ left,
	      togli_un Barca (togli right lst))
  in if safe result then result
  else raise Impossible

(* 
# applica (From_left [Miss]) initial;;
Exception: Impossible.
# applica (From_left [Miss;Cann]) initial;;
- : obj list * obj list = ([Miss; Miss; Cann; Cann], [Barca; Miss; Cann])
*)

(* actions: azione list *)
(* tutte le possibili azioni *)
let actions =
  let elems =
    [[Miss];[Cann];[Miss;Cann];[Miss;Miss];[Cann;Cann]]
  in (List.map (function x -> From_left x) elems)
  @ (List.map (function x -> From_right x) elems)

(* from_sit : situazione -> situazione list
   from_sit sit : genera tutte le situazioni che si possono ottenere
   applicando un'azione possibile a sit *)
(* aux: azione list -> situazione list
   aux actlist = lista delle situazioni safe che risultano
                dall'applicazione di tutte le azioni in actlist
                applicabili alla situazione sit (parametro della 
                principale) *)
let from_sit sit =
  let rec aux = function
      [] -> []
    | a::rest ->
	try applica a sit :: aux rest
	with Impossible -> aux rest
  in aux actions

let goal (lft, _) = lft = [];;

let rec remove this = function 
    [] -> failwith "NotFound"
    |x::rest -> if x = this then rest 
                else x::remove this rest;;


let equal (sin,dx) (sinistra,destra) =
  List.sort compare sin = List.sort compare sinistra
    && List.sort compare dx = List.sort compare destra;;

let mis_can () = 
    let rec from_node visited node =
        if List.exists (equal node) visited then failwith "NotFound"
        else if goal node then [node]
             else node::from_list (node::visited) (from_sit node)

    and from_list visited = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n
                    with _ -> from_list visited rest
    
    in from_node [] initial;;

(*Parte 6a*)
type 'a s_graph = 'a list * ('a * 'a ) list;;

let rec remove this = function 
    [] -> failwith "NotFound"
    |x::rest -> if x = this then rest 
                else x::remove this rest;;

let cammino (node, edge) lst start goal =
    let rec from_node  = function  
        |(n, []) -> failwith "NotFound"
        |(n, [x])-> if n = goal && n=x then [n]
                          else failwith "NotFound"
        |(n, x) -> n::from_list (remove n x) (vicini n edge)
                
    and from_list lst = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node (n, lst)
                    with _ -> from_list lst rest 
    
    in from_node (start, lst);;

let test = cammino ([1;2;3;4;5;6;7],[(1,2); (1,3); (1,4); (2,6); (3,5); (4,6); (5,4); (6,5); (6,7)]) [1;3;5] 1 5;;

(*Parte 6b*)

let ciclo_hamiltoniano node edge start = 
    let rec from_node n node = 
        if start = n && node = [n] then [n]
        else n::from_list (remove n node) (successori n edge)

    and from_list  lst = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node n lst
                    with _ -> from_list lst rest
    in from_list node (successori start edge);;
        

let hamiltoniano (node, edge)= 
    let rec aux = function 
    ([],_) -> failwith "NotFound"
    |(n::rest, edge) -> try n::ciclo_hamiltoniano node edge n
                        with _ -> aux (rest, edge)
    in aux (node,edge);;
                                  
let test = hamiltoniano ([1;2;3;4;5;6;7], [(2,7); (1,2); (2,3); (3,4); (4,5); (5,6); (6,7); (6,5); (7,1)]);;

(*Parte 7*) 
type col = Rosso | Giallo | Verde | Blu;;
type 'a col_assoc = (col * 'a list) list;;

let rec col_search x = function
    [] -> failwith "NotFound"
    |(a,b)::rest -> if List.mem x b then a
                    else col_search x rest;; 

let colori_alterni graph cols start goal =
    let rec from_node visited node =
        if List.mem node visited then failwith "NotFound"
        else if node = goal then [node]
             else node::from_list (node::visited) (col_search node cols) (successori node graph)
    
    and from_list visited col = function 
        [] -> failwith "NotFound"
        |n::rest -> if (col_search n cols) <> col then 
                        try from_node visited n 
                        with _ -> from_list visited col rest
                    else from_list visited col rest   
    
    in from_node [] start;;

let test = colori_alterni ([(1,2);(1,3);(3,5);(5,2);(2,9)]) ([(Rosso,[1;2;4;7;10]); (Giallo,[3;8;11]); (Verde,[0;5;6;13]); (Blu,[9;12;14;15])]) 1 9;;

(*Parte 8*)
let is_connessi graph start goal = 
    let rec search visited = function  
        [] -> false 
        | n::rest ->  if n = goal then true 
                      else if List.mem n visited then search visited rest 
                      else search (n::visited) (successori n graph)
    in search [] [start];;


let connessi_in_glist glst n1 n2 = 
    if n1 <> n2 
    then List.exists (fun x -> (is_connessi x n1 n2) || (is_connessi x n2 n1)) glst 
    else false;;

let test = connessi_in_glist [[(1,2);(1,3);(3,5);(5,2);(2,9)]; [(1,2);(1,3);(3,5);(5,2);(2,9)]; [(2,9);(11,3);(3,5);(5,2);(9,20)]] 11 20;;

(*Parte 9*)

let rec remove this = function 
    [] -> []
    |x::rest -> if x = this then rest 
                else x::remove this rest;;

let cammino_con_nodi graph start lst = 
    let rec from_node visited n lst= 
        if List.mem n visited then failwith "NotFound"
        else if lst = [] then []
        else n::from_list (n::visited) (remove n lst) (successori n graph)

    and from_list visited lst = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n lst 
                    with _ -> from_list visited lst rest

    in from_node [] start lst;;

let test = cammino_con_nodi [(1, 2); (1, 3); (1, 4); (2, 6); (3, 5); (4, 6); (6, 5); (6, 7); (5, 4)] 1 [2; 5];;

(*Parte 10*)  

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

let c_successori clst = try [giraPrima clst; giraDopoChiusa clst] 
                      with BadFormat -> [giraPrima clst];;

let lstcons this lst = List.map (function x -> this::x) lst;;

(*liste con tutte liste di lunghezzza n con a e b *)
let tutte_liste_con n a b = 
    let rec aux = function
    0 -> [[]]
    | x -> lstcons a (aux (x-1)) @ lstcons b (aux (x-1))  
in aux n;;

let nodi n = tutte_liste_con n Aperta Chiusa;;

let archi n = List.map (fun x -> (x, c_successori x)) (tutte_liste_con n Aperta Chiusa);;

let rec start = function 
    0 -> []
    |x -> Chiusa :: start (x-1);;

let aperta clst = List.for_all (fun x -> x = Aperta) clst;;

let apri n = 
    let rec from_node visited node = 
        if List.mem node visited then failwith "NotFound"
        else if aperta node then [node]
             else node::from_list (node::visited) (c_successori node)

    and from_list visited = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n 
                    with _ -> from_list visited rest
    in from_node [] (start n);;

(*Parte 11*)
let is_primo n =
    let rec aux = function 
        1 | 0 -> true 
        |x -> if (n mod x) = 0 then false 
                else aux (x-1)
    in if n <= 0 then false else aux (n-1);;

let cammino_di_primi graph start goal =
    let rec from_node n = 
        if n = goal && is_primo n then [n]
        else if is_primo n then n::from_list (successori n graph)
             else failwith "NotFound"
    
    and from_list = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node n 
                    with _ -> from_list rest
    in from_node start;;

let test = cammino_di_primi [(1, 2); (1, 3); (1, 4); (2, 6); (3, 5); (4, 6); (6, 5); (6, 7); (5, 7)] 1 7;;


(*Parte 13*)

let path_n_p graph p n start =
    let rec from_node value visited node = 
        if List.mem node visited then failwith "NotFound"
        else if value = 0 then []
            else if p node then node::from_list (value-1) (node::visited) (successori node graph)
                else node::from_list (value) (node::visited) (successori node graph)
    
    and from_list value visited = function 
        [] -> failwith "NotFound"
        |node::rest -> try from_node value visited node 
                        with _ -> from_list value visited rest
    
    in from_node n [] start;;

let test = path_n_p [(1,3);(2,6);(3,4);(3,5);(3,6);(4,2); (4,5);(5,4);(6,5)] (fun x -> x mod 2 = 0) 2 1;;


(*Parte 12*)

type form = Prop of string | Not of form | And of form * form | Or of form * form;;


let rec is_neg form1 form2 = (form1 = Not form2) || (form2 = Not form1);;

let test = is_neg (Not(And(Prop "a", Prop "b"))) (And(Prop "a", Prop "c"));;

let non_contradictory_path graph start goal = 
    let rec from_node node prev_lst = 
        if node = goal &&  not (List.exists (is_neg node) prev_lst) then [node]
            else if not (List.exists (is_neg node) prev_lst) then node::from_list (node::prev_lst) (successori node graph)
                else failwith "NotFound"

    and from_list prev_lst = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node n prev_lst
                    with _ -> from_list prev_lst rest

    in from_node start [];; 

let test = non_contradictory_path ([(Prop "a", Prop "b"); (Prop "a", Prop "c"); (Prop "c", Prop "f"); (Prop "b", Prop "e"); (Prop "e", Not(Prop "e")); (Not(Prop "e"), Prop "f")]) (Prop "a") (Prop "f");;
