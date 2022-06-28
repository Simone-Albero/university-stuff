(*Parte 1a*)
exception ElementNotFund

let rec find p = function
    [] -> raise ElementNotFund
    |x::rest -> if p x then x
                else find p rest;;  
        
let find_applicata lst = find (function x -> (x*x)<30) lst;;

(*Parte 1b*)
let rec takewhile p = function 
    [] -> []
    |x::rest -> if p x then x::takewhile p rest
                else [];;

let takewhile_applicata lst = takewhile (function n -> n mod 2 = 0) lst;;

(*Parte 1c*)
let rec dropwhile p = function 
    [] -> []
    |x::rest as lst -> if p x then dropwhile p rest
                else lst;;

let dropwhile_applicata lst = dropwhile (function n -> n mod 2 = 0) lst;;

(*Parte 1d*)
let rec partition p = function 
    [] -> ([], [])
    |x::rest -> let (a, b) = partition p rest in 
                if p x then (x::a, b)
                else (a, x::b);;

let partition_applicata lst = partition (function n -> n mod 2 = 0) lst;;

(*Parte 1e*)
let pairwith this lst = List.map (function x -> (this, x)) lst;;

(*Parte 1f*)
(*sottoproblema: presa una lista verifica se tutti gli elementi sono minori di n*)
let tuttiminori n lst = List.for_all (function x -> x<n) lst;;

let rec verifica_matrice n lst =  List.exists (function x -> tuttiminori n x) lst;; 

(*Parte 1g*)
let setdiff l1 l2 = List.filter (function x -> not (List.mem x l2)) l1;;

(*Parte 1h*)
let subset l1 l2 = List.for_all (function x -> List.mem x l1) l2;;

(*Parte 1i*)
let duplica lst = List.map (function x -> 2*x) lst;;

(*Parte 1j*)
let mapcons lst x = List.map (function (a, b) -> (a, x::b)) lst;;

(*Parte 1k*)
(*sottoproblema: metti x in testa a tutte le liste*)
let lstcons this lst = List.map (function x -> this::x) lst;;

let tutte_liste_con n a b = 
    let rec aux = function
    0 -> [[]]
    | x -> lstcons a (aux (x-1)) @ lstcons b (aux (x-1))  
in aux n;;

(*Parte 1l*)
let cons x rest = x::rest

let rec interleave this = function 
    [] -> [[this]]
    |x::rest as lst -> (this::lst)::(List.map (cons x) (interleave this rest));;  

(*Parte 1m*)
(*nota: da sistemare*)
let rec permut = function
    [] -> [[]]
    |x::rest -> List.flatten (List.map (interleave x) (permut rest));;

(*parte 2*)
(*Labirinto: matrice quadrata rappresentata da una lista associativa*)
(*Rappresentazione: dimensione matrice, lista che associa una coppia di cordinate al suo contenuto se presente*)
let labirinto = (5, [((1,0),"oro"); ((3,1),"oro"); ((4,3),"oro");
                ((0,1),"argento"); ((2,4),"argento"); ((0,2),"mostro");
                ((1,1),"mostro"); ((1,3),"mostro"); ((2,3),"mostro");
                ((3,0),"mostro"); ((4,2),"mostro")]);;

(*parte 2a*)
let in_riga lab row value = List.exists (function (x, y) -> fst x = row && y = value) (snd lab);;

(*parte 2b*)
exception ElementNotFund;;

let trova_colonna lab row value = try snd (fst (List.find (function (x, y) ->  fst x = row && y = value) (snd lab))) with _ -> raise ElementNotFund;;

(*parte 2c*)
let rec in_tutte lab value = List.for_all (function x -> in_riga lab (fst(fst x)) value) (snd lab);;

(*Parte 3a*)
let rec find x  = function
    [] -> raise ElementNotFund
    |y::rest -> if y = x then ([], rest)
                else let (a, b) = find x rest in (y::a, b);;

(*Parte 3b*)
exception BadFormat;;

let spezza x lst = let (a, b) = find x lst in find x b;; 

(*Parte 4*)
let rec prendi p = function 
    [] -> raise ElementNotFund
    |x::rest -> if p x then (x, rest)
                else let (a, b) = prendi p rest in (a, x::b);;