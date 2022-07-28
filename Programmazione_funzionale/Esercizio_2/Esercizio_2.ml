(*Parte 1*)
(*Funzione ultima_cifra: int->int*)
(*riporta il valore intero dell'ultima cifra di un intero*)
let ultima_cifra x = (abs x) mod 10;;

(*Funzione penultima_cifra: int->int*)
(*riporta il valore intero della penultima cifra di un intero*)
let penultima_cifra x = (((abs x) mod 100) - ultima_cifra x)/10;; 

(*Funzione ultime_cifre: int->int*int *)
(*riporta il valore intero delle due ultime cifre di un intero*)
let ultime_cifre x = (penultima_cifra x, ultima_cifra x);;

let out = ultime_cifre 1987;;

(*Parte 2*)
(*Funzione cifra_bella: int->bool*)
(*riporta true se l'intero e' (0,3 o 7), false altrimenti*)
let cifra_bella x = 
    if x=0 || x=3 || x=7 then true
    else false;;

(*Funzione numero_bello: int->bool*)
(*riporta true se l'ultima cifra dell'intero e' bella e la penultima no, false altrimenti*)
let numero_bello x = 
    if penultima_cifra x = 0 then cifra_bella x
    else 
        if cifra_bella(ultima_cifra x) && not(cifra_bella(penultima_cifra x)) then true
        else false;;

let out = numero_bello 3;;
let out = numero_bello 33;;
let out = numero_bello 17;;

(*Parte 3*)
(*Funzione data: int * string -> bool*)
(*riporta true se la data e' corretta, false altrimenti*)
let data (g,m) = 
    match m with
    "gennaio"|"marzo"|"maggio"|"luglio"|"agosto"|"ottobre"|"dicembre"->  g>0 && g<=31
    |"febbraio" -> g>0 && g<=28
    |"aprile" |"giugno"|"settembre"|"novembre" -> g>0 && g<=30
    | _ -> false;;

let out = data (29,"settembre");;
let out = data (30,"febbrazio");;