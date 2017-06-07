-- Wymagamy, by moduł zawierał tylko bezpieczne funkcje
{-# LANGUAGE Safe #-}
-- Definiujemy moduł zawierający rozwiązanie.
-- Należy zmienić nazwę modułu na {Imie}{Nazwisko} gdzie za {Imie}
-- i {Nazwisko} należy podstawić odpowiednio swoje imię i nazwisko
-- zaczynające się wielką literą oraz bez znaków diakrytycznych.
module Eval (typecheck, eval) where

-- Importujemy moduły z definicją języka oraz typami potrzebnymi w zadaniu
import AST
import DataTypes

data Type = TInt | TBool deriving Eq
data Val  = VNum Integer | VBool Bool
type Error p = (p, ErrKind)
data ErrKind = EUndefinedVariable Var | ETypeMismatch Type Type | EIfMismatch Type Type
type Env a = [(Var, a)]

instance Show Type where
  show TInt  = "int"
  show TBool = "bool"

instance Show ErrKind where
  show (EUndefinedVariable x) =
    "Undefined variable " ++ show x ++ "."
  show (ETypeMismatch t1 t2)  =
    "Type mismatch: expected " ++ show t1 ++ " but received " ++ show t2 ++ "."
  show (EIfMismatch t1 t2)    =
    "Type mismatch in the branches of an if: " ++ show t1 ++ " and " ++ show t2 ++ "."

infixr 6 $>

($>) :: Maybe a -> Either a b -> Either a b
Just e  $> _ = Left e
Nothing $> e = e

inferType :: Env Type -> Expr p -> Either (Error p) Type
inferType γ (EVar p x) =
  case lookup x γ of
    Just t  -> Right t
    Nothing -> Left (p, EUndefinedVariable x)
inferType γ (ENum _ _)  = Right TInt
inferType γ (EBool _ _) = Right TBool
inferType γ (EUnary _ op e) =
  checkType γ e ta $>
  Right tr
  where (ta, tr) = uopType op
inferType γ (EBinary _ op e1 e2) =
  checkType γ e1 et1 $>
  checkType γ e2 et2 $>
  Right tr
  where (et1, et2, tr) = bopType op
inferType γ (ELet _ x ex eb) =
  case inferType γ ex of
    Left err -> Left err
    Right tx -> inferType ((x, tx) : γ) eb
inferType γ (EIf p ec et ef) =
  checkType γ ec TBool $>
  checkEqual p (inferType γ et) (inferType γ ef)
  where
    checkEqual _ (Left err) _ = Left err
    checkEqual _ _ (Left err) = Left err
    checkEqual p (Right t1) (Right t2) =
      if t1 == t2 then Right t1
      else Left (p, EIfMismatch t1 t2)

checkType :: Env Type -> Expr p -> Type -> Maybe (Error p)
checkType γ e t =
  case inferType γ e of
    Left err -> Just err
    Right t' -> if t == t' then Nothing else Just (getData e, ETypeMismatch t' t)

uopType :: UnaryOperator -> (Type, Type)
uopType UNot = (TBool, TBool)
uopType UNeg = (TInt,  TInt)

bopType e = case e of
  BAnd -> tbool
  BOr  -> tbool
  BEq  -> tcomp
  BNeq -> tcomp
  BLt  -> tcomp
  BLe  -> tcomp
  BGt  -> tcomp
  BGe  -> tcomp
  BAdd -> tarit
  BSub -> tarit
  BMul -> tarit
  BDiv -> tarit
  BMod -> tarit
  where tbool = (TBool, TBool, TBool)
        tcomp = (TInt,  TInt,  TBool)
        tarit = (TInt,  TInt,  TInt)

-- Funkcja sprawdzająca typy
-- Dla wywołania typecheck vars e zakładamy, że zmienne występujące
-- w vars są już zdefiniowane i mają typ int, i oczekujemy by wyrażenia e
-- miało typ int
typecheck :: [Var] -> Expr p -> TypeCheckResult p
typecheck vs e =
  case checkType γ e TInt of
    Nothing  -> Ok
    Just (p, err) -> Error p $ show err
  where γ = map (\ x -> (x, TInt)) vs

ev :: Env Val -> Expr p -> Maybe Val
ev σ (EVar _ x)  = lookup x σ
ev σ (ENum _ n)  = Just $ VNum n
ev σ (EBool _ b) = Just $ VBool b
ev σ (EUnary _ op e) =
  case ev σ e of
    Just v -> evUOp op v
    Nothing -> Nothing
ev σ (EBinary _ op e1 e2) =
  case (ev σ e1, ev σ e2) of
    (Just v1, Just v2) -> evBOp op v1 v2
    _ -> Nothing
ev σ (ELet _ x ex eb) =
  case ev σ ex of
    Just v -> ev ((x, v) : σ) eb
    Nothing -> Nothing
ev σ (EIf _ ec et ef) =
  case ev σ ec of
    Just (VBool True)  -> ev σ et
    Just (VBool False) -> ev σ ef
    _ -> Nothing

evUOp UNot (VBool b) = Just . VBool $ not b
evUOp UNeg (VNum n)  = Just . VNum $ -n

evBOp BAnd (VBool b1) (VBool b2) = Just . VBool $ b1 && b2
evBOp BOr  (VBool b1) (VBool b2) = Just . VBool $ b1 || b2
evBOp BEq  (VNum n1)  (VNum n2)  = Just . VBool $ n1 == n2
evBOp BNeq (VNum n1)  (VNum n2)  = Just . VBool $ n1 /= n2
evBOp BLt  (VNum n1)  (VNum n2)  = Just . VBool $ n1 <  n2
evBOp BLe  (VNum n1)  (VNum n2)  = Just . VBool $ n1 <= n2
evBOp BGt  (VNum n1)  (VNum n2)  = Just . VBool $ n1 >  n2
evBOp BGe  (VNum n1)  (VNum n2)  = Just . VBool $ n1 >= n2
evBOp BAdd (VNum n1)  (VNum n2)  = Just . VNum  $ n1 + n2
evBOp BSub (VNum n1)  (VNum n2)  = Just . VNum  $ n1 - n2
evBOp BMul (VNum n1)  (VNum n2)  = Just . VNum  $ n1 * n2
evBOp BDiv (VNum n1)  (VNum n2)
  | n2 == 0   = Nothing
  | otherwise = Just . VNum  $ n1 `div` n2
evBOp BMod (VNum n1)  (VNum n2)
  | n2 == 0   = Nothing
  | otherwise = Just . VNum  $ n1 `mod` n2

-- Funkcja obliczająca wyrażenia
-- Dla wywołania eval input e przyjmujemy, że dla każdej pary (x, v)
-- znajdującej się w input, wartość zmiennej x wynosi v.
-- Możemy założyć, że wyrażenie e jest dobrze typowane, tzn.
-- typecheck (map fst input) e = Ok
eval :: [(Var,Integer)] -> Expr p -> EvalResult
eval args e =
  case ev σ e of
    Just (VNum n) -> Value n
    Just _        -> undefined -- impossible (tc)
    Nothing       -> RuntimeError
  where σ = map (\(x, n) -> (x, VNum n)) args
