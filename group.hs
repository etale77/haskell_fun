import Data.Monoid
import Data.Set
import Data.List

class (Monoid m, Eq m) => Group m where
    invert :: m -> m

data Curve = Pell Int Int | Ell Int Int Int -- (Pell d N) creates the conic x^2-dy^2=4 mod N with origin (2,0)
-- (Ell a b N) creates y^2=x^3+ax+b mod N

data CurveSet = PellSet Curve [(Int, Int)] | EllSet Curve [(Int,Int,Int)]

data Line = Line Int Int Int Int -- L = (Line a b c n) ax+by+c=0 mod n


instance (Num a, Eq a) => Group (Sum a) where
    invert (Sum x) = Sum (-x)

zAction :: (Group a) => a -> Int -> a
zAction x n 
        | x == mempty = mempty 
        | n == 0 = mempty
        | n < 0 = zAction (invert x) (-n)
        | n `mod ` 2 == 0 = zAction (mappend x x) (n `div` 2)
        | otherwise = mappend x (zAction (mappend x x) ((n-1) `div` 2))


--Things Specific to curves
-------------------------------------------------
isOn :: Curve -> Int -> Int -> Bool
isOn (Pell d n) x y
      | (x^2-d*y^2 - 4) `mod` n == 0 = True
      | otherwise = False
isOn (Ell a b n) x y
      | (y^2-x^3-a*x-b) `mod` n == 0 = True
      | otherwise = False

coords :: Curve -> [(Int,Int)] -- Ell returns values to check against y, Pell returns values to check against x
coords (Ell a b n) = [(x,z) | x <- [0..n-1], let z = (x^3 + a*x + b) `mod` n, ((eulerCrit z n ) == 1) || ((eulerCrit z n) == 0)  ]
coords (Pell d n) = [(z,y) | y <- [0..n-1], let z = (4+d*y^2) `mod` n, ((eulerCrit z n) == 1) || ((eulerCrit z n) == 0)  ]

makeCurve :: Curve -> [(Int, Int)]
makeCurve (Ell a b n) = [(x,y)| y <- [0..n-1], (x,z) <- el, (y^2 - z) `mod` n ==0]  where el = coords (Ell a b n)
makeCurve (Pell d n) = [(x,y)| x <- [0..n-1], (z, y) <- pl, (x^2 - z) `mod` n ==0]  where pl = coords (Pell d n)

makeLine :: Line -> [(Int, Int)]
makeLine (Line r s t n)
                | r == 0 = [(x, ((-t)*(s `modInv` n)) `mod` n) | x<-[0..n-1]]
                | s == 0 = [(((-t)*(r `modInv` n)) `mod` n, y) | y<-[0..n-1]]
                | otherwise = [(x, (m*x+b) `mod` n) | x <- [0..n-1]] 
                where a = (s `modInv` n) 
                      m = (((-r)*a) `mod` n) 
                      b = (((-t)*a) `mod` n)

--This does not return multiplicities!
findAllIntsct :: Curve -> Line -> [(Int, Int)]
findAllIntsct c l = (makeCurve c) `intersect` (makeLine l)         

--We now assume that n is an odd prime, to count multiplicities
bezoutInt :: Curve -> Line -> [(Int, Int)]
bezoutInt (Pell d p) (Line r s t q)
           | ((length(i) == 2) || (length(i) == 0)) = i
           | otherwise = i ++ [i !! 0]
           where i = findAllIntsct (Pell d p) (Line r s t q)
bezoutInt (Ell a b p) (Line r s t q)
           | ((length(i) == 3) || (length(i) ==0)) = i
           | ((length(i) == 1) && (s /= 0))  =  i ++ [i !! 0, i !! 0]
           | length(i) == 1 = i ++ [i !! 0] -- The other point is at infinity
           | s == 0 = i -- The final point is at infinity
           | otherwise = i ++ [(x,y) | (x,y) <- i, x == ((b-t^2)*(modInv (s^2) p))-((fst(i!!0))+(fst(i!!1)))]
           where i = findAllIntsct (Ell a b p) (Line r s t q)

parLine :: Line -> (Int,Int) -> Line
parLine (Line r s t n) (a,b) = (Line r s (-(r*a+s*b)) n)

ptLine :: (Int, Int) -> (Int, Int) -> Int -> Line
ptLine (a,b) (c,d) n = (Line (b-d) (c-a) (b*(a-c)+a*(d-b)) n )

tanLine :: Curve -> (Int, Int) -> Line
tanLine (Pell d n) (x,y) = (Line (x) (-d*y) (-y*x+x*d*y) n)
tanLine (Ell a b n) (x,y) = (Line (3*(x^2)+a) (-2*y) (2*(y^2)-(3*(x^3)+a*x)) n)

--Tangent line shifted to another point
shTanLine :: Curve -> (Int, Int) -> (Int, Int) -> Line
shTanLine c (x,y) (a,b) = parLine (tanLine c (x,y)) (a,b)


--Gives the line that is parallel to x y through z
ptParLine :: (Int,Int) -> (Int, Int) -> (Int,Int) -> Int -> Line
ptParLine x y z n= parLine (ptLine x y n) z

addC :: Curve -> (Int,Int) -> (Int, Int) -> (Int, Int)
addC (Pell d p) s t 
     | s==t = (removeOne (2,0) (bezoutInt (Pell d p) (shTanLine (Pell d p) s (2,0)))) !! 0
     |otherwise = (removeOne (2,0) (bezoutInt (Pell d p) (ptParLine s t (2,0) p))) !! 0 


curveToSet :: Curve -> CurveSet
curveToSet (Pell d n) = (PellSet (Pell d n) makeCurve (Pell d n))
curveToSet (Ell a b n) = (EllSet (Ell a b n) ((0,0,0) :[(x,y,1) | (x,y)<-makeCurve (Ell a b n)]))


--Number Theory stuff
----------------------------------------------------

expModN :: Int -> Int -> Int -> Int
expModN a x n 
        | a `mod` n == 0 = 0
        | x == 0 = 1
        | x == 1 = a `mod` n
        | x == 2 = (a*a) `mod` n
        | otherwise = ((expModN a (x `mod` 2) n ) * (expModN ((a*a) `mod` n) (x `div` 2) n )) `mod` n

eulerCrit :: Int -> Int -> Int
eulerCrit a p = expModN a ((p-1) `div` 2) p

modInv :: Int -> Int -> Int --We'll stick with brute force for now
modInv a n = s !! 0
      where s = [x | x<-[0..n-1], a*x `mod` n == 1]

removeOne :: (Eq a) => a -> [a] -> [a]
removeOne _ [] = []
removeOne y (x:xs) 
          | y == x = xs
          | otherwise = x : removeOne y xs
