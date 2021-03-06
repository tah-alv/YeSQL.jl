using LibPQ
using Intervals: AbstractInterval, Bounded, Closed, Open, Unbounded

# String representation of interval bounds
_left_bound(::Type{Open}) = '('
_left_bound(::Type{Closed}) = '['
_right_bound(::Type{Open}) = ')'
_right_bound(::Type{Closed}) = ']'

# Define string literals for intervals and vectors of intervals
_libpq_literal(x) = x    # default: identity

_libpq_literal(r::AbstractRange) = string('[', r.start, ',', r.stop, ']')
function _libpq_literal(i::AbstractInterval{T,L,R}) where {T,L<:Bounded,R<:Bounded}
    return string(_left_bound(L), first(i), ',', last(i), _right_bound(R))
end
function _libpq_literal(i::AbstractInterval{T,L,R}) where {T,L<:Bounded,R<:Unbounded}
    return string(_left_bound(L), first(i), ",)")
end
function _libpq_literal(i::AbstractInterval{T,L,R}) where {T,L<:Unbounded,R<:Bounded}
    return string("(,", last(i), _right_bound(R))
end
_libpq_literal(i::AbstractInterval{T,L,R}) where {T,L<:Unbounded,R<:Unbounded} = "(,)"
_libpq_literal(xs::Union{AbstractVector,Tuple}) = [_libpq_literal(x) for x in xs]

_build_params(q::SQLQuery, params) = Tuple(_libpq_literal(params[a]) for a in q.args)

# The following methods overload the SQLQuery call operator for LibPQ.jl 

"""
    $(SIGNATURES)

Execute query `q` with `params` using connection `conn`

"""
function (q::SQLQuery{<:Union{Select,InsertUpdateDelete}})(conn::LibPQ.Connection, params=NamedTuple()) 
    return execute(conn, q.query, _build_params(q, params))
end

function (q::SQLQuery{<:Script})(conn)
    execute(conn, "BEGIN;")
    execute(conn, q.query)
    execute(conn, "COMMIT;")
    return nothing
end

function (q::SQLQuery{<:Union{InsertReturning,SelectOne}})(conn::LibPQ.Connection, params=NamedTuple())
    result = execute(conn, q.query, _build_params(q, params))
    if num_rows(result) == 0
        close(result)
        return missing
    elseif num_rows(result) > 1
        @warn "$(q.name) returned more than one row"
    end
    nt = NamedTuple{tuple(Symbol.(result.column_names)...)}([v for v in first(result)])
    close(result)
    return nt
end

function (q::SQLQuery{<:InsertUpdateDeleteMany})(conn::LibPQ.Connection, params=NamedTuple())
    execute(conn, "BEGIN;")
    LibPQ.load!(NamedTuple(k => _libpq_literal(v) for (k,v) in pairs(params) if k in q.args),
                conn,
                q.query)
    execute(conn, "COMMIT;")
    return nothing
end

function (q::SQLQuery{<:Union{SelectValue,InsertReturningValue}})(conn::LibPQ.Connection, params=NamedTuple())
    result = execute(conn, q.query, _build_params(q, params))
    if num_rows(result) == 0
        close(result)
        return missing
    elseif num_rows(result) > 1
        @warn "$(q.name) returned more than one row"
    end
    row = first(result)
    if length(row) > 1
        @warn "$(q.name) returned more than one value"
    end
    value = first(row)
    close(result)
    return value
end
