#=
   The arb type used by Arb (fredrikj.net/arb/arb.html)
   see also (https://github.com/Nemocas/Nemo.jl/blob/master/src/arb/ArbTypes.jl)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/arb2.jl)
=#


# parameter P is the precision in bits
type ArbArb{P}
    exponent::Int
    size::UInt64
    mantissa1::Int64
    mantissa2::Int64
    radiusExp::Int
    radiusMan::UInt64
end

# working precision for Arb
const ArbArbPrecision = [116,]
precision(::Type{ArbArb}) = ArbArbPrecision[1]

precision{P}(::Type{ArbArb{P}}) = P
precision{P}(x::ArbArb{P}) = P

function setprecision(::Type{ArbArb}, n::Int)
    n = min(24, n)
    ArbArfPrecision[1] = n
    ArbArbPrecision[1] = n
    return n
end


function release{P}(x::ArbArb{P})
    ccall(@libarb(arb_clear), Void, (Ptr{ArbArb{P}}, ), &x)
    return nothing
end

function init{P}(::Type{ArbArb{P}})
    z = ArbArb{P}(zero(Int), zero(UInt64), zero(Int64), zero(Int64), zero(Int), zero(UInt64))
    ccall(@libarb(arb_init), Void, (Ptr{ArbArb{P}}, ), &z)
    finalizer(z, release)
    return z
end

ArbArb() = init(ArbArbprecision(ArbArb))


# a type specific hash function helps the type to 'just work'
const hash_arbarb_lo = (UInt === UInt64) ? 0x37e642589da3416a : 0x5d46a6b4
const hash_0_arbarb_lo = hash(zero(UInt), hash_arbarb_lo)
hash{P}(z::ArbArb{P}, h::UInt) =
    hash(reinterpret(UInt,z.significand1)$reinterpret(UInt,z.exponent)$reinterpret(UInt,z.radiusExp),
         (h $ hash(reinterpret(UInt,z.significand2)$(~reinterpret(UInt,P)), hash_arbarb_lo)
            $ hash_0_arbarb_lo))


# representation: midpoint, radius, [lower|upper]bound, bounds

function midpoint{P}(x::ArbArb{P})
    z = init(ArbArb{P})
    ccall(@libarb(arb_get_mid_arb), Void, (Ptr{ArbArb}, Ptr{ArbArb}), &z, &x)
    return z
end

function radius{P}(x::ArbArb{P})
    z = init(ArbArb{P})
    ccall(@libarb(arb_get_rad_arb), Void, (Ptr{ArbArb}, Ptr{ArbArb}), &z, &x)
    return z
end


function upperbound{P}(x::ArbArb{P})
    a = ArbArf{P}(0,0,0,0)
    ccall(@libarb(arf_init), Void, (Ptr{ArbArf{P}},), &a)
    z = init(ArbArb{P})
    ccall(@libarb(arb_get_ubound_arf), Void, (Ptr{ArbArf}, Ptr{ArbArb}, Int), &a, &x, P)
    ccall(@libarb(arb_set_arf), Void, (Ptr{ArbArb}, Ptr{ArbArf}), &z, &a)
    ccall(@libarb(arf_clear), Void, (Ptr{ArbArf{P}},), &a)
    z
end

function lowerbound{P}(x::ArbArb{P})
    a = ArbArf{P}(0,0,0,0)
    ccall(@libarb(arf_init), Void, (Ptr{ArbArf{P}},), &a)
    z = init(ArbArb{P})
    ccall(@libarb(arb_get_lbound_arf), Void, (Ptr{ArbArf}, Ptr{ArbArb}, Int), &a, &x, P)
    ccall(@libarb(arb_set_arf), Void, (Ptr{ArbArb}, Ptr{ArbArf}), &z, &a)
    ccall(@libarb(arf_clear), Void, (Ptr{ArbArf{P}},), &a)
    z
end

bounds{P}(x::ArbArb{P}) = ( lowerbound(x), upperbound(x) )

# ArbArb <-> ArbArf, ArbMag

function midpoint_radius{P}(x::ArbArb{P})
    m = init(ArbArf{P})
    r = init(ArbMag)
    m.exponent = x.exponent
    m.size = x.size
    m.mantissa1 = x.mantissa1
    m.mantissa2 = x.mantissa2
    r.exponent = x.radiusExp
    r.mantissa = x.radiusMan
    return (m,r)
end

function midpoint_radius{P}(midpoint::ArbArf{P}, radius::ArbMag)
    z = init(ArbArb{P})
    z.exponent  = midpoint.exponent
    z.size      = midpoint.size
    z.mantissa1 = midpoint.mantissa1
    z.mantissa2 = midpoint.mantissa2
    z.radiusExp = radius.exponent
    z.radiusMan = radius.mantissa
    return z
end

function midpoint_radius(midpoint::Float64, radius::Float64)
    p = precision(ArbArb)
    m = convert(ArbArf{p}, midpoint)
    r = convert(ArbMag, radius)
    return midpoint_radius(m,r)
end


# conversions

# convert to ArbArb

function convert{P}(::Type{ArbArb{P}}, x::ArbArf{P})
    z = init(ArbArb{P})
    z.exponent  = x.exponent
    z.size      = x.size
    z.mantissa1 = x.mantissa1
    z.mantissa2 = x.mantissa2
    return z
end

# convert from ArbArb

function convert{P}(::Type{ArbArf{P}}, x::ArbArb{P})
    z = init(ArbArf{P})
    z.exponent  = x.exponent
    z.size      = x.size
    z.mantissa1 = x.mantissa1
    z.mantissa2 = x.mantissa2
    return z
end



#interconvert ArbArb{P} with ArbArb{Q}

convert{P}(::Type{ArbArb{P}}, a::ArbArb{P}) = a
function convert{P,Q}(::Type{ArbArb{Q}}, a::ArbArb{P})
    if (Q < P)
        a = round(a, Q, 2)
    end

    z = init(ArbArb{Q})
    z.exponent  = a.exponent
    z.size      = a.size
    z.mantissa1 = a.mantissa1
    z.mantissa2 = a.mantissa2
    z.radiusExp = a.radiusExp
    z.radiusMan = a.radiusMan

    return z
end


# rounding codes
# see https://github.com/fredrik-johansson/arb/blob/master/arf.h
# and https://github.com/fredrik-johansson/arb/blob/master/fmpr.h
const ArbRoundDown    = ArfRoundDown     # Int32(0)
const ArbRoundUp      = ArfRoundUp       # Int32(1)
const ArbRoundFloor   = ArfRoundFloor    # Int32(2)
const ArbRoundCeil    = ArfRoundCeil     # Int32(3)
const ArbRoundNearest = ArfRoundNearest  # Int32(4)

# string flag codes
const StrDefault  = UInt32(0)
const StrMore     = UInt32(1)
const StrNoRadius = UInt32(2)
const StrCondense = UInt32(16)

# string conversions

function convert{P}(::Type{ArbArb{P}}, x::String)
    z = init(ArbArb{P})
    ccall(@libarb(arb_set_str), Void, (Ptr{ArbArb{P}}, Ptr{UInt8}, Int), &z, x, P)
    return z
end
convert(::Type{ArbArb}, x::String) = convert(ArbArb{precision(ArbArb)}, x)


function String{P}(x::ArbArb{P}, ndigits::Int, flags::UInt)
   n = max(1,min(abs(ndigits), floor(Int, P*0.3010299956639811952137)))
   cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbArb{P}}, Int, UInt), &x, n, flags)
   s = unsafe_string(cstr)
   ccall(@libflint(flint_free), Void, (Ptr{UInt8},), cstr)
   return s
end

function String{P}(x::ArbArb{P}, flags::UInt)
   n = floor(Int, P*0.3010299956639811952137)
   cstr = ccall(@libarb(arb_get_str), Ptr{UInt8}, (Ptr{ArbArb{P}}, Int, UInt), &x, n, flags)
   s = unsafe_string(cstr)
   ccall(@libflint(flint_free), Void, (Ptr{UInt8},), cstr)
   s
end


function string{P}(x::ArbArb{P}, ndigits::Int)
   flags = isexact(x) ? UInt(3) : UInt(1) # RoundNearest, many digits
   s = String(x, ndigits, flags)
   return s
end

function string{P}(x::ArbArb{P})
   flags = isexact(x) ? UInt(3) : UInt(1) # RoundNearest, many digits
   s = String(x, 15, flags) # RoundNearest,
   return s
end

function stringall{P}(x::ArbArb{P})
   flags = isexact(x) ? UInt(3) : UInt(1) # RoundNearest, many digits
   s = String(x, flags)
   return s
end
function stringcompact{P}(x::ArbArb{P})
   flags = isexact(x) ? UInt(2) : UInt(0) # RoundNearest, few digits
   s = String(x, 8, flags)
   return s
end

function string_midpoint{P}(x::ArbArb{P})
   s = string(midpoint(x))
   return s
end
function stringcompact_midpoint{P}(x::ArbArb{P})
   s = stringcompact(midpoint(x))
   return s
end
function stringall_midpoint{P}(x::ArbArb{P})
   s = stringall(midpoint(x))
   return s
end

function string_radius{P}(x::ArbArb{P})
   s = string(radius(x))
   return s
end
function stringcompact_radius{P}(x::ArbArb{P})
   s = stringcompact(radius(x))
   return s
end
function stringall_radius{P}(x::ArbArb{P})
   s = stringall(radius(x))
   return s
end

function show{P}(io::IO, x::ArbArb{P})
    s = string(x)
    print(io, s)
end

function showcompact{P}(io::IO, x::ArbArb{P})
    s = stringcompact(x)
    print(io, s)
end

function showall{P}(io::IO, x::ArbArb{P})
    s = stringall(x)
    print(io, s)
end
