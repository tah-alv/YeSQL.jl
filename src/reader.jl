using Glob: glob

const NAME_REGEX = r"\n?\s*--\s*name:\s*(?<query_name>\w+[\^\*\!\<\#\$]{0,2}+)\n?"
const DOCSTRING_REGEX = r"^--\s*(?<docstring>.*)\n+"
const COMMENT_REGEX = r"\n?+\s*?--.*\n?"
const ARG_REGEX = r"(?<leading_char>[^:]):(?<symbol_name>\w+)"

"""
    $(TYPEDSIGNATURES)

Parse `queries_text` and insert extracted `SQLQuery`s into `queries`

"""
function _extract!(queries::AbstractDict, queries_text::AbstractString)

    # Find all query names in query_text
    name_matches = collect(eachmatch(NAME_REGEX, queries_text))

    for (i,nm) in enumerate(name_matches)
        operation, query_name = _interpret(nm[:query_name])

        if query_name in keys(queries)
            @warn "$(query_name) already defined and will be overwritten"
        end

        # Find start/end indices of query and extract
        istart = nm.offset + length(nm.match)
        iend = i < length(name_matches) ? name_matches[i+1].offset - 1 : length(queries_text)
        raw_query = queries_text[istart:iend]

        # Extract the docstring if present
        doc_match = match(DOCSTRING_REGEX, raw_query)
        docstring = doc_match === nothing ? "" : string(strip(doc_match[:docstring]))

        # Strip out the docstring and any comments in the query
        transformed_query = replace(strip(raw_query), DOCSTRING_REGEX => "")
        transformed_query = replace(transformed_query, COMMENT_REGEX => " ")

        # Find any named arguments in the query and replace them with $1, $2 etc
        args = Symbol[]
        num_args = 0
        for m in eachmatch(ARG_REGEX, transformed_query)
            arg = Symbol(m[:symbol_name])
            if arg in args      # argument already captured
                continue
            else                # replace the named argument with numerical placeholder
                num_args += 1
                push!(args, arg)
                transformed_query = replace(transformed_query,
                                            m.match => "$(m[:leading_char])\$$(num_args)")
            end
        end

        # Replace newlines and extra spaces with a single space
        transformed_query = replace(transformed_query, r"\s+" => " ")

        # Insert the SQLQuery into the Dict
        queries[query_name] = SQLQuery(query_name, transformed_query, docstring, args, operation)
    end
    return nothing
end


"""
    $(TYPEDSIGNATURES)

Read files(s) at `path` and insert extracted `SQLQuery`s into
`queries`. If `path` is a directory then include files matching
`glob_pattern`.

"""
function load_path!(queries::AbstractDict, path; glob_pattern="*.sql")
    ispath(path) || throw(ArgumentError("$path does not exist"))
    files = isfile(path) ? [path] : glob(glob_pattern, path)
    for file in files
       _extract!(queries, read(file, String))
    end
    return nothing
end

"""
    $(TYPEDSIGNATURES)

Read files(s) at `path` and return extracted `SQLQuery`s. If `path` is
a directory then include files matching `glob_pattern`.

"""
function load_path(path; glob_pattern="*.sql")
    queries = Dict{Symbol, SQLQuery}()
    load_path!(queries, path; glob_pattern=glob_pattern)
    return queries
end


"""
    $(TYPEDSIGNATURES)

Parse `query_text` and insert extracted `SQLQuery`s into `queries`

"""
load_string!(queries::AbstractDict, query_text::AbstractString) = _extract!(queries, query_text)

"""
    $(TYPEDSIGNATURES)

Parse `query_text` and return extracted `SQLQuery`s

"""
function load_string(query_text::AbstractString)
    queries=Dict{Symbol, SQLQuery}()
    load_string!(queries, query_text)
    return queries
end

