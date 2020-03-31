import Control.Applicative
import Data.List
import System.IO
import Data.Char


-- Interpreter and debugger

-- this forces flushing of putStr
main = do hSetBuffering stdout NoBuffering
          lambda

first_ws :: String -> [String]
first_ws (' ':xs) = [[],xs]
first_ws (x:xs) = (x:y):z
                    where (y:z) = first_ws xs
first_ws [] = [[]]

unique :: Eq a => [a] -> [a]
unique = uniq []
          where uniq l [] = l
                uniq l (x:xs)
                    | x `elem` l = uniq l xs
                    | otherwise = uniq (x:l) xs

setminus :: Eq a => [a] -> [a] -> [a]
setminus [] l = []
setminus (x:xs) l
  | x `elem` l = setminus xs l
  | otherwise = x:(setminus xs l)

-- "interpreter mode"
lambda :: IO ()
lambda = do
        putStr "Lambda>"
        line <- getLine
        attempt_eval line  -- parse the argument as a lambda expression and if it fails, look for a command
          where attempt_eval line = case reads line of
                    [(lexpr,"")] -> do putStrLn $ (show . evalapp) lexpr
                                       lambda
                    _ -> switch (first_ws line)
                switch :: [String] -> IO()
                switch cmd = case cmd of
                  ["debug"] -> debug
                  [c,arg] -> do case (c,reads arg) of
                                  ("evalapp",[(lexpr,"")]) -> putStrLn $ (show . evalapp) lexpr
                                  ("eval",[(lexpr,"")]) -> putStrLn $ (show . evalapp) lexpr                            
                                  ("evalnorm",[(lexpr,"")]) -> putStrLn $ (show . evaln) lexpr                               
                                  (":t",[(lexpr,"")]) -> case lexpr of
                                                          (App _ _) -> putStrLn $ (show lexpr)++" :: App"
                                                          (Lambda _ _) -> putStrLn $ (show lexpr)++" :: Func"
                                                          (Var _) -> putStrLn $ (show lexpr)++" :: Var"
                                  ("fv",[(lexpr,"")]) -> putStrLn $ (show . unique . free) lexpr
                                  ("bv",[(lexpr,"")]) -> putStrLn $ (show . unique) ((var lexpr) `setminus` (free lexpr))
                                  _ -> putStrLn "Invalid command/lambda expression"
                                lambda 
                  _ -> do putStrLn "Invalid command"
                          lambda

-- debugging mode
debug :: IO ()
debug = do
        putStr "Lambda-debug>"
        line <- getLine
        switch (first_ws line)
          where switch :: [String] -> IO ()
                switch cmd = case cmd of
                  ["quit"] -> lambda
                  [c,arg] -> case (c, reads arg) of
                              ("evalapp", [(lexpr,"")]) -> appdebug [lexpr]
                              ("evalnorm", [(lexpr,"")]) -> normdebug [lexpr]
                              _ -> do putStrLn "Invalid command/lambda expression"
                                      debug
                  _ -> do putStrLn "Unexpected input"
                          debug

either_or :: IO () -> IO () -> IO ()
either_or x y = do line <- getLine
                   if line == "quit" then x else y

appdebug :: [LExpr] -> IO ()
appdebug l = case l of 
              (expr@(App (Lambda x e) arg):xs) -> do putStrLn $ "Evaluate attempt:"++(show expr)
                                                     either_or debug $
                                                               appdebug $ arg:(AppR (Lambda x e)):xs
              ((App e e'):xs) -> appdebug $ e:(AppL e'):xs
              ((Lambda x e):(AppL e'):xs) -> appdebug $ (App (Lambda x e) e'):xs
              (e:(AppL e'):xs) -> appdebug $ (AppE e e'):xs
              (arg:(AppR (Lambda x e)):xs) -> do putStrLn $ "Reduced to:"++(show reduced) 
                                                 appdebug $ reduced:xs
                                                    where reduced = subst x arg e
              l -> do putStrLn $ "Final result: "++ ((show . head . clean) l) 
                      debug

normdebug :: [LExpr] -> IO ()
normdebug l = case l of
               (expr@(App (Lambda x e) arg):xs) -> do putStrLn $ "Evaluate attempt:"++(show expr)
                                                      either_or debug $ do
                                                                putStrLn $ "Reduced to:"++(show reduced) 
                                                                either_or debug $ normdebug $ reduced:xs
                                                       where reduced = subst x arg e
               (expr@(App e e'):xs) -> do putStrLn $ "Evaluate attempt:"++(show expr)
                                          either_or debug $
                                                    normdebug $ e:(AppL e'):xs
               ((Lambda x e):(AppL e'):xs) -> normdebug $ (App (Lambda x e) e'):xs
               l -> do putStrLn $ "Final result: "++ ((show . head . clean) l) 
                       debug

{-
       Evaluation part - the lambda calculus
-}


data LExpr = Var String | App LExpr LExpr | Lambda String LExpr
             | AppL LExpr -- awaiting evaluation of the LHS
             | AppR LExpr -- awaiting evaluation of the RHS
             | AppE LExpr LExpr -- already evaluated app


clean :: [LExpr] -> [LExpr]
clean (func:(AppL e'):xs) = clean $ (App func e'):xs
clean l = l

evaln :: LExpr -> LExpr
evaln e = (head . clean . f) [e]
            where f :: [LExpr] -> [LExpr]
                  f ((App (Lambda x e) arg):xs) = f $ (subst x arg e):xs
                  f ((App e e'):xs) = f $ e:(AppL e'):xs
                  f ((Lambda x e):(AppL e'):xs) = f $ (App (Lambda x e) e'):xs
                  f l = l

evalapp :: LExpr -> LExpr
evalapp e = (head . clean . f) [e]
            where f :: [LExpr] -> [LExpr]
                  f ((App (Lambda x e) arg):xs) = f $ arg:(AppR (Lambda x e)):xs
                  f ((App e e'):xs) = f $ e:(AppL e'):xs
                  f ((Lambda x e):(AppL e'):xs) = f $ (App (Lambda x e) e'):xs
                  f (e:(AppL e'):xs) = f $ (AppE e e'):xs  -- failed in reducing an App
                  f (arg:(AppR (Lambda x e)):xs) = f $ (subst x arg e):xs
                  f l = l


free :: LExpr -> [String]
free (Var x) = [x]
free (App e e') = (free e)++(free e')
free (Lambda x e) = delete x (free e)

var :: LExpr -> [String]
var (Var x) = [x]
var (App e e') = (var e)++(var e')
var (Lambda x e) = x:(var e)

-- newvar only works for single-character variables
newvar :: [String] -> String
newvar l = f l 'a'
          where f [] c = [c]
                f ([x]:xs) c
                   | x == c = f xs (succ c)
                   | otherwise = f xs c

subst :: String -> LExpr -> LExpr -> LExpr
subst x arg (Var y)
      | x == y = arg
      | otherwise = Var y
subst x arg (App e e') = App (subst x arg e) (subst x arg e')
subst x arg (AppE e e') = App (subst x arg e) (subst x arg e')
subst x arg (Lambda y e) 
      | x == y = (Lambda y e)  -- free occurrences only
      | y `elem` (free arg) = Lambda nv $ subst x arg $ subst y (Var nv) e
      | otherwise = Lambda y $ subst x arg e
                                where nv = newvar ((var arg)++(var e))



-- Parsing lambda expressions --

instance Read LExpr where
  readsPrec _ = let Parser p = lexprp in p 

data Parser a = Parser (String->[(a,String)])

instance Show LExpr where
  show (Var s) = s
  show (App e e') = "("++show e++" "++show e'++")"
  show (AppL e) = "(? "++show e++")"
  show (AppR e) = "("++show e++" ?)"
  show (AppE e e') = "("++show e++" "++show e'++")"
  show (Lambda x e) = "λ"++x++"."++(show e)


ch :: Char -> Parser Char
ch c = Parser p 
            where p (x:xs) 
                      | c == x = [(x,xs)]
                      | otherwise = []
                  p [] = []

alpha :: Parser Char
alpha = Parser p
            where p (x:xs)
                    | isAlpha x = [(x,xs)]
                    | otherwise = []
                  p [] = []

plus :: (Parser a) -> Parser [a]
plus p = do 
            x <- p
            xs <- star p
            return (x:xs)

star :: (Parser a) -> Parser [a]
star p = plus p <|> return []

-- variables are just singleton strings
varp :: Parser LExpr
varp = do s <- alpha
          return $ Var [s]

appp :: Parser LExpr
appp = do 
          ch '('
          e <- lexprp
          ch ' ' 
          e' <- lexprp
          ch ')'
          return $ App e e'

lambdap :: Parser LExpr
lambdap = do
          ch 'λ'
          x <- plus alpha
          ch '.'
          e <- lexprp
          return $ Lambda x e

lexprp :: Parser LExpr
lexprp = lambdap <|> appp <|> varp

parse :: String -> Parser a -> [(a,String)]
parse s (Parser p) = p s

t = "(λx.x y)"

instance Alternative Parser where
  empty = Parser $ \s->[]
  (Parser p) <|> (Parser p') = Parser $ \s -> case p s of
                                               [] -> p' s
                                               [(x,s')] -> [(x,s')]

instance Functor Parser where
  fmap f m = (pure f) <*> m

instance Applicative Parser where
  pure = return

  mf <*> mp = do f <- mf
                 p <- mp
                 return (f p)
                     
instance Monad Parser where
  --return :: a -> Parser a
  return x = Parser $ \s -> [(x,s)]

  --(>>=) :: Parser a -> (a -> Parser b) -> Parser b
  (Parser p) >>= f = Parser $ \s -> case p s of
                                      [] -> []
                                      [(x,s')] -> let (Parser p') = (f x) in p' s' 


-- interpreter for lambda-expressions


