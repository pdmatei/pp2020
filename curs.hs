{-

    Recall our previous higher-order functions
    foldr :: (a -> b -> b) -> b -> [a] -> b
    foldl :: (b -> a -> b) -> b -> [a] -> b
    map :: (a -> b) -> [a] -> [b]
    filter :: (a->Bool) -> [a] -> [a]


    However, there are two other higher order functions which are essential:

    (.) :: (a -> b) -> (c -> a) -> c -> b

    (f . g) x = f (g x)

    Examples:

    c x = (f . g) x
          where f x = x + 1
                g x = 2*x

    this is actually the implementation of functional composition.

    ($) :: (a -> b) -> a -> b

    ($) f x = f x

    c x = f $ g x
        where f x = x + 1
              g x = 2*x

    $ is a good way to omit parenteses and to write more legible code in many
    circumstances.


    A crucial aspect of functional programming are lambdas.
    This slide should show you just how important they are.

    To understand lambdas, and program better with them, it is useful to go back in history
    to the moment when they were invented, in the 30s, by Alonzo Church.

    He knew about the TM, but had a better idea for describing what computation is.
    The idea is related to functions, and function applications.

    f(x,y) = x + y

    In mathematics, a function has a domain definition (signature) and a body. It also has
    a name. For church, the domain was unimportant (we will see why. We can also consider
    domains as types, but his lambda calculus is untyped). Also, the name was unimportant,
    as functions are different to the extent to which they describe different transformations.
    Names do not matter.

    With this in mind, Church invented a notation which allows writing the function: 
    f(x) = x + 1

    as:
    \x. x + 1   this is called a lambda-function or lambda-abstraction

    and function application f(1), as:
    (\x.x+1 1)

    So, for instance, (f(1) + f(1)) would be:

    ((\x.x+1 1) + (\x.x+1 1))

    At this point, you should stop and ask:
     - isn't (+) also a function? If so, then maybe we should write:

    (+ (\x.x+1 1) (\x.x+1 1))

     - but if + is a function, then it shouldn't have a name, as lambdas don't have names

    (\x y.body_of_addition (\x.body_of_inc 1) (\x.body_of_inc 1))

    This is actually more apropriate, but still incomplete. However, we need to talk
    about parameter number in the lambda calculus.

    The lambda calculus is curried, (after Haskell Curry), which means that EACH function
    has exactly one parameter.
    Let us forget about bodies for now, and rewrite (artificially still), the previous
    expression

    (\x y.x+y (\x.x+1 1) (\x.x+1 1))

    To make each function have exactly one parameter, we need to rewrite the above expression
    to:
    (\x.\y.x+y (\x.x+1 1) (\x.x+1 1))

    Now, let us think about what it means to pass a parameter to a function in a programming
    language. Church did not have a machine to implement Lambda, so his definition relied
    on rewriting, or substitution: EACH OCCURRENCE of the variable is replaced by the parameter
    it the function body. We shall later see that this definition requires a lot of tuning.

    (\x.x+1 1) => 1+1

    So, going back to our example, we note that we have two parameters, given to the function
    \x.\y.x+y, but only one parameter is allowed. Thus, we need to rewrite:

    ((\x.\y.x+y (\x.x+1 1))) (\x.x+1 1))

    It actually helps to write the expression tree of this expression to make sense of it:

                    App
                  /      \
               App            App
               /   \         /     \
        \x.\y.x+y   App    \x.(x+1)  1
                   /  \
               \x.x+1  1


    In the Lambda Calculus, this means that parameters are given IN TURN, or the expression
    is curried.

    Thus, to evaluate the expression, we first evaluate the lhs of the application:
    ((\x.\y.x+y (\x.x+1 1))) (\x.x+1 1)) =>
    (\y.(\x.x+1 1)+y) (\x.x+1 1))

    Note that in doing so, we have applied our informal definition, we have replaced
    the function with the body, in variable x is replaced by the parameter (\x.x+1 1)

    Now, we do the same thing:
    (\y.(\x.x+1 1)+y) (\x.x+1 1)) =>
    (\x.x+1 1)+(\x.x+1 1)

    You may also ask, why did we choose to evaluate the outer application instead of
    some inner one. This is a good question, however it goes outside the scope of this
    lecture.

    So, to recap, a function of the form:
    \x.\y.\z.body , which is called ((((\x.\y.\z.body) p1) p2) p3) 
    is called curried. In the lambda calculus, all functions are curried.

    A function of the form:
    \x y z. body, which is called (\x y z.body p1 p2 p3)
    is called uncurried.


    Why is the difference important? For writing, in the first hand. We can extend
    the lambda calculus to include uncuried functions, via a definition, and it helps
    us ridding of so many parentheses.

    But also because, in a programming language,
    a curried function MAY RETURN as result, ANOTHER function.

    ((\x.\y.x+y) 1) 2) => (\y.1+y 2)
    Also, this has sense:
    
    ((\x.\y.x+y) 1) => \y.1+y

    This is not some random state of an internal computation, but an actual result.
    Let us test it in Haskell:

    \x->\y->x+y 1

    you see an error, however, by adding:
    instance Show (a->b) where
      show f = "function"

    we see that the only problem Haskell has, is with properly displaying a function
    (how do you print a function?)
    Not with the function itself.


    Another important thing is that in Haskell, there is no difference between
    curried and uncurried functions. In MOST (if not all) other programming languages,
    this is not really the case. 
    This means that:

    f = \x -> \y -> x+y
    f = \x y->x + y

    are just the same. Also,
    f x y = x + y is just a syntax sugar for the above expression, which is easier
    to write. However, ALL functions in Haskell are Lambda-functions.

    As a direct consequence, is also the same as the above.

    f x = \y -> x + y

    So now let us look at the signature of f:

    f :: Integer -> Integer -> Integer

    The call (f 1) will have type Integer -> Integer (and return a function),
    whereas (f 1 2) (or ((f 1) 2) ) will have type Integer.

    This shows why this notation for types is prefered over:
    Integer x Integer -> Integer

    as this would refer to the UNCURRIED function which takes two integers and returns another

    also:
    Integer -> (Integer -> Integer)
    would refer to the CURRIED function which takes one integer and returns a function
    which takes one integer and returns a function which takes one integer and returns
    another integer.

    In Haskell,

    Integer -> Integer -> Integer  is the same as:
    Integer x Integer -> Integer
    Integer -> (Integer -> Integer)

    as functions can be interepreted as curried and uncurried.

    Note however that, while Integer -> (Integer -> Integer) is the same thing as
    Integer -> Integer -> Integer, the signature:

    (Integer -> Integer) -> Integer is not the same thing. This is a function which
    takes another function as parameter and returns an integer. Write an example
    of a function with this signature.


    So the reason we wanted to look at Lambda Calculus, was to understand:
    lambda functions and currying in Haskell. Let us revisit some old examples, and
    enhance them:

    summ = foldr (+) 0
    prod = foldr (*) 1

    reverse = foldl (\x y->y:x) []

    map f = foldr (\x acc->(f x):acc) []

    map f = foldr ((:).f) []

    this is particularly tricky to grasp:

    f :: a -> b
    (:) :: c -> [c] -> [c]

    Now, ((:).f) makes sense because ALL functions can be viewed as curried, thus
    they take one parameter.
    So, how is ((:).f) x. Cf def, it is (:) (f x), which is a function which expects
    a list and introduces (f x) in it.
    then ((:).f) is a function which takes an x and a list (accumulator) and introduces
    (f x) in it.

    These examples only start to show the power of Haskell as a programming language.
-}

