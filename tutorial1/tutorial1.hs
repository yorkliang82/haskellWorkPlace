--tutor TUDOR FERARIV TFERARIV@YAHOO
-- Informatics 1 - Functional Programming
-- Tutorial 1
--
-- Solutions
--
-- Remember: there are many possible solutions, and if your solution produces
-- the right results, then it is (most likely) correct. However, if your code
-- looks far more complicated than these sample solutions, then you're probably
-- making things too difficult for yourself---try to keep it simple!

import Data.Char
import Data.List
import Test.QuickCheck
import Control.Monad (guard)


-- 1. halveEvens

-- List-comprehension version
halveEvens :: [Int] -> [Int]
halveEvens xs = [x `div` 2 | x <- xs, x `mod` 2 == 0]


-- This is for testing only. Do not try to understand this (yet).
halveEvensReference :: [Int] -> [Int]
halveEvensReference = (>>= \x -> guard (x `mod` 2 == 0) >>= \_ -> return $ x `div` 2)


-- -- Mutual test
prop_halveEvens :: [Int] -> Bool
prop_halveEvens xs = halveEvens xs == halveEvensReference xs


-- 2. inRange

-- List-comprehension version
inRange :: Int -> Int -> [Int] -> [Int]
inRange lo hi xs = [x | x <- xs, x <= hi, x >= lo]



-- 3. countPositives: sum up all the positive numbers in a list

-- List-comprehension version
countPositives :: [Int] -> Int
countPositives list = length [x | x <- list, x > 0]


-- 4. pennypincher

-- List-comprehension version.
discount :: Int -> Int
discount price = round (fromIntegral price * 0.9)

pennypincher :: [Int] -> Int
pennypincher prices = sum [discount x | x <- prices, discount x <= 19900]

-- -- And the test itself
prop_pennypincher :: [Int] -> Bool
prop_pennypincher xs = pennypincher xs <= sum [x | x <- xs, x > 0]



-- 5. multDigits

-- List-comprehension version
{-a library function to determine
if a character is a digit(isDigit),
 one to convert a digit to an integer(digitToInt),
and one to do the multiplication(product).
-}
multDigits :: String -> Int
multDigits str = product [digitToInt x | x <- str, isDigit x]

countDigits :: String -> Int
countDigits str = length [42 | x <- str, isDigit x]

prop_multDigits :: String -> Bool
prop_multDigits xs = multDigits xs <= 9 ^ countDigits xs


-- 6. capitalise

-- List-comprehension version
capitalise :: String -> String
capitalise [] = []
capitalise (x:xs) = toUpper x : [toLower y | y <- xs]


-- 7. title
captitalisel :: String -> String
captitalisel x
  |length x < 4 = lowercase x
  |otherwise = capitalise x

lowercase :: String -> String
lowercase xs = [toLower y | y <- xs]

-- List-comprehension version
title :: [String] -> [String]
title (x:xs) = capitalise x : [captitalisel y | y <- xs]


-- 8. signs

sign :: Int -> Char
sign i
  |i >= 1 && i <= 9 = '+'
  |i == 0           = '0'
  |i <= -1 && i >= -9 = '-'
  |otherwise = error ("wrong")



signs :: [Int] -> String
signs xs = [sign x | x <- xs, x >= -9 && x <= 9]

-- 9. score
{-
if it's a letter (isLetter)
--elem function
-}
isVowel :: Char -> Bool
isVowel x
  |x == 'a' || x == 'e' || x == 'i' || x == 'o' || x == 'u'|| x == 'A'|| x == 'E'|| x == 'I'|| x == 'O' || x == 'U' = True
  |otherwise = False

booToInt :: [Bool] -> Int
booToInt xs = sum [1 | x <- xs, x]

subTest :: Char -> [Bool]
subTest x = [isVowel x, isUpper x, isLetter x]

score :: Char -> Int
score x = booToInt (subTest x)


totalScore :: String -> Int
totalScore xs = product [score x | x <- xs, isLetter x]

prop_totalScore_positive :: String -> Bool
prop_totalScore_positive xs = totalScore xs >= 1


-- Optional Material

-- 10. crosswordFind

-- List-comprehension version
crosswordFind :: Char -> Int -> Int -> [String] -> [String]
crosswordFind letter pos len ws = [w | w <- ws, length w == len, (w!!pos) == letter]

-- 11. search

-- List-comprehension version
{-Write a function search :: String -> Char -> [Int] that returns the positions of 
all occurrences of the second argument in the first. For example
    search "Bookshop" ’o’  ==  [1,2,6]
    search "senselessness’s" ’s’  ==  [0,3,7,8,11,12,14]
Your definition should use a list comprehension. You may use the function 
zip :: [a] -> [b] -> [(a,b)], the function length :: [a] -> Int, and the term forms
 [m..n] and [m..].
  search "Bookshop" 'o'  ==  [1,2,6]
  search "senselessness’s" 's'  ==  [0,3,7,8,11,12,14]
    -}
search :: String -> Char -> [Int]
search str goal = [y | (x,y) <- (zip str [0..]), x == goal ]

-- Depending on the property you want to test, you might want to change the type signature
prop_search :: String -> Char -> Bool
prop_search str goal = length (search str goal) <= length str


-- 12. contains
{-contains "United Kingdom" "King"  ==  True
    contains "Appleton" "peon"  ==  False
    contains "" ""  ==  True-}
contains :: String -> String -> Bool
contains str substr
 |str == [] && substr == [] = True
 |str == [] = False
 |isPrefixOf substr str = True
 |otherwise = contains (tail str) substr

-- Depending on the property you want to test, you might want to change the type signature
prop_contains :: String -> String -> Bool
prop_contains str1 str2 = (contains str1 str2 && length str1 >= length str2) || (contains str1 str2 == False)
