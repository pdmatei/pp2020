{-# LANGUAGE FlexibleInstances #-}
{-

  Poly-morphism
  multiple-shapes - forms.

  In OOP, the most widespread form of polymorphism is ad-hoc polymorphism, or "method overriding".
                                                      -------------------
  In short, this type of polymorphism states that:
     - one method with the same signature can have DIFFERENT implementations in different clases


  
  Another form of polymorphism is parametric polymorphism. Here, a method has a single implementation
                                  ------------------------                             
  for a "collection"/"family" of types.

  Examples:
    - size :: [a] -> Integer
      size [] = 0
      size (x:xs) = x + (size xs)
      
      the same implementation works for a family of types, like [Integer], [Char], [(a,b)] etc.
  
    - foldr, foldr, map are all parametrically polymorphic.


  another example: 

    eval :: (a -> Bool) -> Formula a -> Bool
    eval f (Atom x) = f x
    eval f (Or e e') = (eval f e) || (eval f e')
    eval f (And e e') = (eval f e) && (eval f e')
    eval f (Not e) = not (eval f e)


    mirror :: Tree a -> Tree a
    mirror Void = Void
    mirror (Node l k r) = Node (mirror r) k (mirror l)


    - boolean operators are evaluated in the same way, no matter what an atomic formula looks like

   Ad-hoc polymorphism      - one "form" <-> several implementations
   Parametric polymorphism  - one "form" <-> one implementation


                                  Haskell               OOP
   Ad-hoc polymorphism             ??                   method overriding
   Parametric polymorphism        native                genericity


  How do we achieve ad-hoc polymorphism in Haskell?
  Example.

-}
data Tree = Void | Node Tree Integer Tree -- deriving Show

{- What exactly is Show? Show is not a function, not a type, but a type-class. 
   Type-classes are very similar to interfaces. Example:
 -}

class MShow a where
  mshow :: a -> String

{-
   MShow is the name of the class. 'a' is the class parameter a type variable. 
   
   "class MShow a" should be read as "MShow is a collection of types, henceforth
    designated as 'a' ".
   show :: a -> String is a function signature. It states that any member of class MShow
   should support, and provide with an implementation of the method show.

   a possible analogy is:
   interface MShow <A> {
      public String show (A a);
   }

   We can enroll a particular type in a type-class as follows:
-}

instance Show Tree where
  show Void = "{}"
  show (Node l k r) = "{"++(show l)++","++(show k)++","++(show r)++"}"

{-
  now, note that above we are combining two implementations:
  show :: Tree -> String (on (show l) and (show r))
  and
  show :: Integer -> String (which is defined in Haskell)

  Note that we have two different implementations, however a single function-name.
-}

t1 = Node (Node Void 1 Void) 3 (Node Void 2 Void)


{- 
   Another type of polymorphism - type polymorphism.
-}
data PTree a = PVoid | PNode (PTree a) a (PTree a)

--instance Show (PTree a) where
instance (Show a) => Show (PTree a) where
  show PVoid = "{}"
  show (PNode l k r) = "{"++(show l)++","++(show k)++","++(show r)++"}"

{-
   in this implementation, we are using:
   show :: (PTree a) -> String

   and 
   show :: a -> String

   suppose we define:
-}  
data MP = M | P

{- as-is, this type is not showable. Now, suppose we define
tt :: PTree MP
tt = Node PVoid M PVoid

since we cannot show values of type MP, we cannot also show trees of MP.
hence, we need to add a type restriction:

Here, (Show a) => Show (PTree a) means that:
- it is allowed to enroll the type (PTree a) in class Show,
  only if a is enrolled in class Show.

Thus, in Haskell, => is used to defined class restrictions.
We have seen it so often:

show :: Show a => a -> String

means that types a MUST be enrolled in class Show.
similarly, 

:t (+) :: Num a => a -> a -> a

means that (+) is supported over values of type a, provided that a is enrolled in class Num,
which defines specific arithmetic operations.

While classes are an important Haskell topic, we shall not pursue it in too much detail
as it is outside the scope of this lecture.

Some of the main classes in Haskell are:
(I) Show, Num, Eq, Fractional
Foldable, Functor

The first category is the focus of this lecture.
The second, of the future lecture.

=====================================

  When should we create new classes?

=====================================

We provide with an example:

In the last lecture, we discussed a type called formula,
which is polymorphic, in the sense that atoms can be anything,
and formulae are boolean combinations (~, &&, ||) over such things.

-}

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

instance Eq Tree where
  Void == Void = True
  (Node l k r) == (Node l' k' r') = (l == l') && (k == k') && (r == r')
  _ == _ = False

instance Eq a => Eq (PTree a) where
  PVoid == PVoid = True
  (PNode l k r) == (PNode l' k' r') = (l == l') && (k == k') && (r == r')
  _ == _ = False
