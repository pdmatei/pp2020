

data Expr = I Integer | 
            Plus Expr Expr | 
            Mult Expr Expr

-- 4 + 3*2
e1 = (I 4) `Plus` ((I 3) `Mult` (I 2))

show_expr :: Expr -> String
show_expr (I i) = show i
show_expr (e `Plus` e') = (show_expr e) ++ " + " ++ (show_expr e')
show_expr (e `Mult` e') = (show_expr e) ++ " * " ++ (show_expr e')

instance Show Expr where
  show = show_expr

-- write this function as an exercise
eval_expr :: Expr -> Integer
eval_expr (I x) = x
eval_expr (e `Plus` e') = (eval_expr e) + (eval_expr e')
eval_expr (e `Mult` e') = (eval_expr e) * (eval_expr e')



{-
To represent formulae such as: (x && y) || ~(x || y)
we could use a datatype formula as shown below.

data Formula = And Formula Formula | Or Formula Formula | Not Formula

However, when we reach the basis case (the variable), we may spend a little time
to consider what a variable may be. It may be a boolean as in:

(0 && ~1) || ~0   , hence the formula may represent a bit operation

It may be a string, as in:
(x && ~y) || ~x   , hence the formula will represent a sat formula (which is true e.g. for x = 1 )

It may be a condition over integers, as in:
((5 == 2 + 3) && ~(3 > 2))  , hence the formula will represent a boolean combination over integers

With this in mind, we implement a polymophic datatype formula, where "atoms" can be "anything"
-}

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

-- (5 == 2 + 3) V ~(3 > 2)
-- (5 == 2 + 3) || ~(3 > 2)
cond :: Formula BVal
cond = (Atom ((I 5) `Eq` ((I 2) `Plus` (I 3)))) `Or` (Not (Atom ((I 3) `Gt` (I 2))))

data BVal = Eq Expr Expr | Gt Expr Expr 

{- How do we judge when a formula is true or false?
   For this, we need to assign, to each atom, a value.

   For instance, in b, each (Atom x) has boolean value x;
   In sat, we need to say which variable is true/false explicitly;
   In cond, we need to evaluate boolean conditions, using the code you have written

   In general, this assignment is modelled by a function with signature
   a -> Bool

   So, to evaluate a formula, we require such a function.
   Writing the evaluation signature yields a kind of folding operation we are performing
   on formulae:
-}


foldf :: (a -> Bool) -> Formula a -> Bool
foldf f (Atom x) = f x
foldf f (Or e e') = (foldf f e) || (foldf f e')
foldf f (And e e') = (foldf f e) && (foldf f e')
foldf f (Not e) = not (foldf f e)

eval_b :: Formula Bool -> Bool
eval_b = foldf (\x->x)

eval_sat :: (String -> Bool) -> Formula String -> Bool
eval_sat i = foldf i
sample_i "x" = False
sample_i "y" = True

eval_cond :: Formula BVal -> Bool
eval_cond = foldf op
              where op :: BVal -> Bool
                    op (e `Eq` e') = (eval_expr e) == (eval_expr e')
                    op (e `Gt` e') = (eval_expr e) > (eval_expr e')



