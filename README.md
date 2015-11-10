# haskell_fun
Learning Haskell




---------------------------------------


**Chebyshev.hs -- **
This is implementation of my Elliptic Curve / Birch Swinnerton-Dyer experiment, but in Haskell. This is much faster than the Python one. What took python hours took minutes in Haskell. Having to use functions forces you to not choose the easiest, most blunt solutions all of whose runtimes can add up. Haskell really promotes abstract and critical thinking a lot more than the other languages I'm familiar with. Perhaps working in Haskell will help me blend my mathematical thinking with algorithmic thinking.

The way it is implemented here allows for more chebyshev type functions to be explored. For instance, we can look at the case of the prime number theorem relatively simply. Perhaps we could look at it for conics or maybe larger abelian varieties like jacobians of hyperelliptic curves.

I have also attached a PDF giving a proof of the Explicit Formula for Elliptic Curves. It's definitely only something that is fun to think about. The original conjecture for the BSD was done in terms of the sizes of the curve mod primes, my formulation uses the modular coefficients (which are smaller) to restate the same thing in a way reminiscent of the Prime Number Theorem. The idea is that if I have a curve with a large rank then it should be, on average, big over finite fields. The modular coefficient a_q measures the discrepancy that the size of E is  in the field with q elements with it's expected size of q+1. Hecke showed that |a_q|<=2sqrt(q), so if the curve is large, a_q should be closer to 2sqrt(q) more often. This is essentially the statement of the BSD Conjecture




-----------------------------------------------

**group.hs -- **
Here I'm playing with groups using Haskell. Still a lot of work to be done on this one, but I have managed to implement the Conic Section group law over finite fields in a much slicker way than with python. My goal is to make a new haskell implementation of a group that is derived form either conics or elliptic curves. The type will be made up of the defining equation of the curve, along with the set of points on the curve, and then we could use a group law to make a Data.Group object in Haskell. 

One problem is that I need to use projective coordinates for Elliptic Curves and affine coordinates for Conics, and I forgot that as I was writing it up. I may restart from scratch and be sure to make the program flexible enough to do both cases. But I'm happy for now with the Conic-Group Law being functional. There's a lot of interesting potential for working with groups in Haskell.
