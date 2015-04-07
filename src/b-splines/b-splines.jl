export
    BSpline,

    GridRepresentation,
    OnCell,
    OnGrid,
    
    Degree,
    BoundaryCondition

abstract Degree{N}

abstract GridRepresentation
immutable OnGrid <: GridRepresentation end
immutable OnCell <: GridRepresentation end

abstract BoundaryCondition
immutable None <: BoundaryCondition end
immutable Flat <: BoundaryCondition end
immutable Line <: BoundaryCondition end
immutable Free <: BoundaryCondition end
immutable Periodic <: BoundaryCondition end
immutable Reflecting <: BoundaryCondition end
typealias Natural Line

immutable BSpline{D<:Degree,BC<:BoundaryCondition,GR<:GridRepresentation} end
BSpline{D<:Degree,BC<:BoundaryCondition,GR<:GridRepresentation}(d::Type{D}, bc::Type{BC}, gr::Type{GR}) = BSpline{D,BC,GR}()

type BSplineInterpolation{T,N,TCoefs,IT<:BSpline} <: AbstractInterpolation{T,N,IT}
    coefs::Array{TCoefs,N}
end
function BSplineInterpolation{N,TCoefs,TWeights<:Real,IT<:BSpline}(::Type{TWeights}, A::AbstractArray{TCoefs,N}, t::IT)
    isleaftype(IT) || error("The b-spline type must be a leaf type (was $IT)")
    isleaftype(TCoefs) || warn("For performance reasons, consider using an array of a concrete type (eltype(A) == $(eltype(A)))")

    c = one(TWeights)
    for _ in 2:N
        c *= c
    end
    T = typeof(c * one(TCoefs))

    BSpline{T,N,TCoefs,IT}(A)
end

interpolate{TWeights}(::Type{TWeights}, A, t::BSpline) = BSplineInterpolation(TWeights, prefilter(TWeights, A, t), T)
interpolate(A::AbstractArray, t::BSpline) = interpolate(Float64, A, t)
interpolate(A::AbstractArray{Float32}, t::BSpline) = interpolate(Float32, A, t)
interpolate(A::AbstractArray{Rational{Int}}, t::BSpline) = interpolate(Rational{Int}, A, t)

include("constant.jl")
# include("linear.jl")
# include("quadratic.jl")
# include("indexing.jl")
