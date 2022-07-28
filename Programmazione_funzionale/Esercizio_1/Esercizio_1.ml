(*Parte 1*)
let pi = 3.14159;;
let area x = pi *. x;;
let pi = 0.0;;
let x = "pippo";;
(*Mi aspetto che 'a' sia: 9,42477*)
let a = area 3.0;;

(*Parte 2*)
let y = 100;;
let x = 5;;
let h x = y+x;;
let y = 0;;
(*Mi aspetto che 'out' sia: 107*)
let out = h 7;;

(*Parte 3*)
(*Mi aspetto che il tipo dell'espressione sia: char->bool*)
let punct x = x = '.' || x = ',' || x = ';';;

(*Parte 4*)
(*Mi aspetto che il tipo dell'espressione sia: X1* x X2* x X3* x X4* -> X* *)
let pi1 (x1,x2,x3,x4) = x1;;
let pi2 (x1,x2,x3,x4) = x2;;
let pi3 (x1,x2,x3,x4) = x3;;
let pi4 (x1,x2,x3,x4) = x4;;

let q = (1,2,3,4);;
pi1 q;;
pi2 q;;
pi3 q;;
pi4 q;;

let quadrupla = (5,('c',"antonio",(),if 3>4 then 0 else 1),"pippo",true);;
(*Mi aspetto che 'out' sia: ()*)
let out = pi3 (pi2 quadrupla);;

(*Mi aspetto che 'out' sia: 1*)
let out = pi4 (pi2 quadrupla);;

(*Parte 5*)
(*if E then true else false*)
let out x = x;;
let a = out true;;

(*if E then false else true*)
let out x = not x;;
let a = out true;;

(*if E then F else false*)
let out (x,y) = x&&y;;
let a = out (true,false);;

(*if E then F else true*)
let out (x,y) = x&&y || not x&&y || not x&&not y;;
let a = out (false,false);;

(*if E then true else F*)
let out (x,y) = x||y;;
let a = out (true,false);;

(*if E then false else F*)
let out (x,y) = not x&&y;;
let a = out (false,true);;