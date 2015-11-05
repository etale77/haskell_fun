import Data.List
data EllCurve = Curve Int Int




--To test my formula follow the following steps:
{- 
   1.) Know an upper bound Max and seive all the primes up to Max
       using 'let p = seive Max'
   2.) Declare your curve as 'let e = 'Curve a b'
   3.) Seive the curve by using 'let pe = seiveEllCurve e p'
   4.) Get a list of all coeffs to test against using 'let all = allCoefs Max pe'
     *Note - All of these steps are used to precompile all the hard to compute stuff. Maybe do file I/O?
   5.) Setup the function to test by 'let test = pntEllCurve all'
   6.) You may then run chebCurve := cheby p test x for x <= Max
   7.) To compare ratios, you can compare it to fnc = pow r by cmpr chebCurve fnc x
-}


--Main Functions
------------------------------------------------------------------------

seive :: Int -> [Int]
seive x = primesOf [2..x] 
  where primesOf (p:xs) = p : primesOf [x | x <- xs, x `mod` p /= 0]
        primesOf [] = []

intExp :: Int -> Int -> Int -- find the largest m so that a^m<=x
intExp a x
       | a > x = 0
       | otherwise = 1 + (intExp a (x `div` a))

chebyPrime :: Int -> (Int -> Float) -> Int -> Float
chebyPrime  p f x = (-1)*(log (fromIntegral p)) * (sum [f y | y<-[1,2.. intExp p x]])

cheby :: [Int] -> (Int -> Int -> Float) -> Int -> Float
cheby a f x = sum [chebyPrime p (f p) x | p <- a, p <= x]

cmpr :: (Int -> Float) -> (Int -> Float) -> Int -> Float
cmpr f h x = (f x)/(h x)


--Functions for special cases
--------------------------------------------------------------------------

--Test the Prime Number Theorem
pnt :: Int -> Int -> Float
pnt _ _ = -1

--Find the element of [[Int]] whose first element is p
findp :: Int -> [[Int]] -> [Int]
findp p xs
      | xs == [] = []
      | (xs !! 0) !! 0 == p = xs !! 0
      | otherwise = findp p (tail xs)

--Function to test my conjecture for Elliptic Curves
pntEllCurve :: [[Int]] -> Int -> Int -> Float
pntEllCurve curveseive p n = fromIntegral ((findp p curveseive) !! n)


--Compare against this function, x^r
pow :: Float -> Int -> Float
pow r x = (fromIntegral x) ** r



-- Elliptic Curve Stuff
--------------------------------------------------------------------

xCoordsModN :: EllCurve -> Int -> [Int]
xCoordsModN (Curve a b) n = [(x^3 + a*x + b) `mod` n | x <- [0..n-1]]

expModN :: Int -> Int -> Int -> Int
expModN a x n 
        | a `mod` n == 0 = 0
        | x == 0 = 1
        | x == 1 = a `mod` n
        | x == 2 = (a*a) `mod` n
        | otherwise = ((expModN a (x `mod` 2) n ) * (expModN ((a*a) `mod` n) (x `div` 2) n )) `mod` n

eulerCrit :: Int -> Int -> Int
eulerCrit a p = expModN a ((p-1) `div` 2) p

numYforXModN :: Int -> Int -> Int
numYforXModN x p
        | lgdr == 0 = 1
        | lgdr == 1 = 2
        | otherwise = 0
        where lgdr = eulerCrit x p


--Uses the above functions to compute the number of points of E mod p
numPointsModp :: EllCurve -> Int -> Int
numPointsModp (Curve a b) p = 1 + sum [numYforXModN x p | x <- xCoordsModN (Curve a b) p ]

--For each prime in a list of primes, find the modular coeff of E mod p
--Despite the name, we need a seived prime list already
seiveEllCurve :: EllCurve -> [Int] -> [[Int]]
seiveEllCurve (Curve a b) primes = [[p, p + 1 - numPointsModp (Curve a b) p] | p<-primes]
 

--Given a list [p,a_p^n, ... a_p] find a_p^(n+1)
nextCoeffPow :: [Int] -> [Int]
nextCoeffPow (p : as)
            | (length as) == 1 = p : (((as !! 0)^2 - 2*p) : as)
            | otherwise = p : ((((last as) * (as !! 0 )) - (p * (as !! 1))):as)

coeffTillBd :: Int -> [Int] -> [Int]
coeffTillBd x (p : as) 
           | p^((length as)+1) > x = p : as
           | otherwise = coeffTillBd x (nextCoeffPow (p : as) )

--Here the second [Int] is a list of primes + their first coeff. We output the list of all mod coeffs of powers of primes <=x
allCoeffs :: Int -> [[Int]] -> [[Int]]
allCoeffs x as = [coeffTillBd x a | a<- as]



















