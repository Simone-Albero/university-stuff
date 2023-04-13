(*Parte 1b*)
(*combine: ’a list -> ’b list -> (’a * ’b) list*)
exception BadFormat;;

let rec combine fst snd = match (fst, snd) with
    ([],[]) -> []
    | (x::restx, y::resty) -> (x,y) :: combine restx resty
    | _ -> raise BadFormat;;

(*Parte 1c*)
let rec split = function 
    [] -> ([],[])
    | (x,y)::rest -> let (a, b) = split rest in (x::a , y::b);;

(*Parte 1d*)
let rec cancella this = function
    [] -> []
    | (k,v)::rest -> if (k = this) then  cancella this rest
                     else (k,v)::cancella this rest;;

(*Parte 2*)
(*implementa ADT Set: unione, intersezione, differenza, subset*)

let union fst snd = 
    let rec aux result = function 
        [] -> fst @ result
        | y::rest -> if (List.mem y fst) then aux result rest
                     else aux (result @ [y]) rest
in aux [] snd;;

let rec union set = function
    [] -> set
    | y::rest -> if (List.mem y set) then union set rest
                 else y::union set rest

let rec intersect set = function 
    [] -> []
    | y::rest -> if (List.mem y set) then y::intersect set rest
                 else intersect set rest;;

let rec setdiff fst snd = match fst with 
    [] -> []
    | x::rest -> if (List.mem x snd) then setdiff rest snd
                 else x::setdiff rest snd;;

let rec subset set = function 
    [] -> true 
    | x::rest -> if (List.mem x set) then subset set rest
                 else false;;

(*Parte 3*)
let explode str =
  let len = String.length str 
  in let rec aux index =
    if index >= len then []
    else str.[index] :: aux (index+1)  
  in aux 0;;

let rec implode = function 
    [] -> ""
    | x::rest -> (String.make 1 x) ^ (implode rest);;

(*Parte 4*)
(*coppie di n con i numeri da 1 ad n*)
let coppie n =
    let rec aux curr = match curr with 
        0 -> []
        |x -> (n, x)::aux (x-1)
in aux n;;

let intpairs n = 
    let rec loop index =
        if (index < 1) then [] 
        else coppie index @ loop (index-1)
in loop n;;

(*Parte 5*)
let rec trips  = function
    [x;y;z] -> [(x,y,z)]
    |x::y::z::rest -> (x,y,z)::trips (y::z::rest)
    |_->[];;

(*Parte 6*)
let rec take n = function 
    [] -> []
    |x::rest -> if (n = 0) then []
                else x::take (n-1) rest;;

let rec chose k = function 
    []-> []
    |x::rest as lst -> if (k <= List.length lst) then (take k lst) :: chose k rest
                       else [];; 

(*Parte 7*)
(*sottoproblema 1: preso un elemento della prima lista, in che indice compare nella seconda*)
(*se non lo trovo riporto un valore nullo (-1) *)
let rec memwindex elem lst= 
    let rec aux index = function 
        [] -> -1
        |x::rest -> if (elem = x) then index 
                    else aux (index+1) rest
    in aux 0 lst;;

(*soluzione*)
let strike_ball strike ball =
    let rec aux index (a,b) = function
        [] -> (a,b)
        |x::rest -> let find = memwindex x ball in  
                        if(find!=index && find!= -1) then aux (index+1) (a+1,b) rest
                        else if (find=index) then aux (index+1) (a,b+1) rest
                             else aux (index+1) (a,b) rest
    in aux 0 (0,0) strike;;

(*Parte 8a*)
(*inserisce un elemento in lista mantenendo l'ordinamento*)
let rec insert x = function 
    [] -> [x]
    |y::rest -> if x<y then x::y::rest
                else y::(insert x rest);; 

let rec insertion = function 
    [] -> []
    |x::rest -> insert x (insertion rest);;

(*Parte 8b*)
let pivot lst = List.nth lst ((List.length lst)/2);;  

let rec elem_max this = function 
    [] -> []
    |x::rest -> if(x>this) then x::(elem_max this rest)
                else elem_max this rest;;


let rec elem_min this = function 
    [] -> []
    |x::rest -> if(x<this) then x::(elem_min this rest)
                else elem_min this rest;;


let rec quicksort = function
    [] -> []
    |x::rest as lst -> quicksort(elem_min (pivot lst) lst) @ [pivot lst] @ quicksort (elem_max (pivot lst) lst);;
