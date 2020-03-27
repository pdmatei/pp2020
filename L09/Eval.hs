{-# LANGUAGE FlexibleInstances #-}

{- Recall from the previous lecture: -}
data Expr = I Integer | 
            Plus Expr Expr | 
            Mult Expr Expr

eval_expr :: Expr -> Integer
eval_expr (I x) = x
eval_expr (e `Plus` e') = (eval_expr e) + (eval_expr e')
eval_expr (e `Mult` e') = (eval_expr e) * (eval_expr e')

data Formula a = Atom a |
                 Or (Formula a) (Formula a) |
                 And (Formula a) (Formula a) |
                 Not (Formula a)

-- 0 ^ ~1
b :: Formula Bool
b = (Atom True) `And` (Not (Atom False))

-- (x ^ y) V (~x)
sat :: Formula String
sat = ((Atom "x") `And` (Not (Atom "y"))) `Or` (Not (Atom "x"))

data BVal = Eq Expr Expr |   -- arithmetic expression == arithmetic expression
            Gt Expr Expr     -- arithmetic expression > arithmetic expression

-- (5 == 2 + 3) || ~(3 > 2)
cond :: Formula BVal
cond = (Atom ((I 5) `Eq` ((I 2) `Plus` (I 3)))) `Or` (Not (Atom ((I 3) `Gt` (I 2))))


{- suppose in our program we are working with different types of formulae.
   if a formula is Formula Bool, we must remember to call function eval_b
   if a formula is of type Formula BVal, we must remember to call eval_cond
-}

evalf :: (a -> Bool) -> Formula a -> Bool
evalf f (Atom x) = f x
evalf f (Or e e') = (evalf f e) || (evalf f e')
evalf f (And e e') = (evalf f e) && (evalf f e')
evalf f (Not e) = not (evalf f e)

eval_b :: Formula Bool -> Bool
eval_b = evalf (\x->x)

eval_sat :: Formula String -> Bool
eval_sat = evalf f 
              where f "x" = False
                    f "y" = True

eval_cond :: Formula BVal -> Bool
eval_cond = evalf op
              where op :: BVal -> Bool
                    op (e `Eq` e') = (eval_expr e) == (eval_expr e')
                    op (e `Gt` e') = (eval_expr e) > (eval_expr e')

{- This code can be better structured, if we use typeclasses:
-}

class Eval a where
  eval :: Formula a -> Bool
  eval (Or e e') = (eval e) || (eval e')
  eval (And e e') = (eval e) && (eval e')
  eval (Not e) = not (eval e)
  eval (Atom x) = evalAtom x
  evalAtom :: a -> Bool

instance Eval Bool where
  evalAtom = \x -> x

instance Eval String where
  evalAtom "x" = True
  evalAtom "y" = False

instance Eval BVal where
  evalAtom (e `Eq` e') = (eval_expr e) == (eval_expr e')
  evalAtom (e `Gt` e') = (eval_expr e) > (eval_expr e')


{- Each instance tells us how each type should be evaluated to a boolean.
   Moreover, we can provide with the entire implementation of eval in the class
   Eval, which relies on evalAtom.

   This implementation is much cleaner, has fewer function names, and uses
   the typeclass constraint:

   eval :: Eval a => Formula a -> Bool

   which states that a "Formula a" can be evaluated to true/false iff
   a type "a" can be evaluated to true/false. 
-}
