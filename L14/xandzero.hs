
{- Interesting applications: 
   An X and 0 AI.
-}

transpose ([]:_) = []
transpose m = (map head m) : (transpose (map tail m))

data State = Mat [[Char]] deriving Eq
type Player = Char         -- 'X' or '0'

instance Show State where
    show (Mat m) = '\n' : (foldr (++) "" $ map (foldr op "\n") m)
                      where op ' ' acc = '_':' ':acc
                            op x acc = x:' ':acc 

s = Mat [" X ","  0","X  "]

other 'X' = '0'
other '0' = 'X'

-- diagonals
diags [[a,_,x],[_,b,_],[y,_,c]] = [[a,b,c],[x,b,y]]

winner :: Player -> State -> Bool
winner p (Mat m) = foldr isWin False $ (diags m)++m++(transpose m)
                    where l `isWin` acc 
                                | l == [p,p,p] = True
                                | otherwise = acc
 
-- should take into account winning, and stop as well.
next_state :: Player -> State -> Maybe [State]
next_state p s
    | winner (other p) s = Nothing
    | succs == [] = Nothing            -- no place on the board 
    | otherwise = Just succs
        where succs = foldl (++) [] $ map ($s) [f1,f2,f3,f4,f5,f6,f7,f8,f9] 
              f1 (Mat [[' ',a,b],l2,l3]) = [Mat [[p,a,b],l2,l3]]
              f1 _ = []
              f2 (Mat [[a,' ',b],l2,l3]) = [Mat [[a,p,b],l2,l3]] 
              f2 _ = []
              f3 (Mat [[a,b,' '],l2,l3]) = [Mat [[a,b,p],l2,l3]]
              f3 _ = []
              f4 (Mat [l1,[' ',a,b],l3]) = [Mat [l1,[p,a,b],l3]]
              f4 _ = []
              f5 (Mat [l1,[a,' ',b],l3]) = [Mat [l1,[a,p,b],l3]]
              f5 _ = []
              f6 (Mat [l1,[a,b,' '],l3]) = [Mat [l1,[a,b,p],l3]]
              f6 _ = []
              f7 (Mat [l1,l2,[' ',a,b]]) = [Mat [l1,l2,[p,a,b]]]
              f7 _ = []
              f8 (Mat [l1,l2,[a,' ',b]]) = [Mat [l1,l2,[a,p,b]]]
              f8 _ = []
              f9 (Mat [l1,l2,[a,b,' ']]) = [Mat [l1,l2,[a,b,p]]]
              f9 _ = []


size :: [a] -> Integer
size [] = 0
size (_:xs) = 1 + (size xs)

cost :: Player -> State -> Integer
cost x (Mat m) = maximum $ map line_cost $ (diags m)++m++(transpose m) 
                  where line_cost = size . filter (==x) 


data GTree a = Node a [GTree a] deriving Show


make_tree :: Player -> State -> GTree State
make_tree p init = case next_state p init of
                            Nothing -> Node init []   -- no more moves, game over 
                            Just succs -> Node init $ map (make_tree (other p)) succs 


s0 = Mat ["   ","   ","   "]
s1 = Mat ["X  "," X ","  X"]

gt = make_tree '0' s0

sucs (Node s r) = r

type Level = Integer

tmax :: Player -> Level -> GTree State -> Integer
tmax p _ (Node s []) = cost p s
tmax p 0 (Node s _) = cost p s
tmax p h (Node _ sucs) = maximum $ map (tmin (other p) (h-1)) sucs  

tmin :: Player -> Level -> GTree State -> Integer
tmin p _ (Node s []) = cost p s
tmin p 0 (Node s _) = cost p s
tmin p h (Node _ sucs) = minimum $ map (tmax (other p) (h-1)) sucs


test = tmax 'X' 2 gt



 
  