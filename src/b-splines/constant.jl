immutable ConstantDegree <: Degree{0} end
BSpline{GR<:GridRepresentation}(d::Type{ConstantDegree}, gr::Type{GR}) = BSpline(ConstantDegree, None, GR)


function define_indices(::ConstantDegree, N)
    :(@nexprs $N d->(ix_d = clamp(round(real(x_d)), 1, size(itp,d))))
end

function coefficients(c::ConstantDegree, N)
    :(@nexprs $N d->($(coefficients(c, N, :d))))
end

function coefficients(::ConstantDegree, N, d)
    sym, symx = symbol(string("c_",d)), symbol(string("x_",d))
    :($sym = 1)
end

function gradient_coefficients(::ConstantDegree, N, d)
    sym, symx = symbol(string("c_",d)), symbol(string("x_",d))
    :($sym = 0)
end

function index_gen(degree::ConstantDegree, N::Integer, offsets...)
    if (length(offsets) < N)
        d = length(offsets)+1
        sym = symbol("c_"*string(d))
        return :($sym * $(index_gen(degree, N, offsets..., 0)))
    else
        indices = [offsetsym(offsets[d], d) for d = 1:N]
        return :(itp.coefs[$(indices...)])
    end
end
