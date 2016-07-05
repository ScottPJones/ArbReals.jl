#=
   The mag type used by Arb (fredrikj.net/arb/mag.html)
   see also (https://github.com/Nemocas/Nemo.jl/blob/master/src/arb/ArbTypes.jl)
   see also (https://github.com/thofma/Hecke.jl/blob/master/src/Misc/mag.jl)
=#

type ArbMag
    exponent::Int
    mantissa::UInt64
end

ArbMag{T<:Union{Int64,Int32}}(exponent::Int, mantissa::T) =
    ArbMag(exponent, mantissa % UInt64)

function release{T<:ArbMag}(x::T)
    ccall(@libarb(mag_clear), Void, (Ptr{T}, ), &x)
    return nothing
end

function init{T<:ArbMag}(::Type{T})
    z = ArbMag(zero(Int), zero(UInt64))
    ccall(@libarb(mag_init), Void, (Ptr{T}, ), &z)
    finalizer(z, release)
    return z
end

ArbMag() = init(ArbMag)

# define hash so other things work
const hash_arbmag_lo = (UInt === UInt64) ? 0x29f934c433d9a758 : 0x2578e2ce
const hash_0_arbmag_lo = hash(zero(UInt), hash_arbmag_lo)
if UInt===UInt64
   hash(z::ArbMag, h::UInt) = hash( reinterpret(UInt64, z.exponent), z.mantissa )
else
   hash(z::ArbMag, h::UInt) = hash( reinterpret(UInt32, z.exponent) % UInt64, z.mantissa )
end

# conversions

# convert to ArbMag

Error_MagIsNegative() = throw(ErrorException("Magnitudes must be nonnegative."))

function convert(::Type{ArbMag}, x::Float64)
    signbit(x) && Error_MagIsNegative()
    z = ArbMag()
    ccall(@libarb(mag_set_d), Void, (Ptr{ArbMag}, Ptr{Float64}), &z, &x)
    return z
end
convert(::Type{ArbMag}, x::Float32) = convert(ArbMag, convert(Float64, x))
convert(::Type{ArbMag}, x::Float16) = convert(ArbMag, convert(Float64, x))

#=
   convertHi returns upper bound of value
   convertLo returns lower bound of value
=#

function convertHi(::Type{ArbMag}, x::UInt64)
    z = ArbMag()
    ccall(@libarb(mag_set_ui), Void, (Ptr{ArbMag}, Ptr{UInt64}), &z, &x)
    return z
end
function convertLo(::Type{ArbMag}, x::UInt64)
    z = ArbMag()
    ccall(@libarb(mag_set_ui_lower), Void, (Ptr{ArbMag}, Ptr{UInt64}), &z, &x)
    return z
end
for T in (:UInt128, :UInt32, :UInt16, :UInt8)
    @eval convertHi(::Type{ArbMag}, x::($T)) = convertHi(ArbMag, convert(UInt64, x))
    @eval convertLo(::Type{ArbMag}, x::($T)) = convertLo(ArbMag, convert(UInt64, x))
end    

function convert(::Type{ArbMag}, x::Int64)
    signbit(x) && Error_MagIsNegative()
    return convert(ArbMag, reinterpret(UInt64, x))
end
for T in (:Int128, :Int32, :Int16, :Int8)
    @eval convert(::Type{ArbMag}, x::($T))  = convert(ArbMag, convert(Int64, x))
end    



#convert from ArbMag

function convert(::Type{Float64}, x::ArbMag)
    z = ccall(@libarb(mag_get_d), Float64, (Ptr{ArbMag}, ), &x)
    return z
end
function convert(::Type{Float32}, x::ArbMag)
    z = convert(Float64, x)
    convert(Float32, z)
    return z
end


# promotions

for T in (:UInt, :Int, :Float32, :Float64)
    @eval promote_rule(::Type{ArbMag}, ::Type{$T}) = ArbMag
end

# string, show
#
function string(x::ArbMag)
    fp = convert(Float64, x)
    return string(fp)
end

function stringcompact(x::ArbMag)
    fp = convert(Float32, convert(Float64, x))
    return string(fp)
end

function show(io::IO, x::ArbMag)
    s = string(x)
    print(io, s)
    return nothing
end

function showcompact(io::IO, x::ArbMag)
    s = stringcompact(x)
    print(io, s)
    return nothing
end
