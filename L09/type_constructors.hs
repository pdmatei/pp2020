{-# LANGUAGE FlexibleInstances #-}

data List a = Nil | Cons a (List a)

data Tree a = Void | Node (Tree a) a (Tree a)

data Formula a = Atom a |
                 Or (Formula a) (Formula a) |
                 And (Formula a) (Formula a) |
                 Not (Formula a)

-- data Either a b = Left a | Right b

f :: [a] -> Either String a
f [] = Left "This list should not be empty!"
f (x:xs) = Right x


{-
    A few details regarding types and typing.

    Haskell's type system is called: System-F
        - it is a "polymorphic" type system (we can build polymorphic types, i.e.)
             TYPE VARIABLES can appear in types.

          AND

        - it is "strongly-polymorphic": i.e. variables are universally quantified.
        Example:
-}

pair = (g ['c'], g [2])
        where g (x:xs) = x

{-
   to understand just a glimpse from what is happening in System F, let us start
   by writing the type of g. 
   g :: [a] -> a
   
   more formally, it should be written:
   g :: forall a. [a] -> a

   to synthetise the type of the pair, System F proceeds as follows:

    - g :: forall a. [a] -> a  is called with parameter ['c'] :: [Char]
      hence g ['c'] :: Char (and a is `equal` to Char)
   
    - g :: forall a. [a] -> a  is called with parameter [2] :: [Integer]
      hence g [2] :: Integer (and a is `equal` to Integer)

   In effect, we have two 'monomorphic variants' of function g, at line 26
   in our program.

   Not all type-systems are strongly polimorphic. For instance, an older version of O'Caml,
   is weakly polimorphic. There, at line: 
   
   (g ['c'], g [2])
  
   the compiler/interepreter would produce an error: 
     cannot apply function g :: [a] -> a  with a = Char, on a list of integers
     in O'Caml type variables are not universally quantified, hence once a is bound
     in a context, it cannot be changed.



   TYPE CONSTRUCTION

   In Haskell, we have encountered:
     - primitive types:  Integer, Char, Bool
     - "composite" types, or TYPE EXPRESSIONS:  [Integer], [a], (Char,a), Tree a, Either a b
       some contain type variables, some don't.

     - ALL type expressions are built as "function applications". Hence,
       just as ((:) 1 []) is a function application creating the value [1]
               [] Integer is a function application creating the type [Integer]

      Who is the function? Here, [] should not be understood as the empty list.
      [] is a TYPE CONSTRUCTOR, i.e. a function which takes types as arguments, and
         returns new types.

      The type [Integer] is actually an abbreviation of ([] Integer)
      The type (Tree a) is built by passing 'a' as argument to the type constructor Tree
      The type (Either String Char) is built by passing String and Char to the
                                                                   type constructor Either

      Type constructors are functions over types, and Haskell cannot mistake them by
      functions over program values. However, the programmer might. For instance:
      (Tree 5) has no meaning, since Tree is a type constructor while 5 is a value.
      
      If type constructors are functions, then they may as well have types.
      This is actually true (we can use :k to test).
 
      The type of a type constructor is called "kind". For instance, the kind of [] is
      [] :: * -> *
      here * means "type" 
      The kind for Tree is:
      Tree :: * -> *

      while that for Either is:
      Either :: * -> * -> *

      what is the kind of (,) ?

      what is (->) ? What is it's kind?


      What is the kind of Type:
-}

data Type t a = Something | Value (t a)

{-
    Type :: (* -> *) -> * -> *


    Final class application:

    map :: (a -> b) -> [a] -> [b]

    tmap :: (a -> b) -> Tree a -> Tree b

    mapf :: (a -> b) -> Formula a -> Formula b

    
    Let us build a class which contains an abstract map function amap.


class Mapable ? where
  amap :: (a -> b) -> [a] -> [b]

the trick here is, how do we parameterise the class?

all implementations take an arbitrary function. Now we have a constraint:
   the second parameter is a "collection c of type a"
   the third  parameter is a "the same collection c of type b"
                
                  f 
         a ---------------> b
         |                  |
      c  |              c   |     
         |                  |
         V        amap      V
  collection of -------> collection of
    type a                 type b

 this diagram emphasizes that the parameter of the class is the
 "collection type", or the type constructor c :: * -> *

-}
class Mapable c where
  amap :: (a -> b) -> c a -> c b

instance Mapable List where
  amap f Nil = Nil
  amap f (Cons x xs) = Cons (f x) (amap f xs)

instance Mapable Tree where
  amap f Void = Void
  amap f (Node l k r) = Node (amap f l) (f k) (amap f r)

instance Mapable Formula where
  amap f (Atom a) = Atom (f a)
  amap f (Or e e') = Or (amap f e) (amap f e')
  amap f (And e e') = And (amap f e) (amap f e')
  amap f (Not e) = Not (amap f e)

{- Change Mapable to Functor, and amap with fmap, and you get the 
   Haskell default implementation.
   :t fmap


   Class Foldable works in the very same way:
   
class Foldable t where
  foldr :: (a -> b -> b) -> b -> t a -> b

with the enrollment below, we can make a tree foldable by the (right, key, left)
order of traversal.

   -}
instance Foldable Tree where
  foldr op acc Void = acc
  foldr op acc (Node l k r) = foldr op (k `op` (foldr op acc r)) l 

t = Node (Node (Node Void 1 Void) 2 (Node Void 3 Void)) 5 (Node Void 9 Void)


