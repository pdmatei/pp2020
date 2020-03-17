{-
data Tree = 
        Void |
        Node Tree Integer Tree
        deriving Show
-}

t = Node (Node (Node Void 1 Void) 2 (Node Void 4 Void)) 3 (Node Void 0 Void)

{-
    What are data constructors?
    ===========================
    Let us compare the ADT with the Haskell and Java implementations

    Node : Tree x Int x Tree -> Tree
    abstract (implementation/INDEPENDENT) representation of a nonempty tree


    Node is a data constructor.
    :t Node
    Node :: Tree -> Integer -> Tree -> Tree
    a function which returns a "tree object" whose actual implementation is concealed from the programmer
    (For this reason, often, ADTs in Haskell are called Algebraic not Abstract Datatypes)



    class Node implements Tree {
    private Tree l,r;
    private Integer k;

    ...

    }
    a "tree object" whose actual implementation must be provided by the programmer


    So what is the concealed implementation?
    You could imagine it is:

    typedef struct Node {
        Node* l;
        int k;
        Node* r;
    } Node;

-}

{- How to we introspect objects? (Look at their components?) Using Pattern matching !! 
   In Haskell, pattern matching can ONLY be done on DATA CONSTRUCTORS (like (:) and (,), or syntactic sugars for them)
-}
{-
size :: Tree -> Tree
size Void = 0
size (Node l k r) = 1 + (size l) + (size r)

flatten :: Tree -> [Integer]
flatten Void = []
flatten (Node l k r) = (flatten l)++(k:(flatten r))

mirror :: Tree -> Tree
mirror Void = Void
mirror (Node l k r) = Node (mirror r) k (mirror l)
-}

{-

    Implementing a POLIMORPHIC datatype
    ===================================

-}
data Tree a = Void |
              Node (Tree a) a (Tree a) -- public Node (Tree<E> l, E k, Tree<E> r)
              deriving Show

size :: Tree a -> Integer
size Void = 0
size (Node l k r) = 1 + (size l) + (size r)

flatten :: Tree a -> [a]
flatten Void = []
flatten (Node l k r) = (flatten l)++(k:(flatten r))

mirror :: Tree a -> Tree a
mirror Void = Void
mirror (Node l k r) = Node (mirror r) k (mirror l)

{- some tests 

:t Node Void [2] Void
:t Node Void [2::Integer] Void
:t Node Void (1,2) Void


:t Node (Node Void 2 Void) 'c' Void

-}


{-
    Adding a map operation to our tree
    ===================================

-}
tmap :: (a -> b) -> (Tree a) -> (Tree b)
tmap f Void = Void
tmap f (Node l v r) = Node (tmap f l) (f v) (tmap f r)

{-
   Adding a new operation for our type is very easy for an ADT.
   The operation, defined w.r.t. DATA CONSTRUCTORS is simply appended to existing code.
   Adding a new operation in OOP is cumbersome as each existing class has to be modified

   Adding a new DATA CONSTRUCTOR (e.g. node with two keys) is cumbersome in an ADT,
   as each existing operation has to be modified.

   Adding a new class in OOP is straightforward, as each operation can be specified
   in the class implementation.

            Add new operation           Add new constructor
      TDA        easy                          hard
      OOP        hard                          easy

-}

