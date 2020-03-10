
{-

  Reminder (referential transparency)
           (side effects) 


We started from:
  int f (int[] v){
   int sum = 0;
   int n = v.length;
   for (int i=0; i<n; i++)
      sum+=v[i];
   return sum;
  }

And written:

f v = fp 0 v 
        where fp sum v
                  | v == [] = sum
                  | otherwise = fp (sum + (head v)) (tail v)


------------------------------
Part 2:   Pattern matching
------------------------------

Our 'sum' function is still not quite `functionally-written` w.r.t. Haskell.

f v = fp 0 v 
        where fp acc [] = acc
              fp acc (x:xs) = fp (acc + x) xs

Haskell is strongly-typed (will be later discussed), and it's type-system relies on ADTs
(users can define their own ADTs - discussed later). 

Consider the following function:

f v 
  | v == [] = False
  | otherwise = g (tail v) 
                    where g vp 
                            | vp == [] = False
                            | otherwise = True 

which returns True iff v has at least two elements, can be rewritten as:

f [] = False
f (x:xs) = g xs
            where 
              g [] = False
              g (x:xs) = True

However, we can also write more complex patterns and simplify the above implementation:

f [] = False
f (x:[]) = False
f (x:y:xs) = True
  
Patterns are read and interpreted in the order of their definition (unlike axioms in an ADT),
hence, we can equally write:

f (x:y:xs) = True
f _ = False

or simply:

f (_:_:_) = True
f _ = False

How about:
f [] = 0
f (x:xs) = 1
f (x:y:xs) = 2

What is the return value of f [1,2] ?

the third pattern will never be reached as the second one is more general (the interpreter usually
signals this)

Patterns can be used liberally in function definitions. For instance, what does the following functions do:

f [] = []
f ([x]:y) = (f y)++[x]

it helps if we think about its type:
f :: [a] -> [b]  it appears that our function takes a list and returns a list
but the pattern [x]:y suggests that elements of type a of the list must be lists themselves:
a = [c]. Hence: f :: [[c]] -> [b]. But since the list [x] is prepended to (f y), then b = c,
hence:  f :: [[c]] -> [c]

g [] = []
g ([x]:y) = x:(g y)

same type, the order in which elements are introduced is different.

More pattern examples:

f (x,y) = x ++ y
f :: ([a], [a]) -> [a]

f (x:y,z)
  | y == z = x + 1
  | otherwise = x
f :: ([Integer],[Integer]) -> Integer

f ([(x,y)]:xs) = x ++ y ++ (f xs)
f :: [[([a],[a])]] -> [a]


------------------------------------
Part 3:   Higher-order functions
------------------------------------

sum [] = 0
sum (x:xs) = x + (sum xs)

prod [] = 1
prod (x:xs) = x * (prod xs)

The only difference between the two is the operator, and the initial value.

fold op acc [] = acc
fold op acc (x:xs) = op x (fold op acc xs)

1 `op` (2 `op` (3 `op` acc))

We may be tempted to say that:
fold :: (a->a->a) -> a -> [a] -> a

however, the accumulator need not have the same type as the elements of the list.

Consider:

fold (:) l2 l1

suppose l2 = [4,5,6] and l1 = [1,2,3]

fold (:) [4,5,6] [1,2,3] = 1:(fold [4,5,6] [2,3]) = 1:2:(fold [4,5,6] [3]) = 
  1:2:3:(fold [4,5,6] []) = 1:2:3:[4,5,6] = [1,2,3,4,5,6]


Hence: l1 ++ l2 = fold (:) l2 l1

and:

fold :: (a->b->a) -> b -> [a] -> a

This is the implementation of foldr (right) from haskell.


Now, consider a tail-end implementation of fold:

fold op acc [] = acc
fold op acc (x:xs) = fold op (op acc x) xs

Let us test it:
fold op acc [1,2,3] = fold op (op acc 1) [2,3] = fold op (op (op acc 1) 2) [3] 
  = fold op (op (op (op acc 1) 2) 3) [] = (((acc `op` 1) `op` 2) `op` 3)

Contrast this to:
                                           1 `op` (2 `op` (3 `op` acc))

As long as op is symmetric (x `op` y = y `op` x), there is no difference.
However, most interesting operators are not.

Consider
flipcons x y = y:x

and foldl flipcons [] l = reverse l

foldr and foldl are called "reducers" because they take a list and reduce it to a value
(which may be another list as previously seen)

we also have transformers: operations which take lists of "something" and build lists
of "something else". For instance:

[1,2,3] -> [2,3,4]

[1,2,3] -> [2,4,6]

"01000110" -> "10111001"

[[3,1,2],[4], [6,5]] -> [[2,1,3], [4], [5,6]]

[(1,2),(3,4),(5,6)] -> [[1,2], [3,4], [5,6]]

[[1,2], [3], [], [5,6]] -> [False, False, True, False]


a transformer works as follows:

map f [] = []
map f (x:xs) = (f x):(map f xs)


e.g.
bitflip '0' = '1'
bitflip '1' = '0'

map bitflip l = ...

Another way to combine lists (or collections in general) is by merging two lists into one.
For instance:

[1,2,3] [4,5,6] -> [5,7,9]
[1,2,3] [[11,111],[22,222],[33,333]] -> [[1,11,111],[2,22,222],[3,33,333]]

["Matei", "Mihai"] ["Popovici", "Dumitru"] -> ["Matei Popovici", "Mihai Dumitru"]

this can be done using zipWith:

zipWith op _ [] = []
zipWith op [] _ = []
zipWith op (x:xs) (y:ys) = (x `op` y):(zipWith op xs ys)

zipWith (+)
zipWith (:)
zipWith (++)

Finally, we have filter:

filter p (x:xs)
  | p x = x:(filter p xs)
  | otherwise = filter p xs

However, note that filter is actually a particular type of folding operation:

filter p l = foldr op [] l
      where op x xs
              | p x = x:xs
              | otherwise = xs

Write map as a folding operation.

Combining foldr, foldl, map, filter and zipWith provides with a very powerful programming
model. For instance, we can parse a string: "1 2 3\n4 5 6\n7 8 9\n" into a list of lists
representing a matrix: [[1,2,3],[4,5,6],[7,8,9]] as follows.

The key to the implementation is separating a string after a char separator.
split :: Char -> String -> [String]

this is a folding operation:
split sep str = foldr op [[]] str
                  where op x (y:ys)
                      | x == sep = []:y
                      | otherwise = (x:y):ys


example   'd' op ["an","popovici"]
          'i' op ["","dan","popovici"] 
          ' ' op ["dan","popovici"]


To build the matrix we proceed in two steps:

parse s = map splitLine (split '\n' s)
            where splitLine l = split ' ' l

Finally, to convert each string to integer, we use the auxiliary function

toInt s = (read s)::Integer

parse s = map splitLine (split '\n' s)
            where splitLine l = map toInt (split ' ' l)

We can assemble everything into:

parse s = map splitLine (split '\n' s)
            where splitLine l = map toInt (split ' ' l)
                  toInt s = (read s)::Integer
                  split sep str = foldr op [[]] str
                  op x (y:ys)
                      | x == sep = []:y
                      | otherwise = (x:y):ys

-}            



