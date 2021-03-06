-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający testy.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko}Tests gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module MichalBronikowskiTests(tests) where

-- Importujemy moduł zawierający typy danych potrzebne w zadaniu
import DataTypes

-- Lista testów do zadania
-- Należy uzupełnić jej definicję swoimi testami
tests :: [Test]
tests =
  [ Test "inc"               (SrcString "input x in x + 1") (Eval [42] (Value 43))
  , Test "undefVar"          (SrcString "x")                TypeError
  , Test "addTrue"           (SrcString "input x in x + true") TypeError
  , Test "addTrue"           (SrcString "input x in x + true") TypeError
  , Test "addition"          (SrcString "input x y in x + y") (Eval [2,5] (Value 7))
  , Test "substraction"      (SrcString "input x y in x - y") (Eval [2,5] (Value (-3)))
  , Test "addition2"         (SrcString "input x y in y + x") (Eval [10,3] (Value 13))
  , Test "substraction2"     (SrcString "input x y in y - x") (Eval [10,7] (Value (-3)))
  , Test "times"             (SrcString "input x y in x * y") (Eval [3,3] (Value 9))
  , Test "div"               (SrcString "input x y in x div y") (Eval [10,9] (Value 1))
  , Test "addandtimes"       (SrcString "input x y z in x + y * z") (Eval [3,9,12] (Value 111))
  , Test "wrongtimes"        (SrcString "input x y z t in x * y - true") TypeError
  , Test "iftest1"           (SrcString "input x y in if x < y then y else x div 2") (Eval [5,8] (Value 8))
  , Test "iftest2"           (SrcString "input x y in if x < y then y else x div 2") (Eval [8,5] (Value 4))
  , Test "lettest1"          (SrcString "input x y in if x < y then 5 else let y = x in y + y") (Eval [2,5] (Value 5))
  , Test "lettest2"          (SrcString "input x y z in if z > 10 then let x = 3 in z + x + y else 5") (Eval [3,5,2] (Value 5))
  , Test "runtimeerrtest"  (SrcString "input x in if x < 8 then x + 3 else x div 0") (Eval [25] (RuntimeError))
  , Test "runtimeerrtest2" (SrcString "input x in if x < 8 then x + 3 else x mod 0") (Eval [25] (RuntimeError))
  , Test "onlytrue"          (SrcString "true") TypeError
  , Test "parentheses1"      (SrcString "input x y in x + (x - y) - y + (y + (x - y))") (Eval [4,5] (Value 2))
  , Test "parentheses2"      (SrcString "input x y in x div 10 + y mod (20 + y) - 8 - (y div x)") (Eval [20,25] (Value 18))
  , Test "lettest3"          (SrcString "input x y t in if x > 5 then let x = y < 10 in if x then t else y else t") (Eval [5,7,8] (Value 8))
  , Test "lettest4"          (SrcString "input x y t in if x > 5 then let x = y < 10 in if x then t else y else y") (Eval [6,7,8] (Value 8))
  , Test "lettest5"          (SrcString "let x = false in x mod 42") TypeError
  , Test "commentin"         (SrcString "input(* dfgfdsgdsfgfdsgd *) x (* blablablabla *) in x * x (* *)") (Eval [99999] (Value (9999800001)))
  , Test "simpletest"        (SrcString "589 + 789 - 368") (Eval [] (Value 1010))
  , Test "simpletest2"       (SrcString "589 mod 20") (Eval [] (Value 9))
  , Test "simpletest3"       (SrcString "let x = 5892 in x mod 20") (Eval [] (Value 12))
  , Test "simpletest4"       (SrcString "if 486 <> 1684135684 then 42 else 2134326") (Eval [] (Value 42))
  , Test "simpletest5"       (SrcString "input x in -x") (Eval [486] (Value (-486)))
  , Test "simpletest6"       (SrcString "input x in if x <= false then true else 42") TypeError
  , Test "simpletest7"       (SrcString "input x y in if x then y * x else 0") TypeError
  , Test "lootsofvar"        (SrcString "input x y z t v a b c d in if x < d then a * b + y - (c * (v * x)) else a - (d * (t * (v * x) ))")(Eval [10,7,23,12,5,23,12,3,1] (Value (-577)))
 -----------------------------------------------------
 -----------------------------------------------------
 -----------------------------------------------------
 ---- KONIEC TESTOW Z 4 PRACOWNI ---------------------
 , Test "testno01"           (SrcString "fun testsfun(x : int * (int * int)) : (int * int) * int = ( (fst x, fst(snd x)), snd(snd x)) input a b c in snd(testsfun((a,(b,c))))") (Eval [1,2,3] (Value 3))
 , Test "testno03"           (SrcString "input a b c in fst (a,b) + c") (Eval [1,2,3] (Value 4))
 , Test "testno04"           (SrcString "input a b in let x = (a + b) in x + fst (b,a)") (Eval [1,2] (Value 5))
 , Test "testno05"           (SrcString "input a b c in c div snd (a,b)") (Eval [1,0,3] (RuntimeError))
 , Test "testno06"           (SrcString "input a b c in c mod snd (a,b)") (Eval [1,0,3] (RuntimeError))
 , Test "testno07"           (SrcString "fun divide(x : int * int) : int = fst x div snd x in divide((2,0))") (Eval [] (RuntimeError))
 , Test "testno08"           (SrcString "fun modi(x : int * int) : int = fst x mod snd x in modi((2,0))") (Eval [] (RuntimeError))
 , Test "testno09"           (SrcString "fun loop(u : unit) : int = loop() input a b c d in if fst (a,b) > c then b else b mod d + loop()") (Eval [1,2,3,0] (RuntimeError))
 , Test "testno10"           (SrcString "input a b c in if snd (b,true) then c else a") (Eval [1,2,3] (Value 3))
 , Test "testno11"           (SrcString "let x = (2,false) in x mod 42") TypeError
 , Test "testno12"           (SrcString "let x = (2,3) in if fst (true,false) <> snd x then 2 else 4") TypeError
 , Test "testno13"           (SrcString "fun f1 (u : unit) : int = 5 input a in a + f1(3)") TypeError
 , Test "testno14"           (SrcString "let x = [1,2,3] : int list in match x with | [] -> 0 | x :: xs -> x") (Eval [] (Value 1))
 , Test "testno15"           (SrcString "fun length (x : int list) : int = match x with | [] -> 0 | x :: xs -> length xs + 1 in length([1,2,3,4,5] : int list)") (Eval [] (Value 5))
 , Test "testno16"           (SrcString "fun headorzero(x: int list) : int = match x with | [] -> 0 | x::xs -> x in headorzero([1,2,3,4,5,6,7,8,9] : int list)")(Eval [] (Value 1))
 , Test "testno17"           (SrcString "fun divide(x : int * int) : int = fst x div snd x fun headorzero(x: int list) : int = match x with | [] -> 0 | x::xs -> x in let x = (3,headorzero([]:int list)) in divide(x)") (Eval [] (RuntimeError))
 , Test "testno17"           (SrcString "fun divide(x : int * int) : int = fst x div snd x fun headorzero(x: int list) : int = match x with | [] -> 0 | x::xs -> x in let x = (3,headorzero([]:bool)) in divide(x)") TypeError
 , Test "testno18"           (SrcString "fun add(x : int list) : int = match x with [] -> 0 | x::xs -> x + add(xs) in add([1,2,3,4] : int list)") (Eval [] (Value 10))
 , Test "testno19"           (SrcString "fun iflist(x : int list): int = match x with [] -> 0 | x::xs -> if x > 4 then iflist xs else x in iflist([1,2,3,4,5,6,7,8,9] : int list)") (Eval [] (Value 1))
 , Test "testno19"           (SrcString "fun iflist(x : int list): int = match x with [] -> 0 | x::xs -> if x > 4 then iflist(xs) else x in iflist( [5,6,7,8,9,2] : int list)") (Eval [] (Value 2))
 , Test "testno20"           (SrcString "fun stupidfun(x : bool * (bool * int)) : int = snd (snd x) in stupidfun((true,(false,4)))") (Eval [] (Value 4))
 , Test "testno21"           (SrcString "fun stupidfun(x : int * (bool * int)) : int = if fst(snd x) then fst x else snd(snd x) in stupidfun((1234,(false,3)))")(Eval [] (Value 3))
 , Test "testno21"           (SrcString "fun stupidfun(x : bool * (bool * int)) : int = if fst(snd x) then fst x else snd(snd x) in stupidfun((true,(true,3)))") TypeError
 , Test "testno22"           (SrcString "fun fib(n:int):int = if n<= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval[23] (Value 28657))
 , Test "testno23"           (SrcString "fun headorzero(x: int list) : int = match x with | [] -> 0 | x::xs -> x  fun stupidfun(x : int list * (bool * int)) : int = if fst(snd x) then headorzero(fst x) else snd(snd x) in stupidfun(([9,2,3,4,5,6] : int list,(true,4))) ") (Eval [] (Value 9))
 , Test "testno24"           (SrcString "fun f4(u : unit) : int = 4 in f4()") (Eval [] (Value 4))
 , Test "testno25"           (SrcString "fun f2(x : int * int) : int  = 8 in f2((234,true))") TypeError
 , Test "testno26"           (SrcString "fun f2(x : int * int) : int  = 8 in let x =(true,false) in f2(x)") TypeError
 , Test "testno27"           (SrcString "fun f3(x : unit * (int * bool)) : int = 45 in f3(((),(3,false)))") (Eval [] (Value 45))
 , Test "testno28"           (SrcString "fun f4(x: int): int = 42 in f4()") TypeError
 , Test "testno29"           (SrcString "let x = (false,(true,(42,38))) in snd(snd(snd x))")(Eval [] (Value 38))
 , Test "testno30"           (SrcString "fun stupidfun(x : unit list ) : int = match x with | [] -> 0 | x :: xs -> 42 in stupidfun([(),(),(),()] : unit list)") (Eval [] (Value 42))
 ---Konrad Werbliński 
 ,Test "Another Brick In The Wall" (SrcString "fun const(x:int) : int = 2  input x in if const x then 1 else 0")  TypeError,
	Test "Hey You" (SrcString "fun const(x:int) : int = false  input x in if const x then 1 else 0")  TypeError,
	Test "Mother" (SrcString "fun f(x:bool) : int = if x then 1 else 0  input x in f x") TypeError,
	Test "Young Lust" (SrcString "fun f(x:bool) : int = if x then 1 else false  input x in f (x > 0)") TypeError,
	Test "Comfortably Numb" (SrcString "fst (true, false) + 1") TypeError, 
	Test "In The Flesh" (SrcString "snd (1, 2) + true ") TypeError, 
	Test "One Slip" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [true, false] : bool list") TypeError,
	Test "Terminal Frost" (SrcString "fun f(x : int ) : bool = x > 2 input x in snd (f x, f (x - 2))") TypeError,
	Test "High Hopes" (SrcString "fun fib(n : int) : bool = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") TypeError,
	Test "Marooned"  (SrcString  "fun f (n : bool) : int list = [1,2,3] : int list  input x  in f (x > 5)") TypeError,
	Test "Wearing The Inside Out" (SrcString "fun p (n : int) : int * int = (n, n) input n in p n") TypeError,
	Test "Echoes"  (SrcString "fst (1, 2)") (Eval [] (Value 1)),
	Test "Wish You Were Here"  (SrcString "snd (1, 2)") (Eval [] (Value 2)),
	Test "Shine On You Crazy Diamond" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [0] (Value 0)),
	Test "Time" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [1] (Value 1)),
	Test "Money" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [2] (Value 1)),
	Test "Us And Them" (SrcString "fun fib(n : int) : int = if n <= 1 then n else fib(n-1) + fib(n-2) input n in fib(n)") (Eval [19] (Value 4181)),
	Test "Lost For Words" (SrcString "fun p (n : int) : int * int = (n, n) input n in fst (p n)") (Eval [1] (Value 1)),
	Test "Breathe (In The Air)" (SrcString "fun p (n : int) : int * int = (n, n) input n in snd (p n)") (Eval [42] (Value 42)),
	Test "Cluster One" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [2, x] : int list") (Eval [42] (Value 2)),
	Test "One Of These Days" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [4, 2] : int list") (Eval [42] (Value 4)),
	Test "Dogs" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [x , x, x] : int list") (Eval [42] (Value 42)),
	Test "Sheep" (SrcString "fun head(l : int list) : int = match l with  [] -> 0 | x :: xs -> x input x in head [] : int list") (Eval [42] (Value 0))
 ]
