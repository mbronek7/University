-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko} gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module Pracownia (typecheck, eval) where

-- Importujemy moduły z definicją języka oraz typami potrzebnymi w zadaniu
import AST
import DataTypes

-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
-- getdata
data Possible_Types  = Bt | It | Error1  deriving (Eq, Show)
data Blad p = Err p


changeinput :: [Var] -> [(Var,Possible_Types)]
changeinput [] = []
changeinput (x:var) = ((x,It):changeinput var)

member :: [(Var,Possible_Types)] -> Var -> Possible_Types
member env x = case lookup x env of
	Just t -> case t of
		It -> It
		Bt -> Bt
		Error1 -> Error1
	Nothing -> Error1



typecheck' :: Eq p => [(Var,Possible_Types)] -> Expr p -> Possible_Types

typecheck' vars (EVar p var) =
	case member vars var of
		It -> It
		Bt -> Bt
		Error1 -> Error1

typecheck' _ (ENum _ _) = It

typecheck' _ (EBool _ _) = Bt

typecheck' vars (EUnary p unop e1) =
	case typecheck' vars e1 of
		Bt -> case unop of
			UNot -> Bt
			UNeg -> Error1
		It -> case unop of
			UNeg -> It
			UNot -> Error1
    --Error1 -> Error1

typecheck' vars (EBinary p binop e1 e2) =
	let x = typecheck' vars e1
	in let y = typecheck' vars e2
	in case x == y of
			False -> Error1
			True -> case x of
				Bt -> case binop of
					BAnd -> Bt
					BOr -> Bt
					_ -> Error1

				It -> case binop of
					BEq -> Bt
					BNeq -> Bt
					BLt -> Bt
					BGt -> Bt
					BLe -> Bt
					BGe -> Bt
					BAdd -> It
					BSub -> It
					BMul -> It
					BDiv -> It
					BMod -> It
					_ -> Error1

--typecheck' vars (ELet p var e1 e2) =
	--case typecheck' (var:vars) e1 of
		--Error1 -> Error1
		--_ -> typecheck' (var:vars) e2

typecheck' vars (ELet p var e1 e2) =
			let e1Type = typecheck' vars e1
			in typecheck' ((var, e1Type):vars) e2

typecheck' vars (EIf p e0 e1 e2) =
	case typecheck' vars e0 of
		Bt -> let x = typecheck' vars e1
			in let y = typecheck' vars e2
			in case x == y of
				True -> x
				False -> Error1
		_ -> Error1



typecheck :: Eq p =>[Var] -> Expr p -> TypeCheckResult p
typecheck var expr = case  (typecheck' (changeinput var) expr) of
	--case (typecheck' var expr) of
		It -> Ok
		_ -> Error (getData expr) "123"

-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że wyrażenie e jest dobrze typowane, tzn.
-- typecheck (map fst input) e = Ok
-- UWAGA: to nie jest jeszcze rozwiązanie; należy zmienić jej definicję.
data Possible_Evaluations  = B Bool | I Integer | ZeroDivision  |Error3 String| Error2  deriving (Eq, Show)

member_value :: [(Var, Possible_Evaluations)] -> Var -> Possible_Evaluations

member_value env x = case lookup x env of
				         Just val -> case val of
									 B x -> B x
									 I x -> I x
									 _ -> Error3 ("Undefined variable" ++ x)
				         Nothing ->Error3  ("Undefined variable " ++ x)

changeinput2 :: [(Var,Integer)] -> [(Var,Possible_Evaluations)]
changeinput2 [] = []
changeinput2 ((x,val):var) = ((x,I val):changeinput2 var)

eval :: [(Var,Integer)] -> Expr p -> EvalResult
-- data EvalResult
--  Value Integer -- Poprawny wynik obliczeń
--  | RuntimeError  -- Błąd podczas wykonania programu (dzielenie prze zero)
--  deriving (Eq, Show)
-- eval env expr
eval vars expr =
	case (b_eval (changeinput2 vars) expr) of
		I val -> Value val
		_ -> RuntimeError

b_eval :: [(Var, Possible_Evaluations)] -> Expr p -> Possible_Evaluations

b_eval env (EVar _ var) = member_value env var
b_eval _ (ENum _ int) = I int
b_eval _ (EBool _ bool) = B bool
b_eval env (EUnary _ unop expr) =
    case b_eval env expr of
        ZeroDivision -> ZeroDivision
        I v -> I (- v)
        B v -> B (not v)

b_eval env (EBinary _ binop e1 e2) =
    case b_eval env e1 of
        ZeroDivision -> ZeroDivision
        I v1 -> case b_eval env e2 of
            ZeroDivision -> ZeroDivision
            I v2 -> case binop of

                BEq -> B (v1 == v2)
                BNeq -> B (v1 /= v2)
                BLt -> B (v1 < v2)
                BGt -> B (v1 > v2)
                BLe -> B (v1 <=v2)
                BGe -> B (v1 >= v2)

                BAdd -> I (v1 + v2)
                BSub -> I (v1 - v2)
                BMul -> I (v1 * v2)
                BDiv -> case v1 of
									0 -> ZeroDivision
									_ -> case v2 of
										0 -> ZeroDivision
										_ -> I (v1 `div` v2)
                BMod -> case v1 of
									0 -> ZeroDivision
									_ -> case v2 of
										0 -> ZeroDivision
										_ -> I (v1 `mod` v2)

        B p1 -> let B p2 = b_eval env e2
        		in case binop of
                	BAnd -> B (p1 && p2)
               		BOr -> B (p1 || p2)

b_eval env (ELet _ var e1 e2) =
    case b_eval env e1 of
        ZeroDivision -> ZeroDivision
        I v1 -> b_eval ((var, I v1):env) e2
        B v1 -> b_eval ((var, B v1):env) e2

b_eval env (EIf _ e0 e1 e2) =
    case b_eval env e0 of
        ZeroDivision -> ZeroDivision
        B True -> b_eval env e1
        B False -> b_eval env e2
