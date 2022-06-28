(*Parte 1*)
exception BadFormat;;
exception BadOperand;;
exception EmptySequence;;


let somma_ore (x1,x2) (y1,y2) = 
    if x1<0 || x1>23 || y1<0 || y1>23 || x2<0 || x2>59 || y2<0 || y2>59 then raise BadFormat
        else if x2+y2>59 then (((x1+y1)mod 24)+1, (x2+y2)mod 60)
            else ((x1+y1)mod 24, x2+y2);;

(*Parte 2a*) 
let read_max () = 
    let rec loop out = 
        let curr = read_line () 
        in if (curr = "") then out 
                else loop (max out (int_of_string curr))
    in try loop (read_int ())
        with _ -> raise EmptySequence;;

(*Parte 2b*)
let read_max_min () = 
    let rec loop nmax nmin = 
        try let curr = read_int ()
            in loop (max curr nmax)(min curr nmin)
        with _ -> (nmax,nmin)
    in try let init = read_int () in loop init init
    with _ -> raise EmptySequence;;

(*Parte 2c*)
let tutti_minori n =
    let rec loop out = 
        try let curr = read_int ()
            in loop (curr < n && out)
        with _ -> out
    in try let init = read_int () in loop (init<n)
        with _ -> raise EmptySequence;;

(*Parte 2d*)
let occorre n = 
    let rec loop out =
        try let curr = read_int ()
            in  loop (curr = n || out)
        with _ -> out
    in try let init = read_int () in loop (init = n)
    with _ -> raise EmptySequence;;

(*Parte 2e*)
let num_di_stringhe () = 
    let rec loop out = 
        match read_line() with 
        "" -> out
        | _ -> loop (out+1)
    in loop 0;; 
      

(*Parte 2f*)
let stringa_max () =
    let rec loop out =
        let curr = read_line ()
        in if curr = "" then out  
            else if (String.length curr)>(String.length out) then loop curr
                else loop out
    in loop (read_line ());; 

(*Parte 3a*)
let rec sumbetween x y =  
    if x >= y then 0
    else (x+y)+sumbetween (x+1) (y-1);;

(*Parte 3b*)
let sumto x = sumbetween 0 x;;

(*Parte 3c*)
let rec power n k = 
    if k = 0 then 1
    else n * power n (k-1);;

(*Parte 3d*)
let rec fib n =
    if n = 0 then 0
        else if n = 1 then 1 + fib (n-1)
            else fib (n-1) + fib (n-2);;

(*Parte 3e*)
let maxstring s =
    let rec loop out i = 
        if i >= String.length s then out
            else if s.[i] > out then loop s.[i] (i+1)
                else loop out (i+1)
    in try let init = s.[0] in loop init 1
        with _ -> raise BadOperand;;