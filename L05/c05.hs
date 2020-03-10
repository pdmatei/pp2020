import Graphics.EasyPlot
import Data.List

{- This exercise is taken from Andrew Ng's ML course -}

{- Suppose you want to start a food truck business. You want to decide how
   to explore cities to ensure profit.
   You gather a dataset containing city population / profit. (Might be bought.)
   
   -}



{- E1: Parse the DS -}

{- a. Splitting function 
       
       We want to turn "Matei Popovici" into:
         ["Matei", "Popovici"]
       this can be achieved via a folding operation. To find
       out what the operator may be, let us imagine

       x is 'e' and acc is ["i","Popovici"]
      
-}
splitBy :: Char -> String -> [String]
splitBy c = foldr op [[]] 
              where op x (y:ys)
                      | x /= c = (x:y):ys
                      | otherwise = []:(y:ys)
{-
    b. Assembling the parsing requires writing a function "make dataset"
       which has the signature:

       makeds :: String -> [(Double, Double)]

       the following line of code makes each entry into an individual string
       (splitBy ' ') :: String -> [String]

       (splitBy ',') :: String -> [String]
       will make each entry e.g. "7.5386,3.8845" into ["7.5386","3.8845"]

       map (splitBy ',') :: [String] -> [[String]]
       will take a list of entries and separate each one, while:

       (map (splitBy ',')) . (splitBy ' ') :: String -> [[String]]
       will take a string, separate it into entries, and separate each
       entry into values

       (map (\[x,y]->(x,y))) . (map (splitBy ',')) . (splitBy ' ')
          :: String -> [(String,String)]

       will construct a list of pairs from a list of two elements;
       Finally, we convert each string to a double:

       (map (\(x,y)->(read x::Double,read y::Double))) .
       (map (\[x,y]->(x,y))) . 
       (map (splitBy ',')) . 
       (splitBy ' ')  :: String -> [(Double,Double)]               

       Now, we have the law that:
          (map f1).(map f2).(map f3) = map (f1.f2.f3)

       so we can simplify our function to:

       (map trans) . (splitBy ' ')  
            where trans = (\(x,y)->(read x::Double,read y::Double))) .
                          (\[x,y]->(x,y))) .
                          (splitBy ',')

       and we can reorder transformations to that we convert to double
       first, and then to a pair:
    
       (map trans) . (splitBy ' ')  
            where trans = (\[x,y]->(x,y))) .
                          (map (\x->read x::Double)) .
                          (splitBy ',')
   
-}                 

makeds = (map trans) . (splitBy ' ')
        where trans = (\[x,y]->(x,y)) . 
                      (map (\i->(read i)::Double)) . 
                      (splitBy ',')

{-
once the dataset has been parsed, let us view it.
Viewing is achieved using 
-}

{- Visualising the dataset and better understanding the problem: -}
plot1 = plot' [Interactive] Aqua $ 
        [ Data2D [Title "Truck productivity per population", Color Red] [] ds ]

ds = makeds dsraw

{- X axis: population in 10.000 ppl
   Y axis: profit in $10.000 -}


{- E2: Average profit & average population from ds

   single pass for the computation:
   this is useful since many ML algorithms NORMALIZE their values by dividing
   w.r.t. the average (to avoid working with large values)

   to obtain a list of populations, it suffices to map fst
   on our list:
   map fst ds

   and to sum it:
   foldr (+) 0 $ (map fst) ds

   and to avg it:

   (foldr (+) 0 $ (map fst) ds) / (foldr (\_ acc->acc+1) 0 $ (map fst) ds)

   But this is not really efficient as it requires to passes.
   To compute the average we can:
      - keep the current number of elements and current avg:

   foldr (\x (avg,n)->((avg*n+x)/(n+1) , n+1)) (0,0)
-}

avg :: [Double] -> Double 
avg = fst . (foldr (\x (avg,n)->((avg*n+x)/(n+1) , n+1)) (0,0))

{-
   We can use avg to substract the average from the dataset on x as well as y
   This will increase the speed of ML, since we work with small values on double,
   as well as precision.
-}

{- If we examine the dataset and try to predict a value, we observe
   that a reasonably-good function (model in ML) is a linear function.

   Let us try to plot it.

   -}    
f a b = \x -> a*x + b
{- 
    f describes our MODEL: - a linear function. The model parameters
    are a and b. 

    Let us choose a and b as 1.5 and (-6.0)
-}    
fexample1 = f 1.5 (-6.0)
fexample2 = f 2 1

{-
   to plot fexample, we need to turn it into a [(Double,Double)]
   We build the range [0, 0.5, 1, 1.5, ...] as
   (map (/2) [0..50])
   and apply f on each of its points:
-}
discretize f = map (\x->(x,f x)) 

-- we simply use the interval [0, 0.5, 1, 1.5, ...]
fds = discretize fexample1 (map (/2) [0..50])


plot2 = plot' [Interactive] Aqua $ 
        [ Data2D [Title "Truck productivity per population", Color Red] [] ds , 
          Data2D [Title "A model", Color Blue] [] fds ]

{- We have ilustrated the function 2x+1 which looks like a poor model.
   How should a better model be?

   After a few tentative tries, we may find that 1.5x-6.0 is a good model, hence
   a=1.5 and b=-6.0 are good parameters. 

   It may be the case that a better model exists, e.g. a quadratic function.
   But we do not go there.

   The aim of a ML algorithm is to AUTOMATICALLY discover good model parameters.
   The aim of the ML developer is to discover a good model!!

   Thus, what we want to do is:
   choose a,b s.t. sum (error_i) is minimised 
                    i
   
   choose a,b s.t. sum (ax_i + b - y_i) is minimised
                    i   predicted value
                                   real value

   we do not care about the sign of the error, so we square it,
   and also average it to prevent working with large numbers.

   choose a,b s.t. 1/m sum (ax_i + b - y_i)^2 is minimised
                    i   predicted value
                                   real value

   
   which can also be expressed vectorially, if:
    x = [x1, ..., xn]
    y = [y1, ..., yn]

    as:

  choose a,b s.t. 1/m (ax+b - y)*(ax+b - y)^T
   
   Thus, our ML algorithm must find the minimum of:

   C(a,b) = 1/m (ax+b - y)*(ax+b - y)^T

   w.r.t. values a and b.

   there are two ways to find those a and b values:
   Solve:
   dC/da = 0 and dC/db

   in practice, this is not efficient, and we prefer numerical values
   which basically explore the space of C and do a gradient descent:
   update in the "direction" of the minimum.


   -} 


{- E3: Suming up matrices -}
msum :: [[Double]] -> [[Double]] -> [[Double]]
msum = zipWith (zipWith (+))

{- E4: Scalar product -}

sprod v = map (map (*v))

{- E5: Transpose a matrix -}

tr ([]:_) = []
tr m = (map head m):(tr (map tail m))

{- E6: Vectorial prduct -}

vprod m1 m2 = 
  map (\line -> map (\col -> foldr (+) 0 (zipWith (*) line col) ) (tr m2) ) m1


{- Putting it all together: -}

cost a b = 1/(2*sz) * ((head.head) (dif `vprod` (tr dif)))
            where dif = (a `sprod` x) `msum` bb `msum` ((-1) `sprod` y)
                  x = [map fst ds]
                  y = [map snd ds]
                  bb = [repeat b]
                  sz = genericLength x

plot3 = plot' [Interactive] Aqua $ Function3D [Color Magenta] [] cost

{-
   If this were a ML lecture, we would now try to compute the minimum of the
   cost function which yeilds the best value for a and b such that ax+b is the
   best predictor of the profit value given a city population.

   (We will do that using lazy evaluation, later)
   However, this is a FP lecture. But there are a few ML tricks which we can do.
-}


{-
    E7: Split the DS into 80% - for training, and 20% - for evaluation:

       20% vs 25%
-}

evalds = l
        where (_,l) = foldr 
                        (\x (n,acc)-> if n == 4 then (0,x:acc) else (n+1,acc)) 
                        (0,[]) 
                        (sortBy (\(_,a) (_,b) -> compare a b) ds)

plot4 = plot' [Interactive] Aqua $ 
        [ Data2D [Title "Evaluation dataset", Color Red] [] evalds ]
                        



m = [[1,2],[3,4]]

dsraw = "6.1101,17.592\
\ 5.5277,9.1302\
\ 8.5186,13.662\
\ 7.0032,11.854\
\ 5.8598,6.8233\
\ 8.3829,11.886\
\ 7.4764,4.3483\
\ 8.5781,12\
\ 6.4862,6.5987\
\ 5.0546,3.8166\
\ 5.7107,3.2522\
\ 14.164,15.505\
\ 5.734,3.1551\
\ 8.4084,7.2258\
\ 5.6407,0.71618\
\ 5.3794,3.5129\
\ 6.3654,5.3048\
\ 5.1301,0.56077\
\ 6.4296,3.6518\
\ 7.0708,5.3893\
\ 6.1891,3.1386\
\ 20.27,21.767\
\ 5.4901,4.263\
\ 6.3261,5.1875\
\ 5.5649,3.0825\
\ 18.945,22.638\
\ 12.828,13.501\
\ 10.957,7.0467\
\ 13.176,14.692\
\ 22.203,24.147\
\ 5.2524,-1.22\
\ 6.5894,5.9966\
\ 9.2482,12.134\
\ 5.8918,1.8495\
\ 8.2111,6.5426\
\ 7.9334,4.5623\
\ 8.0959,4.1164\
\ 5.6063,3.3928\
\ 12.836,10.117\
\ 6.3534,5.4974\
\ 5.4069,0.55657\
\ 6.8825,3.9115\
\ 11.708,5.3854\
\ 5.7737,2.4406\
\ 7.8247,6.7318\
\ 7.0931,1.0463\
\ 5.0702,5.1337\
\ 5.8014,1.844\
\ 11.7,8.0043\
\ 5.5416,1.0179\
\ 7.5402,6.7504\
\ 5.3077,1.8396\
\ 7.4239,4.2885\
\ 7.6031,4.9981\
\ 6.3328,1.4233\
\ 6.3589,-1.4211\
\ 6.2742,2.4756\
\ 5.6397,4.6042\
\ 9.3102,3.9624\
\ 9.4536,5.4141\
\ 8.8254,5.1694\
\ 5.1793,-0.74279\
\ 21.279,17.929\
\ 14.908,12.054\
\ 18.959,17.054\
\ 7.2182,4.8852\
\ 8.2951,5.7442\
\ 10.236,7.7754\
\ 5.4994,1.0173\
\ 20.341,20.992\
\ 10.136,6.6799\
\ 7.3345,4.0259\
\ 6.0062,1.2784\
\ 7.2259,3.3411\
\ 5.0269,-2.6807\
\ 6.5479,0.29678\
\ 7.5386,3.8845\
\ 5.0365,5.7014\
\ 10.274,6.7526\
\ 5.1077,2.0576\
\ 5.7292,0.47953\
\ 5.1884,0.20421\
\ 6.3557,0.67861\
\ 9.7687,7.5435\
\ 6.5159,5.3436\
\ 8.5172,4.2415\
\ 9.1802,6.7981\
\ 6.002,0.92695\
\ 5.5204,0.152\
\ 5.0594,2.8214\
\ 5.7077,1.8451\
\ 7.6366,4.2959\
\ 5.8707,7.2029\
\ 5.3054,1.9869\
\ 8.2934,0.14454\
\ 13.394,9.0551\
\ 5.4369,0.61705"