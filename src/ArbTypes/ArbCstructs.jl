#=
    types that mirror the memory layout of C structs used in Arb
=#


type ArbMag
    exponent::Int
    mantissa::UInt64
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
