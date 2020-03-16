{-
    1 2 3      9 8 7       1*9 + 2*6 + 3*3 
    4 5 6  x   6 5 4    =   
    7 8 9      3 2 1

    li = [1,2,3]
    cj = [9,6,3]
    zipWith li cj = [1*9, 2*6, 3*3]
    foldr (+) 0 (zipWith li cj)
    pozitia ij din matricea produs
-}
m1 = [[1,2,3],[4,5,6],[7,8,9]]
m2 = [[9,8,7],[6,5,4],[3,2,1]]
trm2 = [[9,6,3],[8,5,2],[7,4,1]]

f li cj = foldr (+) 0 (zipWith (*) li cj)

{-
    1 2 3      9 8 7       30 24 18
    4 5 6  x   6 5 4    =   
    7 8 9      3 2 1

-}
g li = map (\cj->foldr (+) 0 (zipWith (*) li cj)) trm2


prod m m' = map (\li->map (\cj->foldr (+) 0 (zipWith (*) li cj)) (tr m')) m

{-Transpunerea unei matrici 

     1 2 3     1 4 7
  tr 4 5 6  =  2 5 8
     7 8 9     3 6 9

 m=  [[1,2,3],
      [4,5,6],
      [7,8,9]]

  map head m = [1,4,7]
  map tail m = [[2,3],
                [5,6],
                [8,9]]
  map tail m = 
                [[3],
                 [6],
                 [9]]
             [[],
              [],
              []]
-}
tr ([]:_) = []
tr m = (map head m):(tr (map tail m))
{-          ^
   construim prima linie din matricea transpusa
   construim prima linie din tr
   eliminam prima coloana din mat originala
   repetam procedul pe mat ^
-}
