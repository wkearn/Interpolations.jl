module Interpolations

export
    interpolate
    # see the following files for further exports:
    # b-splines/b-splines.jl

abstract InterpolationType
abstract AbstractInterpolation{T,N,IT<:InterpolationType} <: AbstractArray{T,N}
abstract Extrapolation{T,N} <: AbstractArray{T,N}

size(itp::AbstractInterpolation) = tuple([size(itp,i) for i in 1:ndims(itp)]...)

include("b-splines/b-splines.jl")

#include("extrapolation.jl")

end
