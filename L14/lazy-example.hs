module Main where

main = do   putStrLn $ show x''
            return ()

l = [0..10]             -- evaluare stricta (aplicativ)

l' = map (+1) [0..10]

l'' = f 10
    where f 0 = []
          f n = n:(f (n-1))

{- Discutie despre performanta foldr 
    - foldr op acc (x:xs) = x `op` $ foldr op acc xs
    - nu este tail-end. 


-}
y = map (+0) [-5,-4,-3,-2,-1, 0, 1, 2, 3, 4, 5]
x = foldr op 1 y
        where e `op` acc 
                | e == 0 = 0
                | otherwise = e * acc
{-

foldr op acc [a,b,c] = a `op` $ foldr op acc [b,c]
                       a `op` (b `op` foldr op acc [c])
                       e `op` acc = 0

Concluzie: "foldr" nu este chiar atat de rau, daca evaluarea este lenesa;

-}


{- Discutie despre foldl 

Recall:
   foldl op acc (x:xs) = foldl (acc `op` x) xs

   foldl op acc [1,2,3] = 
    foldl op (acc `op` 1) [2,3] = 
        foldl op ((acc `op` 1) `op 2) [3] = 
            foldl op (((acc `op` 1) `op` 2) `op` 3) [] =
                (((acc `op` 1) `op` 2) `op` 3)

Concluzie: foldl consuma foarte multa memorie!!
Varianta eficienta: foldl'

-}
bad_foldl1 op acc [] = acc
bad_foldl1 op acc (x:xs) = bad_foldl1 op (acc `op` x) xs

bad_foldl2 op acc l = temp acc l
        where temp acc [] = acc
              temp acc (x:xs) = seq acc $ temp (acc `op` x) xs 


x'' = bad_foldl2 inc 0 [0..10000000]


_ `inc` acc = 1 + acc

y' = [1,2,3]
x' = foldl inc 0 y'

{- Ce putem face cu evaluarea lenesa? 
   Liste "infinite":
       - "date in timp real (continuu)"
       - "sockets"
       - IO
-}

ex = [0..]

nat x = x : (nat (x+1))
nats = nat 0

{-
take 0 _ = []
take n (x:xs) = x:(take (n-1) xs)
-}

type FSuccesor = Integer -> Integer
gen :: FSuccesor -> Integer -> [Integer]

gen f x = x:(gen f (f x))
-- [x, f x, f f x, f f f x, ....]

ex' = zipWith (,) (gen (+1) 0) (gen (*2) 1)


-- lista numerelor prime (Sita lui Eratostene)
{-
   2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25

   extrage primul element din lista 
   `elimina` (prin filtrare) toate elementele care se divid cu elementul extras

   3,_,5,_,7,_,9,_,11,_,13,_,15,_,17,_,19,_,21,_,23,_,25

   extrage primul element din lista 
   `elimina` (prin filtrare) toate elementele care se divid cu elementul extras

   5,_,7,_,_,_,11,_,13,_,_,_,17,_,19,_,_,_,23,_,25

-}
sieve :: [Integer] -> [Integer]
sieve (x:xs) = x:(sieve $ filter (\n-> n `mod` x /= 0) xs)

primes = sieve $ tail $ tail nats


{-
    1. Programarea dinamica
    2. Constructia de game trees (arbori de joc)
-}
