# Repo for Programming Paradigms lecture notes

## Functional programming

* **Lecture 1**: Four implementations for reversal:
  * Imperative, in-place [source](https://github.com/pdmatei/pp2020/blob/master/L01/V1.java)
  * Using ADTs [source](https://github.com/pdmatei/pp2020/blob/master/L01/TDA.java)
  * Using iterators [source](https://github.com/pdmatei/pp2020/blob/master/L01/V3.java)
  * Using a fold operation [source](https://github.com/pdmatei/pp2020/blob/master/L01/V4.java)
* **Lecture 2**: 
  * Side-effects lead to buggy programs [source](https://github.com/pdmatei/pp2020/blob/master/L02/RefTr.java)
  * Intro to Haskell side-effect-free programming [source](https://github.com/pdmatei/pp2020/blob/master/L02/c02.hs)

 * **Lecture 3**:
  * Functional programming basics in Haskell: recursion, pattern matching and higher-order functions (foldr, foldl, map, filter, zipWith) [source](https://github.com/pdmatei/pp2020/blob/master/L03/c03.hs)

* **Lecture 4**:
  * Lambda calculus basics. Programming with higher-order functions. Functional closures and curried vs uncurried functions [source](https://github.com/pdmatei/pp2020/blob/master/L04/c04.hs)

* **Lecture 5**:
  * Application (for higher-order functions): computing a model for linear regression and the respective cost function in Haskell [source](https://github.com/pdmatei/pp2020/blob/master/L05/c05.hs)
    * The Haskell package Easyplot, together with the plotting tool Gnuplot should be installed
  * The plotted data together with a possible linear model [source](https://github.com/pdmatei/pp2020/blob/master/L05/model-1.png)
  * The cost (or error) function which plots, for each model parameter (a,b), the square error of the model at hand [source](https://github.com/pdmatei/pp2020/blob/master/L05/error.png)

* **Lecture 6**:
  * Abstract (or Algebraic) Datatypes in Haskell.
  * A formal specification of the datatype Tree [source](https://github.com/pdmatei/pp2020/blob/master/L06/Tree.tda) 
  * A Java implementation of Tree [source](https://github.com/pdmatei/pp2020/blob/master/L06/Trees.java)
  * A Haskell implementation of Tree [source](https://github.com/pdmatei/pp2020/blob/master/L06/Tree.hs)  

* **Lecture 7**:
  * Programming with ADT's in Haskell:
  * Polymorphic trees, formulas: [source](https://github.com/pdmatei/pp2020/blob/master/L07/formula.hs)
  * Syntactic trees (for programs): [source](https://github.com/pdmatei/pp2020/blob/master/L07/prog_without_check.tda)  

* **Lecture 8**:
  * Ad-hoc vs parametric polymorphism.
  * Ad-hoc polymorphism in Java: method overriding [source](https://github.com/pdmatei/pp2020/blob/master/L08/Polymorphism.java)
  * Ad-hoc polymorphism in Haskell: typeclasses [source](https://github.com/pdmatei/pp2020/blob/master/L08/polymorphism.hs)

* **Lecture 9**:
  * Writing your own typeclass in Haskell [source](https://github.com/pdmatei/pp2020/blob/master/L09/Eval.hs)
  * A few words about type constructors [source](https://github.com/pdmatei/pp2020/blob/master/L09/type_constructors.hs)

* **Lecture 10** - The lambda Calculus:
  * An interpreter for the lambda calculus [source](https://github.com/pdmatei/pp2020/blob/master/L10/lambda.hs)
    * To compile, run `ghc -o lambda lambda.hs`
    * Use `:t <lambda_expression>` to check the *type* of a lambda expression
    * `fv <lambda_expression>` returns the set of free variables from a lambda expression
    * `bv <lambda_expression>` returns the set of bound variables from a lambda expression
    * `<lambda_expression>` evaluates a lambda expression using the applicative strategy
    * `evalnorm <lambda_expression>` evaluates a lambda expression using the normal strategy
    * `debug` enters debugging mode:
      * `evalapp <lambda_expression>` performs step-by-step evaluation using the applicative strategy
      * `evalnorm <lambda_expression>` performs step-by-step evaluation using the normal strategy
      * `quit` stops the evaluation process. Another `quit` command exits debugging mode

  * Lecture notes for the lambda calculus [source](https://github.com/pdmatei/pp2020/blob/master/L10/lecture_notes.txt)
  * Live lecture notes [source](https://github.com/pdmatei/pp2020/blob/master/L10/live_notes.txt)

* **Lecture 11** - Numbers and number programming in the Lambda Calculus:
  * Slides: [source](https://github.com/pdmatei/pp2020/blob/master/L11/Lambda-Calculus.pptx)
  
* **Lecture 12** - Substitution and random-order evaluation in the Lambda Calculus:
  * Slides: [source](https://github.com/pdmatei/pp2020/blob/master/L12/Substitution.pptx)
  * Examples: [source](https://github.com/pdmatei/pp2020/blob/master/L12/lecture_notes.txt)

* **Lecture 13** - Normal & Applicative evaluation in the Lambda Calculus:
  * Slides: [source](https://github.com/pdmatei/pp2020/blob/master/L13/Evaluation.pptx)

* **Lecture 14** - Lazy programming in Haskell:
  * Tic-Tac-Toe Slides: [source](https://github.com/pdmatei/pp2020/blob/master/L14/xzero.pptx)
  * Simple Lazy Example: [source](https://github.com/pdmatei/pp2020/blob/master/L14/lazy-example.hs)
  * Tic-Tac-Toe - lazy construction of a game tree: [source](https://github.com/pdmatei/pp2020/blob/master/L14/xandzero.hs)

* **Lecture 15** - Introduction in Prolog:
  * Introductory slides: [source](https://github.com/pdmatei/pp2020/blob/master/L15/Prolog-intro.pptx)
  * Examples: [source](https://github.com/pdmatei/pp2020/blob/master/L15/intro.pl)


