
data PExpr = Val Integer |
             Var String  |
             PExpr :+: PExpr | 
             PExpr :*: PExpr 
            
-- Exercise: represent the above example in Haskell.

data BExpr = PExpr :==: PExpr | 
            PExpr :>: PExpr |
            Not BExpr |
            BExpr :&&: BExpr |
            T | F

type Var = String

data Prog = PlusPlus Var |        -- x++;
            Var :=: PExpr |     -- x = <expr>;
            DeclareInt Var |      -- int x;
            DeclareBool Var |
            -- Comma Prog Prog
            Begin Prog Prog |     -- <p> <p'>
            While BExpr Prog |     -- while (<expr>) { <p> }
            If BExpr Prog Prog |     -- if (<expr>) { <p> } else { <p'> } 
            Nil
            -- deriving Show  

show_p :: Prog -> String
show_p (PlusPlus v) = v++"++;\n"
show_p (x :=: e) = x++"=?;\n"
show_p (DeclareInt x) = "int "++x++";\n"
show_p (Begin p p') = (show_p p)++(show_p p')
show_p (While e p) = "while (?) {\n"++(show_p p)++"}\n"
show_p (If e p p') = "id (?) {\n"++(show_p p)++"}\n else {\n"++(show_p p')++"}\n"
show_p Nil = ""

instance Show Prog where
  show = show_p

{- Scoping -}
p = DeclareInt "x" `Begin` (PlusPlus "x") `Begin` While T ((DeclareInt "y") `Begin` ("y" :=: ((Var "x") :+: (Val 1))))
{- This definition is quite hard to read, so we can improve it
   Begin (DeclareInt "x") (Begin (DeclareInt "y") (...))
   Begin (DeclareInt "x") $ Begin (DeclareInt "y") (...)
                function    parameter

-}

p' = Begin (DeclareInt "x") $ 
     Begin (PlusPlus "x") $ 
     While T (Begin (DeclareInt "y") $
                    "y" :=: ((Var "x") :+: (Val 1))
                   ) 
{-
      int x;
      x ++;
      while (x > 0){
         int y;
         y = x + 1;
      }
      
-}

{- test example

  int x;
  if (x > 0) {
    y++;
  }
  else{
    x = y+1;
  }

-}

ptest = Begin (DeclareInt "x") $
        If ((Var "x") :>: (Val 0)) (PlusPlus "y") ("x" :=: ((Var "y") :+: (Val 1))) 

declared_vars :: Prog -> [Var]
declared_vars (DeclareInt v) = [v]
declared_vars (DeclareBool v) = [v]
declared_vars (Begin p p') = (declared_vars p)++(declared_vars p')
declared_vars (While _ p) = declared_vars p
declared_vars (If _ p p') = (declared_vars p)++(declared_vars p')


{-
check_def :: Prog -> Boolean
check_def p = 
    where check :: [Var] -> Prog -> Result [Var]
      To better understand what check needs to do, let us consider our example
      
      int x;
      x++;
      while (x > 0){
         int y;
         y = x + 1;
      }
      y++;


             Begin
            /    \
       int x;    Begin
                 /     \
               x ++;   While
                       /   \
                      ..   Begin
                           /  \
                      int y;   y = x + 1 

  Trying to implement check (Begin p p') reveals the following strategy:
    - check variable usage in program p, and:
             - if no variable is undeclared, GET the list l of definitions
             - if a variable is undeclared, fail
    - use the list l of definitions to check program p'

    therefore, (check l p):
          -  should return False (or an error), if p contains a variable which is undeclared;
          -  should return the list of DECLARED variables, if the verification succeeds, so that
             this list can be used later on in the verification process

-}

{-
         To accomodate this behaviour, we define:
-}
data Result a = Error String |  -- a value of type (Result a) is an error, or
                Value a         -- an actual value, wrapped by the data constructor Value
                deriving Show

-- check :: [Var] -> Prog -> Result [Var]
