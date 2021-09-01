module YeSQL

using DocStringExtensions: FIELDS, SIGNATURES, TYPEDEF, TYPEDFIELDS, TYPEDSIGNATURES

export load_path, load_path!, load_string, load_string!

# SQLOperation types for dispatch
"""Abstract parent type"""
abstract type SQLOperation end
"""An operation which inserts a row returns a row of values. Name suffix: `<!`"""
struct InsertReturning <: SQLOperation end
"""An operation which inserts/updates/deletes many rows. Name suffix: `*!`"""
struct InsertUpdateDeleteMany <: SQLOperation end
"""An operation which inserts/updates/deletes a row. Name suffix: `!`"""
struct InsertUpdateDelete <: SQLOperation end
"""A sql script run without arguments. Name suffix: `#`"""
struct Script <: SQLOperation end
"""A query returning a single row. Name suffix: `^`"""
struct SelectOne <: SQLOperation end
"""A query returning a single value. Name suffix: `\$`"""
struct SelectValue <: SQLOperation end
"""A select query returning potentially many rows. No suffix."""
struct Select <: SQLOperation end

"""
$(TYPEDEF)

SQL query with fields extracted from a *.sql* file or string

# Fields

$(TYPEDFIELDS)

# Query syntax

Each query should be preceded by comment lines defining the query name
and operation type, and an optional docstring:

```sql
-- name: <name><operation_suffix>
-- <docstring>  (optional)
<query text>
```
"""
struct SQLQuery{O<:SQLOperation}
    "Query name"
    name::Symbol
    "Processed query string"
    query::String
    "Docstring"
    docstring::String
    "Argument list"
    args::Vector{Symbol}
    "`SQLOperation` derived from the operation suffix"
    operation::O
end

function Base.show(io::IO, q::SQLQuery)
    print(io, """$(q.operation): $(q.docstring)\nargs: $(join(q.args, ", "))\n""")
end

"""
    $(TYPEDSIGNATURES)

Interpret `query_name` and return an `SQLOperation` and name as a symbol

```jldoctest
YeSQL._interpret("my_script_query#")

# output

(YeSQL.Script(), :my_script_query)
```
"""
function _interpret(query_name::AbstractString)::Tuple{<:SQLOperation, Symbol}
    (operation, name) = if endswith(query_name, "<!")
        (InsertReturning(), query_name[begin:end-2])
    elseif endswith(query_name, "*!")
        (InsertUpdateDeleteMany(), query_name[begin:end-2])
    elseif endswith(query_name, "!")
        (InsertUpdateDelete(), query_name[begin:end-1])
    elseif endswith(query_name, "#")
        (Script(), query_name[begin:end-1])
    elseif endswith(query_name, "^")
        (SelectOne(), query_name[begin:end-1])
    elseif endswith(query_name, "\$")
        (SelectValue(), query_name[begin:end-1])
    else
        (Select(), query_name)
    end
    return operation, Symbol(name)
end


include("reader.jl")
include("libpq_adapter.jl")

end
