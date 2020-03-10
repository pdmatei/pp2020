{-# LANGUAGE TypeSynonymInstances,
             FlexibleInstances #-}

{-
    We represent a matrix of integers as a list of rows, each
    row being a list of integers.

    The keyword "type" is useful to create type aliases (similar to typedef in C)
    and make type signatures more legible:

-}

type Matrix = [[Integer]]

{-
    Ex 1. Write a function which takes a string and parses it to a matrix.
          Rows are separated by '\n' and columns, by ' '.

    Example:
    parsem "1 2\n3 4\n" = [[1,2], [3,4]]
-}

-- parsem :: String -> Matrix

{-
    Ex 2. Write a function that converts a matrix to a string encoded
          as illustrated in the previous exercise.

          Hint: Start by converting a line to string
          Hint: Test and use the function show

-}

-- toString :: Matrix -> String

{-
    Ex 3. Add to your code, the function below.
    Test it.
-}

-- displaymat = putStrLn . toString

{-
    Ex 4. Write a function that computes the scalar product with
          an integer
-}

--vprod :: Integer -> Matrix -> Matrix


m1 = [[1,2],[3,4]]
m2 = [[5,6],[7,8]]

{-  Ex 5. Write a function which adjoins two matrices by extending rows.
    Example:  1 2   `hjoin` 5 6   =   1 2 5 6
              3 4           7 8       3 4 7 8
-}

--hjoin :: Matrix -> Matrix -> Matrix

{-  Ex 6. Write a function which adjoins two matrices by adding new rows 
    Example:  1 2   `vjoin` 5 6   =   1 2 
              3 4           7 8       3 4 
                                      5 6
                                      7 8 
-}

--vjoin :: Matrix -> Matrix -> Matrix

{-  Ex 7. Write a function which adds two matrices -}

--msum :: Matrix -> Matrix -> Matrix

{- Ex 8. Write a function which computes the transposition of a matrix 
   Example:
             1 2    tr    1 3
             3 4   ---->  2 4
-}
--tr :: [[a]] -> [[a]]

{- 
    Ex 9. Write a function which computes the vectorial product of two
          matrices.

          Hint: start by writing a function which computes
          aij for a given line i and column j (both represented as lists)

          Hint: extend the function so that it computes line 1 of the
                product matrix
-}

--mprod :: Matrix -> Matrix -> Matrix

{-
   We can represent images as matrices of pixels. In our example a pixel
   will be represented as a char.

-}
type Image = [[Char]]

l1="        ***** **            ***** **    "
l2="     ******  ****        ******  ****   "
l3="    **   *  *  ***      **   *  *  ***  "
l4="   *    *  *    ***    *    *  *    *** "
l5="       *  *      **        *  *      ** "
l6="      ** **      **       ** **      ** "
l7="      ** **      **       ** **      ** "
l8="    **** **      *      **** **      *  "
l9="   * *** **     *      * *** **     *   "
l10="      ** *******          ** *******    "
l11="      ** ******           ** ******     "
l12="      ** **               ** **         "
l13="      ** **               ** **         "
l14="      ** **               ** **         "
l15=" **   ** **          **   ** **         "
l16="***   *  *          ***   *  *          "
l17=" ***    *            ***    *           "
l18="  ******              ******            "
l19="    ***                 ***             "

logo = [l1,l2,l3,l4,l5,l6,l7,l8,l9,l10,l11,l12,l13,l14,l15,l16,l17,l18,l19]

{- implement an image-displaying function: -}
--toStringImg :: Image -> String

--displaym = putStrLn . toStringImg


{-
   Implement a function which flips an image horizontally:
-}
--flipH :: Image -> Image 

{-
   Implement a function which flips an image vertically:
-}
--flipV :: Image -> Image 

{-
   Implement a function which rotates an image 90grd clockwise
-}
--rotate90r :: Image -> Image

{-
   Implement a function which rotates an image -90grd clockwise
-}
--rotate90l :: Image -> Image

{-
   Implement a function which returns a diamond of a specified height.
   Example:
                          *
                         ***
   diamond 3 =          *****
                         ***
                          *

                         *
   diamond 2 =          ***
                         *
   
   First write a function which produces the first half, then build the lower part
-}
-- diamond :: Integer -> Image 

{-
   Implement a function with takes two images of the same dimensions. 
   The second image is a mask. 

   The output will be another image in which all pixels from the first image
   overlaying with a '*'-pixel from the mask will be displayed. All others will be
   deleted (made equal to ' ').
   
   Example:
   
   ******                ****     ****
   **  **   `overlay`   ******   **  ** 
   **  **                ****     *  *
   ******                 **       **
-}

--overlay :: Image -> Image -> Image

