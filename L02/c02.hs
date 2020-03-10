{-
   Expressions:
   int x = 1;



   No side-effects!

-}
x :: Int
x = 1 + 2
y = x + 1

{-
  Functions are as their mathematical counterparts:
-}
f :: Integer -> Integer -> Integer
f x y = x + y

{-
  (f a b) is always equal to (f a b) for any value a :: Integer and b :: Integer
-}

{-
  How do we compute sum without side-effects?

  int f (int[] v){
   int sum = 0;
   int n = v.length;
   for (int i=0; i<n; i++)
      sum+=v[i];
   return sum;
  }

f :: [Integer] -> Integer
f v = fp 0 (length v) 0
        where fp sum n i = if i < n then fp (sum + (v !! i)) n (i+1) else sum 

let us use guards instead:
f v = fp 0 (length v) 0
        where fp sum n i
            | i < n = fp (sum + (v !! i)) n (i+1)
            | otherwise sum 

this implementation is not really functional, but it is a direct translation to
of the above code. Why is it not functional:
   - whenever we want to traverse a sequence of numbers, we use Linked Lists, not arrays 
     (arrays are supported and we will look at examples later)
   - we introspect the list using head and tail, and do not use traversal indices:

f v = fp 0 v 
        where fp sum v
                  | v == [] = sum
                  | otherwise = fp (sum + (head v)) (tail v)

Now, the standard lab implementation for sum looked like this:

f v 
  | v == [] = 0
  | otherwise = (head v) + (f (tail v))

The two functions behave the same, but are not the same in terms of efficiency;

Consider how the stack of calls looks for each example:

f [1,2,3] =            f [1,2,3] =
  fp 0 [1,2,3]            1 + f [2,3]
  fp 1 [2,3]              1 + (2 + f [3])    <- the stack aways for two additions
  fp 3 [3]                1 + (2 + (3 + f [])) 
  fp 6 []                 1 + (2 + (3 + 0))
  6                       6

Aparently, this is the same thing, but now consider:

fibo 0 = 0
fibo 1 = 1
fibo n = (fibo (n-1)) + (fibo (n-2))

fibo 3   fibo 3      fibo 3      fibo 3    fibo 3     fibo 3     fibo 3    2    
         fibo 2      fibo 2      fibo 2    1          fibo 1     1
                     fibo 1      fibo 0               
                     1 + ?       1 + 0     1 + ?      1 + ?      1 + 1


versus:

fibo n = fibop 0 1 n
          where fibop x y 1 = y
                fibop x y n = fibop y (x+y) (n-1)

fibop 0 1 3
fibop 1 1 2
fibop 1 2 1
2

The second implementation of fibo has exponentially fewer calls hence it is more efficient.
Test: !! fibo 100 vs fibo' 100

Furthermore, all functional programming languages implemement tail call-optimisation.
This means that, in the previous sum example, instead of using a linear number (in the size of the list)
of function calls fp, we use only one stack cell, and erase the previous call, since its return value
is EQUAL to the current value of the called function.

Functions which return 'tail calls' are called 'tail-end functions', and this technique is called
tail-end optimisation.


------------------------------
Part 2:   Pattern matching
------------------------------

Our 'sum' function is still not quite `functionally-written` w.r.t. Haskell.

f v = fp 0 v 
        where fp sum [] = sum
              fp sum (x:xs) = fp (sum + x) xs

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

the third pattern will never be reached as the second one is more general (the interpreter usually
signals this)


Patterns can be used liberally in function definitions. For instance, what does the following functions do:

f [] = []
f ([x]:y) = (f y)++[x]

g [] = []
g ([x]:y) = x:(g y)

-}            
