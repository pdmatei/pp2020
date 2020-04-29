/*
   
   Proof trees.

*/

student(tim).
student(bob).
student(john).
student(mary).

male(tim).
male(bob).
male(john).

female(mary).

lecture(pp).
lecture(aa).

studies(tim,aa).
studies(mary,pp).
studies(mary,aa).
studies(john,pp).

withFemaleColleague(X) :- male(X), studies(X,L), studies(Y,L), female(Y).

/*
    In Logic, the concept of order is absent.
    However, in Prolog order (of sub-goals in a clause) matters.

    A good Prolog programmer needs to be aware of the order in which goals (and their subgoals) are
    satisfied. This is useful:
       - to find out programming bugs
       - to make programs more efficient.

    Consider:
    -? student(X).
    
    The order in which goals are satisfied is:
    X = tim ;
	X = bob ;
	X = john ;
	X = mary. 

    which is precisely the order in which clauses in the program are written.

    Now, let us take a more complicated goal.

    -? student(X), studies(X,pp).

    In order to prove this goal, and to find all relevant bindings of X, Prolog constructs
    a PROOF TREE. The proof tree can be illustrated as follows:

    student(X)
      X = tim
         studies(tim,pp) -> false
      X = bob
         studies(bob,pp) -> false
      X = john
         studies(john,pp) -> true (X = john is shown).
      X = mary
         studies(mary,pp) -> true (X = mary is shown).

    If we reverse the order of sub-goals in our goal, i.e. 

    -? studies(X,pp), student(X).
      X = mary
         student(mary) -> true
      X = john
         student(john) -> true

    we obtain a different proof tree. 

    We can investigate the proof step, using:
    -? debug.
    -? trace.

    Using Enter (or "creep" meaning take a small-step), we can go step-by-step through the program.
    Using ("l" from "leap", we can move on to the next goal).


    We an alternatively view:
      student(X) - as a "generative" goal (generates X's)
      and studies(X,pp) - as a "filtering" goal (filters out X's)

      student(X) will generate 4 candidates
      studies(X,pp) will generate 2 candidates

      The first tree will have the following structure:
                    *
            *    *     *    *
           * *  * *   * *  * *

      Wereas the second proof tree will have the following structure:
               *
          *         *
       * * * *   * * * * 

      The number of nodes is similar, however, in many cases, we can CUT
      proof trees to make programs more effective. In those cases, the structure of the tree matters.

     
      Understanding the type of tree is important.

      Consider:
    
    -? withFemaleColleague(X), studies(X,Lec).

    which will generate all the male students which have a female colleague, and the lectures studied by them.
    The proof tree looks as follows.

    withFemaleColleague(X) :- male(X), studies(X,L), studies(Y,L), female(Y).

    withFemaleColleague(X)
        male(X)
          X = tim
            studies(tim,L)
                L = pp
                    studies(Y,aa)
                    |    Y = mary
                    |       female(mary) -> true (X = tim, L = aa, Y = mary)
    studies(tim,Lec)
          Lec = aa    -> (X = tim, Lec = aa)
                    |
                    |    Y = john
                    |       female(john) -> false
          X = bob
            studies(bob,L) -> false
          X = john
            studies(john,L)
                L = pp
                    studies(Y,pp)
                          Y = mary
                              female(mary) -> true (X = john, L = pp, Y = mary)
    studies(john,Lec)
          Lec = pp      (X = tim, Lec = pp)


    1) Exercise: write the tree for:
    studies(X,L), female(X), studies(Y,L), male(Y).
*/
     
nat(zero).
nat(X) :- X = succ(Y), nat(Y).

add(zero,Y,Y).
add(succ(X),Y,succ(Res)) :- add(X,Y,Res). 

/* we can complement the type Nat, with expressions over naturals
*/

nat_expr(X) :- number(X).
nat_expr(X) :- nat(X).
nat_expr(plus(E1,E2)) :- nat_expr(E1),nat_expr(E2).
nat_expr(mult(E1,E2)) :- nat_expr(E1),nat_expr(E2).

/*
examples:

plus(succ(succ(zero),succ(zero))  // 2 + 1
mult(succ(succ(zero)), plus(succ(zero), succ(zero)))) // 2*(1+1)

we can now evaluate expressions, by writing the predicate
eval/2:
*/
eval(E,E) :- nat(E).
eval(plus(E1,E2),R) :- eval(E1,R1), eval(E2,R2), add(R1,R2,R).


/* 

   Unification
   ------------

   How do we test equality of expressions? What does = do?

   -? plus(X,mult(2,3)) = plus(plus(0,1),Y).

   The output shows us that Prolog is trying to find those X and Y which make the lhs and rhs 
   expressions identical.

   we can also challenge the equality even further.

   -? plus(X,mult(2,3)) = plus(plus(0,Y),Y).
   
   To better understand what Prolog does, consider the following algorithmic description:
     - lhs is a "plus/2"-term
     - rhs is a "plus/2"-term
          therefore, lhs unifies with rhs iff:
              - X Unif plus(0,Y)  [X/plus(0,Y)]
              - mult(2,3) Unif Y  [Y/mult(2,3)]
          
          [X/plus(0,mult(2,3)), Y/mult(2,3)] 

   * The operator = is simmetrical. (E1 = E2 is the same thing as E2 = E1).

   Exercises:

   -? plus(X,Y) = plus(Y,2).
   -? mult(plus(X,Y),Z) = plus(mult(X,Y),Z).
   -? mult(plus(X,Y),Z) = mult(Z,plus(mult(2,3),4)).
   -? mult(X,mult(Y,Z)) = mult(mult(Y,Z),X).
            (X = mult(Y,Z))
   
   Consider:
   goal1(X1, ... Xn), goal2(X2, X1, X3...)
     When satisfying goal1, Prolog builds a MOST GENERAL UNIFIER for X1, ... Xn, 
     and uses that unifier, to satisfy goal2(X2, X1, ...)

   
   Example:
   -? plus(X,Y) = plus(Y,X), mult(X,Y) = mult(2,Y).
      to satisfy plus(X,Y) = plus(Y,X),
      prolog builds [X/Y], and uses it to satisfy
                             mult(X,Y) = mult(2,Y)
                             At the end of the clause, the MGU is shown to the user.
                             [X/Y, Y/2]

   In Prolog, expressions containing + and *, behave PRECISELY like 
   those shown above.

   Example:
   -? X + Y = Y + X, X * Y = 2 * Y.

   Hence, the operator "lhs = rhs":
      - performs unification of term lhs with term rhs.
      - and computes a most general unifier for them.


   Other operators on natural numbers:
   X is Expr. (assignment)
   this operator:
       - is satisfied if
             * X is unbound and Expr is an arithmetic expression. 
               it evaluates Expr and bounds X to expr.
             * X is bound to the very same expression as Expr.

   Other examples:
   X is Y + Z, Y = 2, Z = 3.
   returns an error, since Y and Z are not yet bound in "X is Y + Z".
   Y = 2, Z = 3, X is Y + Z.
   will return 5


   E1 =:= E2 (comparison)
   - evaluates E1, E2 and succeeds if they have THE SAME VALUE!

   Examples:
   X = 2, Y = 3, X + Y =:= Y + X.
   
   [1] =:= [2]. - false


*/

/*
  
   Application.
   What does:
   add(X,Y,R), toNat(1,X), toNat(0,Y), fromNat(R,O).

   actually do?

   Let us build the proof tree.
   add(zero,Y,Y).
   add(succ(X),Y,succ(Res)) :- add(X,Y,Res). 

   add(X,Y,R)
     X = zero
     Y = Y'   (variables are LOCAL to the clause at hand)
     R = Y'
         toNat(1,zero) -> fails.

     X = succ(X')
     Y = Y'
     R = succ(Res)
         add(X',Y,Res)
              X' = zero
              Y = Y''
              Res = Y''  

   toNat(1,succ(zero)) -> true
   toNat(0,Y') 
         Y' = zero
   fromNat(R,O)
              R = succ(Res), Res = Y'', Y'' = Y, Y = Y', Y' = zero
              thus
              R = succ(zero)  -> the program outputs 
   {next, fromNat(R,O) cannot be resatisfied, nor toNat(0,Y),toNat(1,X).}

        add(X',Y,Res) can be resatisfied!
              X' = succ(X'')
              Y  = Y'''
              Res = succ(Res')
                  add(X'',Y,Res')
                      X'' = zero
                      Y = Y4
                      Res' = Y4
                            toNat(1,succ(succ(zero))) -> fail
                  add(X'',Y,Res')
                      X'' = succ(X''')
                      Y = Y5
                      Res' = succ(Res'')
                       and the process repeats, by building ever larger natural numbers.
                       Again, the issue here is that X and Y are being instantiated
                       in the process of satisfying add.
                       They should be instantiated prior to the call of add.




*/


toNat(0,zero).
toNat(X,succ(Res)) :- X>0, Xp is X-1, toNat(Xp,Res).

fromNat(zero,0).
fromNat(succ(X),R) :- fromNat(X,Rp), R is Rp + 1. 

