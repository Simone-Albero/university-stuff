(*Settembre 2020*)
type 'a graph = ('a * 'a) list;;

let rec successori this = function 
    [] -> []
    |(n,a)::rest -> if n = this then a::successori this rest
                    else successori this rest;; 

let percorso graph start tappa goal =
    let rec from_node visited flag node =
        if List.mem node visited then failwith "NotFound"
        else if ((flag || node = tappa) && node = goal)  then [node]
             else node::from_list (node::visited) (if node = tappa || flag then true else false) (successori node graph)

    and from_list visited flag = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited flag n 
                    with _ -> from_list visited flag rest

    in from_node [] false start;;

let test = percorso [(1, 2); (1, 3); (1, 4); (2, 6); (3, 5); (4, 6); (5, 4); (6, 5); (6, 7)] 1 2 7;;

(*Febbraio 2020*)
(*stazione * stazione * linea_di_collegamneto*)
type metro = (int * int * string) list;;

(*line: metro → string → int list*)
(*line m ln riporti (senza ripetizioni) una lista con tutte le stazioni per le quali passa la linea ln. *)
let rec line metro l = match metro with 
    [] -> []
    |(a,b,c)::rest -> let prev_lst = line rest l 
                      in if l = c then (if List.mem a prev_lst then [] else a)::(if List.mem b prev_lst then [] else b)::prev_lst 
                         else prev_lst;;

(*vicini: int → metro → (int × string) list*)
(*vicini stazione m riporti la lista delle coppie (s,ln) tali che s è una stazione direttamente collegata 
(adiacente) a stazione mediante la linea ln nella rete m *)
let rec vicini n = function 
    [] -> []
    |(a,b,c)::rest -> if a = n then (b,c)::vicini n rest
                      else if b = n then (a,c)::vicini n rest 
                           else vicini n rest;;

(*raggiungi: metro → int → int → int → int list*)
(*tale che raggiungi m maxc start goal riporti una lista di stazioni rap-
presentante un percorso, nella rete m, dalla stazione start alla stazione
goal nel quale si cambi treno (linea) al massimo maxc volte. La funzione
solleverà un'eccezione se un tale percorso non esiste*)

(*from_node: int -> int list -> int -> string -> int list*)
(*tale che from_node node visited cambi prev_l riporti il cammino aciclico che esclude le ripetizioni dei nodi contenuti in visited dal nodo node al nodo goal che 
non contenga più di: maxc - cambi cambi*)

(*from_list: int list -> int -> string -> (int*string) list -> (int*string) list *)
(*tale che from_list visited cambi prev_l node_list riporti se esiste un cammino aciclico che esclude le ripetizioni dei nodi contenuti in visited tra uno dei nodi 
contenuti in node_list e goal che non contenga più di: mac_c cambi - cambi *)

let raggiungi metro maxc start goal =
    let rec from_node node visited cambi prev_l = 
        if List.mem node visited then failwith "NotFound"
        else if node = goal && cambi <= maxc then [node]
             else node::from_list (node::visited) cambi prev_l (vicini node metro)

    and from_list visited cambi prev_l = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node (fst n) visited (if snd n <> prev_l then cambi+1 else cambi) (snd n)
                    with _ -> from_list visited cambi prev_l rest

    in from_node start [] (-1) "";; 

let test = raggiungi [(1,2,"A"); (2,3,"A"); (3,1,"A"); (2,4,"B"); (4,5,"B"); (4,6,"C"); (6,3,"C"); (5,7,"D"); (6,7,"D")] 2 6 1;;

(*Giugno 2021*)

(*depth_limited: α graph → α → α → int → α list *)
(*tale che depth_limited g start goal depth riporti, se esiste, un cammino 
nel grafo g dal nodo start al nodo goal la cui lunghezza non sia maggiore di depth *)

(*from_node: a' -> int -> 'a list *)
(*tale che from_node node curr_d riporta, se esiste, un cammino da node a goal la cui lunghezza sia minore di depth - curr_d *)

(*from_list: int -> 'a list -> 'a list*)
(*tale che from_list curr_d node_list riporta, se esiste, un cammino tra uno dei nodi contenuti in node_list e goal la cui lunghezza sia minore di depth - curr_d *)

let depth_limited graph start goal depth = 
    let rec from_node node curr_d = 
        if curr_d > depth then failwith "NotFound"
        else if node = goal then [node]
             else node::from_list (curr_d + 1) (successori node graph)

    and from_list curr_d = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node n curr_d 
                    with _ -> from_list curr_d rest

    in from_node start 0;;

let test = depth_limited [(1,2);(1,4);(2,4);(3,2);(3,6);(4,3);(4,4);(4,5);(5,6);(6,3)] 1 6 5;;

(*path: α graph → α → α → int → α list*)
(*path g start goal maxdepth reitera la ricerca in profondità limitata fino a che il limite 
depth non supera il valoremaxdepth *)

(*aux: int -> α list*)
(*tale che aux n restituisce il cammino di profondità minima da start a goal a partire da n*)
let path graph start goal depth =
    let rec aux n = 
        if n > depth then failwith "NotFound"
        else try depth_limited graph start goal n 
             with _ -> aux (n+1)
    in aux 0;;

(*Febbraio 2019*)
let rec vicini n = function 
    [] -> []
    |(a,b)::rest -> if a = n then b::vicini n rest
                    else if b = n then a::vicini n rest
                         else vicini n rest;;

type color = Rosso | Verde | Neutro;;

(*path: α graph → (α × color) list → color list → α → α list*)
(*tale che path g colors lst start riporti (se esiste) un cammino aciclico in g che parte da start e rispetta la lista lst. Se un
tale cammino non esiste, la funzione solleverà un'eccezione *)

(*from_node: 'a list -> 'a -> 'b list -> 'a list *)
(*tale che from_node visited node lst riporta, se esiste, il cammino aciclico da node che e rispetta la lista lst e che non ammette ripetizioni dei nodi in visited *)

(*from_list: 'a list -> 'b list -> 'a list -> 'a list *)
(*tale che from_list visited lst node_lst che riporta, se esiste, il cammino aciclico tra da uno dei nodi in node_lst e 
che rispetta la lista lst e che non ammette ripetizioni dei nodi in visited*)

let path graph cols lst start = 
    let rec from_node visited node lst =
        if List.mem node visited then failwith "NotFound"
        else if lst = [] then []
             else node::from_list (node::visited) ( if List.assoc node cols = (List.hd lst) then List.tl lst else lst) (vicini node graph)
    
    and from_list visited lst = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n lst 
                    with _ -> from_list visited lst rest

    in from_node [] start lst;;

let test = path [(1,3);(1,2);(3,2);(3,4);(3,5);(2,5);(5,6);(5,7);(7,8)] [(1, Neutro); (2, Rosso); (3, Verde); (4, Verde); (5, Neutro); (6, Verde); (7, Rosso); (8, Neutro)] [Verde;Rosso] 1;;


(*path: ('a * 'a) list -> (a' -> bool) -> int -> 'a -> 'a list *)
(*tale che path graph p k start riporti, se esiste, un cammino aciclico in graph che parte da start e contiene esattamente k nodi che soddisfano p*)

(*from_node: 'a list -> 'a -> int -> 'a list *)
(*tale che from_node visited node curr_k riporta, se esiste, un cammino aciclico senza ripetizioni di nodi in visited a partire da node contenente curr_k nodi *)

(*from_list: 'a list -> int -> 'a list -> 'a list *)
(*tale che from_list visited curr_k node_list riporta, se esiste, un cammino aciclico senza ripetizioni di nodi in visited a partire da uno dei nodi di node_list contenente curr_k nodi *)

let path graph p k start =
    let rec from_node visited node curr_k = 
        if List.mem node visited || not (p node) then failwith "NotFound"
        else if curr_k = 1 then [node]
             else node::from_list (node::visited) (curr_k-1) (vicini node graph)
        
    and from_list visited curr_k = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n curr_k
                    with _ -> from_list visited curr_k rest
    
    in from_node [] start k;;

let test = path [(1,3);(1,2);(3,2);(3,4);(3,5);(2,4);(4,6);(5,7);(7,8)] (fun x -> x mod 2 = 0) 3 2;;

(*ciclo: ’a graph -> ’a -> ’a list *)
(*tale che ciclo graph start riporti, se esiste, una lista di nodi rappresentante un ciclo raggiungibile da start *)

(*from_node: 'a list -> 'a -> 'a list *)
(*tale che from_node visited node riporti se esiste una lista di nodi rappresentante un ciclo raggiungibile da node *)

(*from_list: 'a list -> 'a list -> 'a list *)
(*tale che from_node visited node_list riporti se esiste una lista di nodi rappresentante un ciclo raggiungibile da uno dei nodi in node_list *)

let rec listfrom n = function 
    [] -> []
    |x::rest -> if x = n then x::rest
                else listfrom n rest;;

let rec taile = function 
    [] -> failwith "NotFound"
    |[x] -> x
    |x::rest -> taile rest;;

let ciclo graph start =
    let rec from_node visited node =
        if List.mem node visited then [node]
        else node::from_list (node::visited) (successori node graph)

    and from_list visited = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n 
                    with _ -> from_list visited rest

    in let lst = from_node [] start 
        in listfrom (taile lst) lst;;

let test = ciclo [(1,2);(2,3);(3,4);(4,5);(5,6);(6,4)] 1;;

(* pathwith: ’a -> ’a graph -> ’a -> ’a -> ’a list *)
(*tale che pathwith riporti, se esiste, un cammino non ciclico da start a goal che passi per il nodo n *)

(*from_node: 'a list -> 'a -> 'a list *)
(*tale che from_node visited node riporti, se esiste, un cammino aciclico senza ripetizioni di nodi in visited da node a goal che passi per il nodo n *)

(*from_list: 'a list -> 'a list -> 'a list *)
(*tale che from_node visited node_list riporti, se esiste, un cammino aciclico senza ripetizioni di nodi in visited da uno dei nodi in node_list a goal che passi per il nodo n  *)

let pathwith n graph start goal =
    let rec from_node visited node = 
        if List.mem node visited then failwith "NotFound"
        else if List.mem n visited && node = goal then [node]
             else node::from_list (node::visited) (vicini node graph)
    
    and from_list visited = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n 
                    with _ -> from_list visited rest 
    
    in from_node [] start;;

let test = pathwith 4 [(1,2);(1,3);(2,4);(2,5); (3,4);(4,5)] 1 3;;

type 'a w_graph = ('a * 'a * int) list;;

(*wsuccessori: 'a -> ('a * 'a * int) list -> ('a * int) list *)
let rec wsuccessori n = function 
    [] -> []
    |(a,b,p)::rest -> if n = a then (b,p)::wsuccessori n rest
                else wsuccessori n rest;;

(* wpath: ’a graph -> ’a -> ’a -> int -> (’a list * int) *)
(*wpath g start goal pesomax = (path,w), dove path è un cammino di peso non superiore a pesomax, da start a goal in g, e w è il peso di path*)

(*from_node: 'a -> int -> ('a list * int) *)
(*tale che from_node node cur_p riporti, se esiste, la coppia (path, p) dove path è un cammino da node a goal, e p è intero di peso inferiore a p_max - curr_p*)

(*from_list: int -> ('a * int) list -> ('a list * int) *)
(*tale che from_list cur_p node_list riporti, se esiste, la coppia (path, p) dove path è un cammino da uno dei nodi un node_list a goal, e p è intero di peso inferiore a p_max - curr_p*)

let wpath graph start goal p_max =
    let rec from_node node curr_p =
        if curr_p > p_max then failwith "NotFound"
        else if node = goal then ([node], curr_p)
             else let (path, p) = from_list curr_p (wsuccessori node graph) in (node::path, p)

    and from_list curr_p = function
        [] -> failwith "NotFound"
        |(n,p)::rest -> try from_node n (curr_p + p) 
                        with _ -> from_list curr_p rest
    
    in from_node start 0;;

let test = wpath [('A','B', 2);('A','D', 1);('B','B', 1);('B','C', 1);('B','E', 8);('C','E', 5);('C','D', 3);('C','A', 3);('D','C', 6);('D','E', 10)] 'A' 'E' 8;;

(*ciclo_valido: 'a graph ->'a list list -> 'a -> 'a list *)
(* *)
let rec successori this = function 
    [] -> []
    |(n,a)::rest -> if n = this then a::successori this rest
                    else successori this rest;; 

let rec find_remove n = function
    [] -> []
    |x::rest -> if List.mem n x then rest 
                else x::find_remove n rest;;

let ciclo_valido graph lst start =
    let rec from_node visited node curr_lst = 
        if List.mem node visited then failwith "NotFound"
        else if node = start && curr_lst = [] then [node]
             else node::from_list (node::visited) (find_remove node curr_lst) (successori node graph)
    
    and from_list visited curr_lst = function 
        [] -> failwith "NotFound"
        |n::rest -> try from_node visited n curr_lst
                    with _ -> from_list visited curr_lst rest
    
    in start::from_list [] (find_remove start lst) (successori start graph);;

let test = ciclo_valido ([(3,4);(3,6);(4,5);(4,7);(5,6);(7,6);(6,8);(6,1);(8,5);(1,2);(2,3)]) [[3;8];[7;5]] 1;;


type 'a money = ('a * int) list;;

type 'a graph = ('a * 'a) list;;

(*safe_path: 'a * 'a list -> 'a * int list -> 'a -> 'a -> int -> 'a list*)
let safe_path graph wallet start goal init = 
    let rec from_node node visited curr_w =
        if List.mem node visited || curr_w < 0 then failwith "NotFound"
        else if node = goal && curr_w + List.assoc node wallet >= 0 then [node]
             else node::from_list (node::visited) (curr_w + List.assoc node wallet) (vicini node graph)
    
    and from_list visited curr_w = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node n visited curr_w
                    with _ -> from_list visited curr_w rest
    
    in from_node start [] init;;

exception Errore;;

let test = safe_path [('A','B');('A','C');('B','B');('B','C');('B','E');('C','E');('C','D');('C','A');('D','C');('D','E')] [('A',1);('B',7);('C',-7);('D',7);('E',7)] 'A' 'E' 0;;


(*comptio:  *)
let compito graph start goal k = 
    let rec from_node node visited curr_v =
        if List.mem node visited || curr_v > k then failwith "NotFound"
        else if node = goal then (curr_v,[node])
             else let (v,path) = from_list (node::visited) (curr_v) (vicini node graph) in (v, node::path)
    
    and from_list visited curr_v = function
        [] -> failwith "NotFound"
        |n::rest -> try from_node n visited (curr_v + n)
                    with _ -> from_list visited curr_v rest
    in from_node start [] start;;

let test = compito [(2,30);(2,4);(4,8);(5,30);(10,20);(10,5);(10,2);(20,4);(30,8)] 10 8 25;;

(*sorted_path: *)

let sorted_path graph start goal = 
    let rec from_node node visited flag= 
        if List.mem node visited then failwith "NotFound" 
        else if node = goal then [node]
             else node::from_list (node::visited) node flag (successori node graph)
    
    and from_list visited prev flag = function
        [] -> if flag then List.tl (from_node prev (List.tl visited) false) else failwith "NotFound"
        |n::rest -> if flag 
                    then if n >= prev then try from_node n visited flag
                                            with _ -> from_list visited prev flag rest
                         else from_list visited prev flag rest
                    else if n <= prev then try from_node n visited flag
                                           with _ -> from_list visited prev flag rest
                          else from_list visited prev flag rest
    in from_node start [] true;;

let test = sorted_path [(8,7);(7,6);(40,80);(6,5);(5,4);(10,20);(10,2);(20,40);(30,8)] 8 4;;