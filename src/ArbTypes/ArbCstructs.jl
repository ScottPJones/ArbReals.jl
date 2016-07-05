#=
    types that mirror the memory layout of C structs used in Arb
    
   The mag type used by Arb (fredrikj.net/arb/mag.html)
   The arf type used by Arb (fredrikj.net/arb/arf.html)
   The arb type used by Arb (fredrikj.net/arb/arb.html)
   see also (https://github.com/Nemocas/Nemo.jl/blob/master/src/arb/ArbTypes.jl)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/mag.jl)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/arf.jl)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/arb.jl)
=#


type ArbMag
    radiusExp::Int
    radiusMan::UInt64
end


# parameter P is the precision in bits
type ArbArf{P}
    exponent::Int
    size::UInt64
    mantissa1::Int64
    mantissa2::Int64
end


# parameter P is the precision in bits
type ArbArb{P}
    exponent::Int
    size::UInt64
    mantissa1::Int64
    mantissa2::Int64
    radiusExp::Int
    radiusMan::UInt64
end
