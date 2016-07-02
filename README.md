ArbReals
========

[![Join the chat at https://gitter.im/JuliaArbTypes/ArbReals.jl](https://badges.gitter.im/JuliaArbTypes/ArbReals.jl.svg)](https://gitter.im/JuliaArbTypes/ArbReals.jl?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

######real intervals with floating point bounds (uses the Arb library)


######&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;To participate, email [a moderator](https://github.com/JuliaArbTypes).  

  
  

>>  __visit the [Wiki](https://github.com/JuliaArbTypes/ArbReals.jl/wiki) to see current todos/thoughts/perspecitves__    
>>
>>  __use the whiteboards, participants have editing privileges__ 


*****





##Use (interval valued)
```julia
using ArbReals

five = midpoint_radius(5.0, 0.0)
# 5.00000000000000

tanh(five)
# [0.999909204262595 +/- 1.32e-16]

showall(ans)
# [0.9999092042625951312109904475344730 +/- 2.59e-35]

# ----- 

exp1interval = midpoint_radius( exp(1), eps(exp(1)) )
# [2.71828182845905 +/- 5.36e-15]

showall(exp1interval)
# [2.718281828459045090795598298427649 +/- 4.45e-16]

showcompact(exp1interval)
# [2.7182818 +/- 2.85e-8]

midpoint(exp1interval)
# 2.71828182845905

radius(exp1interval)
# 4.44089210677243e-16

a = agm(exp1interval, inv(exp1interval))
# [1.25683135663827 +/- 4.99e-15]

showall(ans)
# [1.256831356638274777545517650643936 +/- 2.06e-16]

showall(lowerbound(a))

showall(upperbound(a))
# 1.256831356638274982902060394630015

showall(lowerbound(ans))
# 1.256831356638274572188974906657858

```

### ToDo

1.  find a fast way to express (midpoint & radius) as a most informed *value*  
    \>\> See ArbFloats' string functions for a way that works, faster would
    help.

2.  make library's fetch & build independant of Nemo

3.  wrap and export standard interval predicates and operators

4.  define missing math functions (csc, sec, csch, sech, acsc, asec..)
