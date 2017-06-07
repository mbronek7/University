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

funtoenv :: [FunctionDef p] -> [(FSym ,FunctionDef p)]
funtoenv [] = []
funtoenv (x:funs) = ((funcName x,x):funtoenv funs)

lookforfunctions :: FSym -> [(FSym ,FunctionDef p)] -> Either (Error p) (FunctionDef p)
lookforfunctions x fenv  = case lookup x fenv of
  Just t -> Right t
  Nothing ->Left (Error1 ("Funkcja" ++ x ++ " nie zostala zdefiniowana"))

lookfor1 :: [(Var,Type)] -> Var -> Either (Error p) Type
lookfor1 env x = case lookup x env of
  Just t -> Right t
  Nothing -> Left (Error1 ("Zmienna" ++ x ++ " nie zostala zdefiniowana"))

infer_type :: Eq p => [(FSym ,FunctionDef p)] -> [(Var,Type)] -> Expr p -> Either (Error p) Type

-- zmienne
infer_type fenv env (EVar p var) =
  case lookfor1 env var of
    Right t -> Right t
    Left (Error1 a)-> Left (Error1 a)
--liczba
infer_type _ _(ENum _ _) = Right TInt
--bool
infer_type _ _(EBool _ _) = Right TBool
--unit
infer_type _ _(EUnit _) = Right TUnit
--wyrazenie unarne
infer_type fenv env (EUnary p uoperator e1) =
  case infer_type fenv env e1 of
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
infer_type fenv env (EBinary p binoperator e1 e2) =
  let a = infer_type fenv env e1
  in case a of
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )
    Right _ ->let b = infer_type fenv env e2
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
infer_type fenv env (EIf p e0 e1 e2) =
  case infer_type fenv env e0 of
    Right TBool -> let a = infer_type fenv env e1
       in let b = infer_type fenv env e2
       in case a == b of
         True -> a
         False -> Left(Erorr p ("W konstrukcji IF musisz uzyc operacji tego samego typu"))
    Right _ ->Left(Erorr (getData e0) ("Warunek w konstrukcji IF musi byc typu boolowskiego"))
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )
--let
infer_type fenv env (ELet p var e1 e2) =
  let e1type = infer_type fenv env e1
  in case e1type of
    Right TInt -> infer_type fenv ((var,TInt):env) e2
    Right TBool -> infer_type fenv ((var,TBool):env) e2
    Right TUnit -> infer_type fenv ((var,TUnit):env) e2
    Right (TPair a b)-> infer_type fenv ((var,TPair a b):env) e2
    Right (TList a) -> infer_type fenv ((var,TList a):env) e2
    Left (Erorr a b) -> Left( Erorr a b)
    Left (Error1 a ) -> Left( Error1 a )
--lista pusta
infer_type fenv env (ENil p typ) =
  case typ of
    TList a -> Right typ
    _ ->Left (Erorr p ("Zly typ"))
--para
infer_type fenv env (EPair p e1 e2) =
  let e1type = infer_type fenv env e1
      e2type = infer_type fenv env e2
    in case e1type of
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
      Right a -> case e2type of
        Left (Erorr a b) -> Left( Erorr a b)
        Left (Error1 a ) -> Left( Error1 a )
        Right  b -> Right (TPair  a  b)
--fst
infer_type fenv env (EFst p e1) =
    case infer_type fenv env e1 of
      Right (TPair a b)-> Right a
      Right _ -> Left (Erorr p ("Mozesz uzywac fst tylko z parami"))
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
--snd
infer_type fenv env (ESnd p e1) =
    case infer_type fenv env e1 of
      Right (TPair a b)-> Right  b
      Right _ -> Left (Erorr p ("Mozesz uzywac snd tylko z parami"))
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
--konstruktor listy niepustej
infer_type fenv env (ECons p e1 e2) =
  case infer_type fenv env e1 of
    Right a ->  case  infer_type fenv env e2 of
        Right (TList e2type) ->case a == e2type of
                                  True ->  Right (TList a)
                                  False -> Left(Erorr p ("Parametry konstruktora list musza byc tego samego typu"))
        Right _ ->Left (Erorr p ("Zly typ podczas konstruowania listy"))
        Left (Erorr a b) -> Left( Erorr a b)
        Left (Error1 a ) -> Left( Error1 a )
    Left (Erorr a b) -> Left( Erorr a b)
    Left (Error1 a ) -> Left( Error1 a )
--aplikacja funkcji
infer_type fenv env (EApp p name e1) =
  case lookforfunctions name fenv of
    Right value -> case infer_type fenv env e1 of
      Right e1type -> case (funcArgType value) == e1type of
        True  -> Right (funcResType value)
        False -> Left (Erorr p ("Zly typ parametru funkcji"))
      Left (Erorr a b) -> Left( Erorr a b)
      Left (Error1 a ) -> Left( Error1 a )
    Left (Error1 a ) -> Left( Error1 a )
--match
infer_type fenv env (EMatchL p e1 n1 (x1,x2,e2)) =
  case infer_type fenv env e1 of
    Right (TList a) -> let nilclausetype = infer_type fenv env n1
                           consClausetype = infer_type fenv ((x1,a):(x2,TList a):env) e2 in
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
checkfun :: Eq p =>[(FSym ,FunctionDef p)] -> [FunctionDef p] -> Either (Error p) Type
checkfun _ [] = Right TInt
checkfun  fenv (x:xs) = case infer_type fenv [(funcArg x,funcArgType x)] (funcBody x) of
        Right value -> case value == funcResType x of
          True -> checkfun fenv xs
          False -> Left (Erorr (getData $ funcBody x) ("Zly typ funkcji"))
        Left _ -> Left (Erorr (getData $ funcBody x) ("Blad w definicji funkcji"))
-------------
typecheck :: Eq p => [FunctionDef p] -> [Var] -> Expr p -> TypeCheckResult p
typecheck fenv env expr = case (checkfun (funtoenv fenv)fenv) of
  Right TInt ->case (infer_type (funtoenv fenv )(changeinput env) expr) of
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

data B = VBool Bool | VInt Integer | VPar (B , B) | VList [B] | VUnit   deriving (Eq,Show)
data Error2 p = Err p String | Error2 String deriving (Eq,Show)

changeinput2 :: [(Var,Integer)] -> [(Var,B)]
changeinput2 [] =[]
changeinput2 ((x,val): env) = ((x, VInt val):changeinput2 env)

lookfor2 :: [(Var,B)] -> Var -> Either (Error2 p) B
lookfor2 env x = case lookup x env of
  Just val -> Right val
  Nothing -> Left (Error2 ("Zmienna" ++ x ++ "jest nie zdefiniowana"))

eval' :: [(FSym ,FunctionDef p)] -> [(Var,B)] -> Expr p -> Either (Error2 p) B

--Zmienna
eval' fenv env (EVar _ x)= lookfor2 env x
--Liczba
eval' _ _ (ENum _ x) = Right (VInt x)
--Bool
eval' _ _(EBool _ x) = Right (VBool x)
--Unit
eval' _ _ (EUnit _) = Right VUnit
--Wyrażenie Unarne
eval' fenv env (EUnary p unoperator expr) =
  case eval' fenv env expr of
    Right (VInt x) -> Right (VInt (-x))
    Right (VBool x) -> Right (VBool (not x))
    Right _ -> Left (Err p ("Blad w wurazeniu unarnym"))
    Left (Error2 a)-> Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
--Wyrazenie Binarne
eval' fenv env (EBinary p binoperator e1 e2) =
  case eval' fenv env e1 of
    Left (Error2 a) -> Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right (VInt x) -> case eval' fenv env e2 of
      Left (Error2 a) -> Left (Error2 a)
      Left (Err a b)-> Left (Err a b)
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
            0 -> Left (Err p ("Nie mozesz dzielic przez zero"))
            _ -> Right (VInt (x `div` x2))
        BMod -> case x2 of
            0 -> Left (Err p ("Nie mozesz uzywac modulo z zerem"))
            _ -> Right (VInt (x `mod` x2))
    Right (VBool b1) -> case eval' fenv env e2 of
               Right (VBool b2)-> case binoperator of
                     BOr -> Right (VBool (b1 ||  b2))
                     BAnd -> Right (VBool ( b1 && b2))
               Left (Error2 a) -> Left (Error2 a)
               Left (Err a b)-> Left (Err a b)
    Right _ -> Left (Err p ("Blad w wyrazeniu binarnym"))
--IF
eval' fenv env (EIf p e0 e1 e2) =
  case eval' fenv env e0 of
    Right (VBool True) -> eval' fenv env e1
    Right (VBool False) -> eval' fenv env e2
    Left (Err a b) ->   Left (Err a b)
    Left (Error2 a) ->Left (Error2 a)
--LET
eval' fenv env (ELet p var e1 e2) =
  case eval' fenv env e1 of
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right (VInt x) -> eval' fenv ((var, VInt x):env) e2
    Right (VBool x) -> eval' fenv ((var,VBool x):env) e2
    Right (VPar x) -> eval' fenv ((var,VPar x):env) e2
    Right (VList x) -> eval' fenv ((var,VList x):env) e2
    Right  VUnit  -> eval' fenv ((var,VUnit):env) e2
--pair
eval' fenv env (EPair p e1 e2) =
  case eval' fenv env e1 of
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right value -> case eval' fenv env e2 of
      Left (Error2 a) ->Left (Error2 a)
      Left (Err a b)-> Left (Err a b)
      Right value2 -> Right(VPar (value,value2))
--fst
eval' fenv env (EFst p e1) =
  case eval' fenv env e1 of
    Right (VPar (a,b)) -> Right a
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
--snd
eval' fenv env (ESnd p e1) =
  case eval' fenv env e1 of
    Right (VPar (a,b)) -> Right b
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
--EApp
eval' fenv env (EApp p name e1) =
  case eval' fenv env e1 of
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right value -> let Right x = lookforfunctions name fenv in
      eval' fenv ((funcArg x,value):env) (funcBody x)
--ENil
eval' fenv env (ENil p typ) =
  case typ of
  TList a -> Right (VList [])
--konstruktor listy niepustej
eval' fenv env (ECons p e1 e2) =
  case eval' fenv env e1 of
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right value -> case eval' fenv env e2 of
      Left (Error2 a) -> Left (Error2 a)
      Left (Err a b) ->  Left (Err a b)
      Right (VList value2) ->Right (VList(value:value2))
--match
eval' fenv env (EMatchL p e1 n1 (x1,x2,e2)) =
  case eval' fenv env e1 of
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right (VList []) -> eval' fenv env n1
    Right (VList (x:values)) ->
      let extEnvTmp = ((x2, VList values):env)
          extEnv = ((x1, x):extEnvTmp)
      in eval' fenv extEnv e2

eval :: [FunctionDef p] -> [(Var,Integer)] -> Expr p -> EvalResult
eval fenv env expr =  case (eval' (funtoenv fenv)(changeinput2 env) expr) of
    Right (VInt val) -> Value val
    _ -> RuntimeError
