(*Parte 1a*)
let rec length = function 
    [] -> 0
    | x :: rest -> 1 + length(rest);;

(*Parte 1b*)
let rec sumof = function 
    [] -> 0
    | x::rest -> x + sumof(rest);;

(*Parte 1c*)
exception EmptyList;;

let rec maxlist = function
    [] -> raise EmptyList
    | [x] -> x
    | x::rest -> if x > maxlist(rest) then x
                 else maxlist(rest);;     

(*Parte 1d*)
let rec drop n = function 
    [] -> []
    | x::rest as list -> if (n = 0) then list 
                         else drop (n-1) rest;;

(*Parte 1e*)
let rec append list1 list2 = match list1 with
    [] -> list2
    | x::rest -> x::append rest list2;;

(*Parte 1f*)
let rec reverse = function 
    [] -> []
    | [x] -> [x]
    | x::rest -> reverse(rest) @ [x];;

(*Parte 1g*)
exception BadFormat;;

let rec nth n = function
    [] -> raise BadFormat
    | x::rest as list -> if(n<0 || n>(length list)) then raise BadFormat
                         else if (n=0) then x
                              else nth (n-1) rest;;

(*Parte 1h*)
let rec remove this = function
    [] -> []
    | x::rest -> if (x=this) then remove this rest
                 else x::remove this rest;;

(*Parte 2a*)
let rec copy n = function
    x -> if (n=0) then []  
         else x::copy (n-1) x;;

(*Parte 2b*)
let rec nondec = function
    [] -> true 
    | [x] -> true
    | x::rest -> if (x < List.hd rest) then true && nondec rest
                 else false;;

(*Parte 2c*)
let rec pairwith y = function 
    [] -> []
    | x::rest -> (y,x)::pairwith y rest;;

(*Parte 2d*)
let rec duplica = function 
    [] -> []
    | x::rest -> x::x::duplica rest;;

(*Parte 2e*)
let enumera list = 
    let rec count n = function 
        [] -> []
        | x::rest -> (n,x)::count (n+1) rest
in count 0 list;;
        
(*Parte 2f*)
exception ElementDoesNotExist;;

let position this list = 
    let rec find index = function
        [] -> raise ElementDoesNotExist
        | x::rest -> if (x=this) then index
                     else find (index+1) rest
in find 0 list;;

(*Parte 2g*)
let alternate list = 
    let rec count n = function 
        [] -> []
        | x::rest -> if ((n mod 2) != 0) then x::count (n-1) rest
                     else count (n-1) rest
in count 0 list;;

(*Parte 2h*)
exception EmptyList;;

let min_dei_max list = 
    let rec aux cur = function
        [] -> raise EmptyList
        |[x] -> maxlist x
        | x::rest -> let max_lista = maxlist x 
                     in if(max_lista<cur) then aux max_lista rest
                        else aux cur rest
in aux (maxlist (List.hd list)) (List.tl list);;
    
(*([[2;3;4] [1;2]]) -> [2;3;4] -> 4*)

(*Parte 2i*)
let rec take n = function 
    [] -> []
    |x::rest -> if (n=0) then []
                else x::take (n-1) rest;;

let split2 = function 
    [] -> ([],[])
    |x::rest as list -> let splitindex = (length list)/2 
                        in ((take splitindex list), drop splitindex list);;