(*Febraio 2021 N1*)
(*Ricorsiva*)
let rec filquad_r lst quad = match lst with 
    [] -> []
    |x::rest -> if List.mem (x*x) quad 
                then x::filquad_r rest quad
                else filquad_r rest quad;;

(*Con la Filter*)
(*fun: int -> bool *)
(*fun = true se x*x è contenuto in quad, false altrimenti*)

let filquad_f lst quad = List.filter (function x -> List.mem (x*x) quad) lst;;

(*Iterativa*)
(*aux result lst = (List.rev [elementi di lst il cui quadrato è presente in quad]) @ [] *)

let filquad_i lst quad =
    let rec aux result = function
        [] -> result
        |x::rest -> if List.mem (x*x) quad 
                    then aux (x::result) rest
                    else aux result rest
    in aux [] lst;;

(*Settembre 2021 N1*)
(*Ricorsiva*)
let rec apply_r asslst = function
    [] -> []
    |x::rest -> try let res = List.assoc x asslst 
                    in res::apply_r asslst rest
                with _ -> x::apply_r asslst rest;;

(*con la Map*)
(*convert (a' * a')list -> a' -> a' *)
(*convert = valore b' associato alla chiave x, x altrimenti *)
let convert lst x = try List.assoc x lst  
                    with _ -> x;;

let rec apply_m asslst elle = List.map (convert asslst) elle;;

(*Settembre 2020 N1*)
(*Ricorsiva*)
let rec remove_r x = function 
    [] -> []
    | y::rest -> if y = x 
                 then remove_r x rest
                 else y::remove_r x rest;;

(*Iterativa*)
(*aux: a' list -> a' list -> a' list *)
(*aux [] lst = [] @ [lista in cui vengono eliminate tutte le occorreze di x] *)
let remove_i x lst =
    let rec aux result = function
        [] -> List.rev result 
        |y::rest -> if y = x 
                    then aux result rest
                    else aux (y::result) rest
    in aux [] lst;;

(*Febbraio 2019 N1*)
type color = Rosso | Verde | Neutro;;

let chose x cols = try List.assoc x cols 
                   with _ -> Neutro;;

let rec conta_colori cols = function
    [] -> [(Rosso, 0); (Verde, 0); (Neutro, 0)]
    |x::rest -> let [(Rosso, a); (Verde, b); (Neutro, c)] = conta_colori cols rest 
                in match chose x cols with
                Rosso -> [(Rosso, a+1); (Verde, b); (Neutro, c)]
                | Verde -> [(Rosso, a); (Verde, b+1); (Neutro, c)]
                | Neutro -> [(Rosso, a); (Verde, b); (Neutro, c+1)];;

(*Settembre 2019 N1*)
exception BadFormat;;

(*ricerca: a' -> a' list -> a' list *)
(*ricerca x lst = se x appartiene a list restituisce list senza la prima occorrenza di x, lancia BadFormat altrimenti *)
let rec ricerca x = function 
    [] -> raise BadFormat
    |y::rest -> if y = x 
                then rest
                else y::ricerca x rest;;

let rec complemento super = function 
    [] -> super
    |x::rest -> complemento (ricerca x super) rest;;

(*Febbraio 2014 N1*)
let rec catch this = function
    [] -> []
    |x::rest -> if x >= this 
                then x::catch x rest
                else catch this rest;;

let rec ordinati start = function
    [] -> []
    |x::rest -> if x >= start
                then x::(catch x rest)
                else ordinati start rest;;

(*Luglio 2014 N2*)

let rec listform this = function   
    [] -> raise BadFormat
    |x::rest as lst -> if x=this 
                then lst
                else listform this rest;;

(*Settembre 2015 N1*)
let purge this lst = List.filter (function x -> not (List.exists (function y -> y=this) x)) lst;;