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
--[[
--  _                                   _                     _
-- | |                                 | |                   | |
-- | |_   _   _   _ __     ___    ___  | |__     ___    ___  | | __
-- | __| | | | | | '_ \   / _ \  / __| | '_ \   / _ \  / __| | |/ /
-- | |_  | |_| | | |_) | |  __/ | (__  | | | | |  __/ | (__  |   <
--  \__|  \__, | | .__/   \___|  \___| |_| |_|  \___|  \___| |_|\_\
--         __/ | | |
--        |___/  |_|
--]]
-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.

data A = Bl | It deriving (Eq,Show)  -- MOJA PROBA PRZELOZENIA TEGO CO BYLO NA TABLICY NA PRACOWNI
data Error p = Erorr p String | Error1 String deriving (Eq,Show)

changeinput :: [Var] -> [(Var,A)]
changeinput [] = []
changeinput (x:var) = ((x,It):changeinput var)

lookfor1 :: [(Var,A)] -> Var -> Either (Error p) A
lookfor1 env x = case lookup x env of
  Just t -> case t of
    It -> Right It
    Bl -> Right Bl
  Nothing -> Left (Error1 ("var" ++ x ++ " is not in environment"))

infer_type :: Eq p => [(Var,A)] -> Expr p -> Either (Error p) A

infer_type env (EVar p var) =
  case lookfor1 env var of
    Right It -> Right It
    Right Bl -> Right Bl
    Left (Error1 a)-> Left (Error1 a)

infer_type _ (ENum _ _) = Right It
infer_type _ (EBool _ _) = Right Bl

infer_type env (EUnary p uoperator e1) =
  case infer_type env e1 of
    Right It -> case uoperator of
      UNeg ->Right  It
      UNot ->Left  (Erorr (getData e1)("The integer value cannot be used with unary operator not"))
    Right Bl -> case uoperator of
      UNeg ->Left (Erorr (getData e1)("The bool value cannot be used with unary minus"))
      UNot ->Right Bl
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )

infer_type env (EBinary p binoperator e1 e2) =
  let a = infer_type env e1
  in case a of
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )
    _ ->let b = infer_type env e2
      in case a == b of
        False -> Left (Erorr p ("Both of Binary operation arguments must be of the same type"))
        True -> case a of
          Right It -> case binoperator of
            BEq -> Right Bl
            BNeq -> Right Bl
            BMod -> Right It
            BAdd -> Right It
            BSub -> Right It
            BMul -> Right It
            BDiv -> Right It
            BGe -> Right Bl
            BLe -> Right Bl
            BGt ->Right  Bl
            BLt -> Right Bl
            _ -> Left (Erorr p (" The operator must be of int type operator"))
          Right Bl -> case binoperator of
            BAnd -> Right Bl
            BOr ->Right Bl
            _-> Left (Erorr p ("The operator must be a boolean operator"))

infer_type env (EIf p e0 e1 e2) =
  case infer_type env e0 of
    Right It ->Left(Erorr (getData e0) ("The condition of IF function must be of boolean type"))
    Right Bl -> let a = infer_type env e1
       in let b =infer_type env e2
       in case a == b of
         True ->a
         False ->Left(Erorr p ("Parametres after if condition must be of the same type"))
    Left (Erorr a b) ->Left( Erorr a b)
    Left (Error1 a ) ->Left( Error1 a )

infer_type env (ELet p var e1 e2) =
  let e1type = infer_type env e1
  in case e1type of
    Right It ->infer_type ((var,It):env) e2
    Right Bl ->infer_type ((var,Bl):env) e2
    Left (Erorr a b) ->Left( Erorr a b)

typecheck :: Eq p => [Var] -> Expr p -> TypeCheckResult p
typecheck env expr = case (infer_type (changeinput env) expr) of
  Right It -> Ok
  _ -> Error (getData expr) ("Incorrect type of expression")

  --[[
  --                         _
  --                        | |
  --   ___  __   __   __ _  | |
  --  / _ \ \ \ / /  / _` | | |
  -- |  __/  \ V /  | (_| | | |
  --  \___|   \_/    \__,_| |_|
  --
  --
  --]]
-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że wyrażenie e jest dobrze typowane, tzn.
-- typecheck (map fst input) e = Ok
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.

data B = BE Bool | IE Integer  deriving (Eq,Show)
data Error2 p = Err p String | Error2 String deriving (Eq,Show)

lookfor2 :: [(Var,B)] -> Var -> Either (Error2 p) B
lookfor2 env x = case lookup x env of
  Just val -> case val of
    BE x -> Right (BE x)
    IE x -> Right (IE x)
  Nothing -> Left (Error2 ("var" ++ x ++ "is undefined"))

changeinput2 :: [(Var,Integer)] -> [(Var,B)]
changeinput2 [] =[]
changeinput2 ((x,val): env) = ((x, IE val):changeinput2 env)


eval :: [(Var,Integer)] -> Expr p -> EvalResult
eval  env expr =
  case (eval' (changeinput2 env) expr) of
    Right (IE val) -> Value val
    _ -> RuntimeError

eval' :: [(Var,B)] -> Expr p -> Either (Error2 p) B

eval' env (EVar _ x)= lookfor2 env x
eval' _ (ENum _ x) = Right (IE x)
eval' _ (EBool _ x) = Right (BE x)

eval' env (EUnary p unoperator expr) =
  case eval' env expr of
    Right (IE x) -> Right (IE (-x))
    Right (BE x) -> Right (BE (not x))
    Left (Error2 a)-> Left (Error2 a)
    Left (Err a b)-> Left (Err a b)

eval' env (EBinary p binoperator e1 e2) =
  case eval' env e1 of
    Left (Error2 a) -> Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right (IE x) -> case eval' env e2 of
      Left (Error2 a) -> Left (Error2 a)
      Left (Err a b)-> Left (Err a b)
      Right (IE x2) -> case binoperator of
        BEq -> Right  (BE  (x == x2))
        BNeq -> Right (BE (x /= x2))
        BLt -> Right  (BE  (x < x2))
        BGt -> Right  (BE  (x > x2))
        BLe -> Right  (BE  (x <= x2))
        BGe -> Right  (BE  (x >= x2))
        BAdd -> Right (IE (x + x2))
        BSub -> Right (IE (x - x2))
        BMul -> Right (IE (x * x2))
        BDiv -> case x2 of
            0 -> Left (Err p ("You cannot divide by zero"))
            _ -> Right (IE (x `div` x2))
        BMod -> case x2 of
            0 -> Left (Err p ("You cannot use mod with zero"))
            _ -> Right (IE (x `mod` x2))
    Right (BE b1) -> case eval' env e2 of
               Right (BE b2)-> case binoperator of
                     BOr -> Right (BE (b1 ||  b2))
                     BAnd -> Right (BE ( b1 && b2))
               Left (Error2 a) -> Left (Error2 a)
               Left (Err a b)-> Left (Err a b)

eval' env (EIf p e0 e1 e2) =
  case eval' env e0 of
    Right (BE True) -> eval' env e1
    Right (BE False) -> eval' env e2
    Left (Err a b) ->   Left (Err a b)

eval' env (ELet p var e1 e2) =
  case eval' env e1 of
    Left (Error2 a) ->Left (Error2 a)
    Left (Err a b)-> Left (Err a b)
    Right (IE x) -> eval' ((var, IE x):env) e2
    Right (BE x) -> eval' ((var,BE x):env) e2
