# These methods overload the SQLQuery call operator for LibPQ.jl 

import LibPQ

"""
    $(SIGNATURES)

Execute query `q` with `params` using connection `conn`

"""
function (q::SQLQuery{<:Select})(conn::LibPQ.Connection, params=NamedTuple()) 
    return LibPQ.execute(conn, q.query, [params[a] for a in q.args])
end

function (q::SQLQuery{<:Script})(conn)
    LibPQ.execute(conn, "BEGIN;")
    LibPQ.execute(conn, q.query)
    LibPQ.execute(conn, "COMMIT;")
    return nothing
end

function (q::SQLQuery{<:Union{InsertReturning,SelectOne}})(conn::LibPQ.Connection, params=NamedTuple())
    result = LibPQ.execute(conn, q.query, [params[a] for a in q.args])
    if LibPQ.num_rows(result) > 1
        @warn "$(q.name) returned more than one row"
    end
    nt = NamedTuple{tuple(Symbol.(result.column_names)...)}([v for v in first(result)])
    close(result)
    return nt
end

function (q::SQLQuery{<:InsertUpdateDeleteMany})(conn::LibPQ.Connection, params=NamedTuple())
    LibPQ.execute(conn, "BEGIN;")
    LibPQ.load!(params, conn, q.query)
    LibPQ.execute(conn, "COMMIT;")
    return nothing
end

function (q::SQLQuery{<:SelectValue})(conn::LibPQ.Connection, params=NamedTuple())
    result = LibPQ.execute(conn, q.query, [params[a] for a in q.args])
    if LibPQ.num_rows(result) > 1
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
