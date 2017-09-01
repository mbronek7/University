-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko} gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module MichalBronikowski (typecheck, eval) where

-- Importujemy moduły z definicją języka oraz typami potrzebnymi w zadaniu
import AST
import DataTypes

--data A = Bl | It | Ut | Pairt A A | Listt A| deriving (Eq,Show)  -- MOJA PROBA PRZELOZENIA TEGO CO BYLO NA TABLICY NA PRACOWNI
data Error p = Erorr p String | Error1 String deriving (Eq,Show)

-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck fs vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
changeinput :: [Var] -> [(Var,Type)]
changeinput [] = []
changeinput (x:var) = ((x,TInt):changeinput var)

---
funtoenv :: [FunctionDef p] -> [(Var,Type)]
funtoenv [] = []
funtoenv (x:funs) = ((funcName x,TArrow (funcArgType x) (funcResType x)) :funtoenv funs)
---


lookfor1 :: [(Var,Type)] -> Var -> Either (Error p) Type
lookfor1 env x = case lookup x env of
  Just t -> Right t
  Nothing -> Left (Error1 ("Zmienna" ++ x ++ " nie zostala zdefiniowana"))

infer_type :: Eq p => [(Var,Type)] -> Expr p -> Either (Error p) Type

-- zmienne
infer_type env (EVar p var) =
  case lookfor1 env var of
    Right t -> Right t
    Left (Error1 a)-> Left (Error1 a)
--liczba
infer_type _(ENum _ _) = Right TInt
--bool
infer_type _(EBool _ _) = Right TBool
--unit
infer_type _(EUnit _) = Right TUnit
--wyrazenie unarne
infer_type  env (EUnary p uoperator e1) =
  case infer_type env e1 of
    Right TInt -> case uoperator of
      UNeg ->Right  TInt
      UNot ->Left  (Erorr (getData e1)("Nie mozesz uzywac operatora not z liczba calkowita"))
    Right TBool -> case uoperator of
      UNeg ->Left (Erorr (getData e1)("Wartosc boolowska nie moze byc uzyta z operatorem negacji liczb calkowitych"))
      UNot ->Right TBool
    Right _ ->Left (Erorr (getData e1)("Tylko wartosci calkowite i boolowskie moga byc uzyte z operatorem unarnym"))
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )
--wyrazenia binarne
infer_type env (EBinary p binoperator e1 e2) =
  let a = infer_type env e1
  in case a of
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )
    Right _ ->let b = infer_type env e2
      in case a == b of
        False -> Left (Erorr p ("Oba argumenty musza byc tego samego typu"))
        True -> case a of
          Right TInt -> case binoperator of
            BEq -> Right TBool
            BNeq -> Right TBool
            BMod -> Right TInt
            BAdd -> Right TInt
            BSub -> Right TInt
            BMul -> Right TInt
            BDiv -> Right TInt
            BGe -> Right TBool
            BLe -> Right TBool
            BGt ->Right  TBool
            BLt -> Right TBool
            _ -> Left (Erorr p ("Musisz uzyc operatora dla liczb calkowitych"))
          Right TBool -> case binoperator of
            BAnd -> Right TBool
            BOr ->Right TBool
            _-> Left (Erorr p ("Musisz uzyc operatora dla wartosci boolowskich"))
          Right _ -> Left (Erorr p ("Tylko wartosci calkowite i boolowskie moga byc uzyte z operatorem binarnym"))
--if
infer_type env (EIf p e0 e1 e2) =
  case infer_type env e0 of
    Right TBool -> let a = infer_type  env e1
       in let b = infer_type env e2
       in case a == b of
         True -> a
         False -> Left(Erorr p ("W konstrukcji IF musisz uzyc operacji tego samego typu"))
    Right _ ->Left(Erorr (getData e0) ("Warunek w konstrukcji IF musi byc typu boolowskiego"))
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )
--let
infer_type env (ELet p var e1 e2) =
  let e1type = infer_type  env e1
  in case e1type of
    Right TInt -> infer_type ((var,TInt):env) e2
    Right TBool -> infer_type ((var,TBool):env) e2
    Right TUnit -> infer_type ((var,TUnit):env) e2
    Right (TPair a b)-> infer_type ((var,TPair a b):env) e2
    Right (TList a) -> infer_type ((var,TList a):env) e2
    Right (TArrow a b) -> infer_type ((var,TArrow a b):env) e2
    Left (Erorr a b) -> Left( Erorr a b)
    Left (Error1 a ) -> Left( Error1 a )
--lista pusta
infer_type env (ENil p typ) =
  case typ of
    TList a -> Right typ
    _ ->Left (Erorr p ("Zly typ"))
--para
infer_type env (EPair p e1 e2) =
  let e1type = infer_type  env e1
      e2type = infer_type  env e2
    in case e1type of
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
      Right a -> case e2type of
        Left (Erorr a b) -> Left( Erorr a b)
        Left (Error1 a ) -> Left( Error1 a )
        Right  b -> Right (TPair  a  b)
--fst
infer_type  env (EFst p e1) =
    case infer_type  env e1 of
      Right (TPair a b)-> Right a
      Right _ -> Left (Erorr p ("Mozesz uzywac fst tylko z parami"))
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
--snd
infer_type env (ESnd p e1) =
    case infer_type env e1 of
      Right (TPair a b)-> Right  b
      Right _ -> Left (Erorr p ("Mozesz uzywac snd tylko z parami"))
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
--konstruktor listy niepustej
infer_type env (ECons p e1 e2) =
  case infer_type env e1 of
    Right a ->  case  infer_type env e2 of
        Right (TList e2type) ->case a == e2type of
                                  True ->  Right (TList a)
                                  False -> Left(Erorr p ("Parametry konstruktora list musza byc tego samego typu"))
        Right _ ->Left (Erorr p ("Zly typ podczas konstruowania listy"))
        Left (Erorr a b) -> Left( Erorr a b)
        Left (Error1 a ) -> Left( Error1 a )
    Left (Erorr a b) -> Left( Erorr a b)
    Left (Error1 a ) -> Left( Error1 a )
-----------
--aplikacja funkcji
-----------
infer_type env (EApp p e1 e2) = 
  case infer_type env e1 of
    Right (TArrow t1 t2) -> case infer_type env e2  of
      Right t -> if t == t1 then Right t2 else Left(Erorr p ("Zly typ parametru funkcji"))
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
    Right _ -> Left (Erorr p ("Blad nie prawidlowy typ dla aplikacji funkcji"))
    Left (Erorr a b) -> Left( Erorr a b)
    Left (Error1 a ) -> Left( Error1 a )

-----------
--aplikacja lambda-abstrakcji
-----------
infer_type env (EFn p var t e1) = 
  case infer_type ((var,t):env) e1 of
    Right t1 -> Right (TArrow t t1)
    Left (Erorr a b) -> Left( Erorr a b)
    Left (Error1 a ) -> Left( Error1 a )
-----------
-----------

--match
infer_type env (EMatchL p e1 n1 (x1,x2,e2)) =
  case infer_type env e1 of
    Right (TList a) -> let nilclausetype = infer_type  env n1
                           consClausetype = infer_type ((x1,a):(x2,TList a):env) e2 in
      case nilclausetype == consClausetype of
       True -> case  nilclausetype of
         Right a -> Right a
         Left (Erorr a b) -> Left( Erorr a b)
         Left (Error1 a ) -> Left( Error1 a )
       False -> Left (Erorr p ("Warunek dla listy pustej i zlozonej musi byc tego samego typu "))
    _ -> Left (Erorr p ("Mozesz uzywac matcha tylko z listami"))

-----------------------------------------------------
-- FUNKACJA DO SPRAWDZANIA ZADEKLAROWANYCH FUNKCJI --
-----------------------------------------------------
checkfun :: Eq p => [(Var ,Type)] -> [FunctionDef p] -> Either (Error p) Type
checkfun _ [] = Right TInt
checkfun env (x:xs) = case infer_type ((funcArg x,funcArgType x):env) (funcBody x) of
        Right value -> case value == funcResType x of
          True -> checkfun env xs
          False -> Left (Erorr (getData $ funcBody x) ("Zly typ funkcji"))
        Left _ -> Left (Erorr (getData $ funcBody x) ("Blad w definicji funkcji"))

-------------
-------------
typecheck :: Eq p => [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck fenv env expr = case (checkfun (funtoenv fenv) fenv) of
  Right TInt ->case (infer_type ((changeinput env) ++ (funtoenv fenv)) expr) of
      Right TInt -> Ok
      Left (Erorr a b) -> Error a b
      Left (Error1 a ) ->  Error (getData expr) a
      _ -> Error (getData expr) ("Zly typ wyrazenia")
  Left (Erorr a b) ->Error a b
  Left (Error1 a ) -> Error (getData expr) a
  _->Error (getData expr) ("Zly typ wyrazenia")
-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval fs input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że definicje funckcji fs oraz wyrażenie e są dobrze
-- typowane, tzn. typecheck fs (map fst input) e = Ok
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.

data B p = VBool Bool | VInt Integer | VPar (B p , B p) | VList [B p] | VUnit | VCl Var (Expr p) | VFn [(Var,B p)] Var (Expr p) deriving (Eq,Show)
data Error2 = Err deriving (Eq,Show)

changeinput2 :: [(Var,Integer)] -> [(Var,B p)]
changeinput2 [] =[]
changeinput2 ((x,val): env) = ((x, VInt val):changeinput2 env)
 ---
 ---
funtoenv2 :: [FunctionDef p] -> [(Var,B p)]
funtoenv2 [] = []
funtoenv2 (x:funs) = ((funcName x,VCl (funcArg x) (funcBody x) ):funtoenv2 funs)
 ---
 ---
lookfor2 :: [(Var,B p)] -> Var -> Either Error2  (B p)
lookfor2 env x = case lookup x env of
  Just val -> Right val
  Nothing -> Left Err

eval' ::[(Var,B p)] -> Expr p -> Either Error2  (B p)

--Zmienna
eval' env (EVar _ x)= lookfor2 env x
--Liczba
eval' _ (ENum _ x) = Right (VInt x)
--Bool
eval' _(EBool _ x) = Right (VBool x)
--Unit
eval' _ (EUnit _) = Right VUnit
--Wyrażenie Unarne
eval'  env (EUnary p unoperator expr) =
  case eval' env expr of
    Right (VInt x) -> Right (VInt (-x))
    Right (VBool x) -> Right (VBool (not x))
    Right _ -> Left Err
    Left Err-> Left Err
--Wyrazenie Binarne
eval' env (EBinary p binoperator e1 e2) =
  case eval' env e1 of
    Left Err -> Left Err
    Right (VInt x) -> case eval' env e2 of
      Left Err -> Left Err 
      Right (VInt x2) -> case binoperator of
        BEq -> Right  (VBool  (x == x2))
        BNeq -> Right (VBool (x /= x2))
        BLt -> Right  (VBool  (x < x2))
        BGt -> Right  (VBool  (x > x2))
        BLe -> Right  (VBool  (x <= x2))
        BGe -> Right  (VBool  (x >= x2))
        BAdd -> Right (VInt (x + x2))
        BSub -> Right (VInt (x - x2))
        BMul -> Right (VInt (x * x2))
        BDiv -> case x2 of
            0 -> Left Err 
            _ -> Right (VInt (x `div` x2))
        BMod -> case x2 of
            0 -> Left Err
            _ -> Right (VInt (x `mod` x2))
    Right (VBool b1) -> case eval' env e2 of
               Right (VBool b2)-> case binoperator of
                     BOr -> Right (VBool (b1 ||  b2))
                     BAnd -> Right (VBool ( b1 && b2))
               Left Err -> Left Err 
    Right _ -> Left Err 
--IF
eval' env (EIf p e0 e1 e2) =
  case eval' env e0 of
    Right (VBool True) -> eval'  env e1
    Right (VBool False) -> eval' env e2
    Left Err  ->   Left Err
--LET
eval' env (ELet p var e1 e2) =
  case eval' env e1 of
    Left Err -> Left Err
    Right (VInt x) -> eval'  ((var, VInt x):env) e2
    Right (VBool x) -> eval' ((var,VBool x):env) e2
    Right (VPar x) -> eval' ((var,VPar x):env) e2
    Right (VList x) -> eval' ((var,VList x):env) e2
    Right  VUnit  -> eval' ((var,VUnit):env) e2
    Right (VCl a b ) -> eval' ((var,VCl a b):env) e2
    Right (VFn fenv var2 body) -> eval' ((var,VFn fenv var2 body):env) e2
--pair
eval' env (EPair p e1 e2) =
  case eval' env e1 of
    Left Err -> Left Err
    Right value -> case eval' env e2 of
      Left Err -> Left Err 
      Right value2 -> Right(VPar (value,value2))
--fst
eval' env (EFst p e1) =
  case eval' env e1 of
    Right (VPar (a,b)) -> Right a
    Left Err -> Left Err
--snd
eval' env (ESnd p e1) =
  case eval' env e1 of
    Right (VPar (a,b)) -> Right b
    Left Err -> Left Err 
--EApp 
eval' env (EApp p e1 e2) = do
 cl <- eval' env e1
 t  <- eval' env e2
 case cl of
    (VCl var body) -> eval' ((var,t):env) body
    (VFn fenv var body) -> eval' ((var,t):fenv) body
    _ -> Left Err 
--EFn
eval' env (EFn p var t e1) = Right (VFn env var e1)

--ENil
eval' env (ENil p typ) =
  case typ of
  TList a -> Right (VList [])
--konstruktor listy niepustej
eval' env (ECons p e1 e2) =
  case eval' env e1 of
    Left Err-> Left Err
    Right value -> case eval' env e2 of
      Left Err  ->  Left Err 
      Right (VList value2) ->Right (VList(value:value2))
--match
eval' env (EMatchL p e1 n1 (x1,x2,e2)) =
  case eval' env e1 of
    Left Err -> Left Err
    Right (VList []) -> eval' env n1
    Right (VList (x:values)) ->
      let extEnvTmp = ((x2, VList values):env)
          extEnv = ((x1, x):extEnvTmp)
      in eval' extEnv e2

eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval fenv env expr =  case (eval' ((changeinput2 env) ++ (funtoenv2 fenv)) expr) of
     Right (VInt val) -> Value val
     _ -> RuntimeError
