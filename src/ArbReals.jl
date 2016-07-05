module ArbReals

import Base: hash, convert, promote_rule,
    String, string, show, showcompact, showall,
    copy, deepcopy,
    precision, setprecision,
    isnan, isinf, isfinite, zero, one,
    isequal, isless, (==), (!=), (<), (<=), (>=), (>),
    abs, signbit, sign, copysign, flipsign,
    round, floor, ceil, trunc,
    (+), (-), (*), (/), muladd, hypot, sqrt, inv,
    lowerbound, upperbound,
    exp, expm1, log, log1p, log2, log10,
    sin, sinpi, cos, cospi, tan, cot,
    asin, acos, atan,
    sinh, cosh, tanh, coth,
    asinh, acosh, atanh,
    factorial, gamma, lgamma, digamma, sinc, zeta

export stringcompact,
    bounds, midpoint, radius, midpoint_radius,
    string_midpoint, stringall, lowerbound, upperbound,
    two, three, four, # use like zero(ArbArb)
    isnan, isinf, isfinite,
    iszero, notzero, nonzero, isone, notone,
    isexact, notexact, isinteger, notinteger,
    ispositive, notpositive, isnegative, notnegative,
    notequal, overlap, donotoverlap,
    contains, doesnotcontain, iscontainedby, isnotcontainedby,
    addmul, submul, mulsub, invsqrt, pow, root,
    sincos, sincospi, sinhcosh,
    rgamma, doublefactorial, risingfactorial,
    polylog, agm

metatype_file = string(Pkg.dir("ArbReals"),"/src/MetaType/metatypes.jl"))
if !isfile(metatype_file) || filesize(metatype_file) == 0
    include("MetaType/protogenesis.jl")
    protogenerate(metatype_file)
end
include("MetaType/metatypes.jl")

include("NemoLibs.jl")  # ensure needed C libraries

include("ArbTypes/ArbMag.jl")
include("ArbTypes/ArbArf.jl")
include("ArbTypes/ArbArb.jl")

include("ArbWrap/support.jl")
include("ArbWrap/numsupport.jl")
include("ArbWrap/predicates.jl")

include("ArbWrap/arithmetic.jl")
include("ArbWrap/elementary.jl")
include("ArbWrap/special.jl")

end # module ArbReals
