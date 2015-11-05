# haskell_fun
Learning Haskell




---------------------------------------
So far the only think I've done is implement the calculations for the BSD experiment in Haskell. But I can tell right away that it's sooo much easier to work with than python. It works more along the lines of how I have been trained to think in math. Everything is a function, so why not have a language built around functions? Still getting used to all the syntax and types and things.

This implementation is much faster than the Python one. What took python hours took minutes in Haskell. Having to use functions forces you to not choose the easiest, most blunt solutions all of whose runtimes can add up. Haskell really promotes abstract and critical thinking a lot more than the other languages I'm familiar with. Perhaps working in Haskell will help me blend my mathematical thinking with algorithmic thinking.

The way it is implemented here allows for more chebyshev type functions to be explored. For instance, we can look at the case of the prime number theorem relatively simply. Perhaps we could look at it for conics or maybe larger abelian varieties like jacobians of hyperelliptic curves.

----------------------------------------

It's written as a comment in the program, but to test the BSD idea do the following:

*  1.) Know an upper bound Max and seive all the primes up to Max
       using 'let p = seive Max'

*   2.) Declare your curve as 'let e = 'Curve a b'
 
*  3.) Seive the curve by using 'let pe = seiveEllCurve e p'
 
*  4.) Get a list of all coeffs to test against using 'let all = allCoefs Max pe'
     *Note - All of these steps are used to precompile all the hard to compute stuff. Maybe do file I/O?
 
*  5.) Setup the function to test by 'let test = pntEllCurve all'
 
*  6.) You may then run chebCurve := cheby p test x for x <= Max
 
*  7.) To compare ratios, you can compare it to fnc = pow r by cmpr chebCurve fnc x

I have also attached a PDF giving a proof of the Explicit Formula for Elliptic Curves. It's definitely nothing work publishing or anything, but is fun to think about. The original BSD was done in terms of the sizes of the curve mod primes, this uses the modular coefficients (which are smaller) to restate the same thing in a way reminiscent of the Prime Number Theorem. The idea is that if I have a curve with a large rank then it should be, on average, big over finite fields. The modular coefficient a_q measures the discrepancy that the size of E is  in the field with q elements with it's expected size of q+1. Hecke showed that |a_q|<=2sqrt(q), so if the curve is large, a_q should be closer to 2sqrt(q) more often. This is essentially the statement of the BSD Conjecture
