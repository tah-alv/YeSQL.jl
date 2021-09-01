```@meta
CurrentModule = YeSQL
```

# YeSQL

[YeSQL.jl](https://github.com/tah-alv/YeSQL.jl) provides a way to load
SQL queries and operations directly from *.sql* files and execute them
from Julia. It was inspiried by similar packages for Python
([anosql](https://github.com/honza/anosql),
[aiosql](https://github.com/nackjicholson/aiosql)) and Clojure
([yesql](https://github.com/krisajenkins/yesql),
[HugSQL](https://github.com/layerware/hugsql)).

In contrast to writing queries as strings in code, or using an ORM,
with this approach queries can be written, version controlled,
formatted ([pgFormatter](https://github.com/darold/pgFormatter)), run
([psql](https://www.postgresql.org/docs/current/app-psql.html)), and
debugged outside Julia using tools specifically designed for SQL.

## Limitations

Currently there is only an adapter defined for PostgreSQL via
[LibPQ.jl](https://github.com/invenia/LibPQ.jl) because that's all I
use.  It should be possible to write adapters for other databases
(e.g. SQLite).

## Installation

```julia
] add git@github.com:tah-alv/YeSQL.jl.git
```
or 
```julia
using Pkg
Pkg.add("git@github.com:tah-alv/YeSQL.jl.git")
```
## Example

Say we have the file `queries.sql` with the following queries
```sql
-- name: create_musicians#
-- Create a table and index (Script operation)
CREATE TABLE zappa_musicians (
    musician_id serial PRIMARY KEY,
    first_name text,
    last_name text,
    instrument text,
    UNIQUE (first_name, last_name, instrument)
);

CREATE INDEX instrument_idx ON zappa_musicians (instrument);

-- name: insert_musician<!
-- Insert a musician and return musician_id (InsertReturning operation)
INSERT INTO zappa_musicians (
    first_name,
    last_name,
    instrument)
VALUES (
    :first_name,
    :last_name,
    :instrument)
RETURNING
    musician_id;

-- name: insert_musicians*!
-- Insert several musicians (InsertUpdateDeleteMany operation)
INSERT INTO zappa_musicians (
    first_name,
    last_name,
    instrument)
VALUES (
    :first_name,
    :last_name,
    :instrument)
RETURNING
    musician_id;

-- name: get_musicians
-- Return musicians playing :instrument (Select operation)
SELECT
    first_name,
    last_name
FROM
    zappa_musicians
WHERE
    instrument = :instrument;

-- name: get_musician_id$
-- Return the musician_id matching :first_name, :last_name and :instrument (SelectValue operation)
SELECT
    musician_id
FROM
    zappa_musicians
WHERE
    first_name = :first_name
    AND last_name = :last_name
    AND instrument = :instrument;
```

We can interact with our database from Julia like this
```julia
using YeSQL
using LibPQ

conn = LibPQ.Connection("<connection string>")

queries = YeSQL.load_path("./queries.sql")

# Create the table:
queries[:create_musicians](conn)

# Insert some rows...
# arguments can be passed as a Dict or NamedTuple
musician = (first_name="Adrian", last_name="Belew", instrument="guitar")
# Insert a row and get the returned fields as a NamedTuple
(musician_id,) = queries[:insert_musician](conn, musician) # musician_id = 1

# Insert multiple rows 
musicians = (first_name=["Ruth", "Mark"], last_name=["Underwood", "Volman"],
             instrument=["percussion", "vocals"])
queries[:insert_musicians](conn, musicians)

# Select and iterate over rows 
for row in queries[:get_musicians](conn, Dict(:instrument => "guitar"))
    println("$(row.first_name) $(row.last_name) played guitar") 
end

# Select a musician_id as an integer
ruth_id = queries[:get_musician_id](
    conn, (first_name="Ruth", last_name="Underwood", instrument="percussion"))

close(conn)
```

## Loading queries

Queries can either be loaded from a *.sql* file or directory
containing multiple files using `load_path(path)` or from a string
using `load_string(query_string)`. These functions return a
`Dict{Symbol, SQLQuery}` mapping query names to queries. Queries can
be added to an existing dictionary using the mutating versions
`load_path!(queries, path)` and `load_string!(queries, query_string)`.

An `SQLQuery` has the following structure:
```julia
struct SQLQuery{O<:SQLOperation}
    name::Symbol                # query name
    query::String # query with comments removed and named arguments replaced with $1,$2 etc.
    docstring::String           # query docstring
    args::Vector{Symbol}        # named arguments
    operation::O                # SQLOperation for execution dispatch
end
```

## Specifying query names and operation types

In a *.sql* file or string queries must be separated by comment lines
which define the query names and operation types: `-- name: <query
name><operation suffix>`. Currently multi-line comments (`/* ... */` )
aren't recognized.

Query operations are indicated by an operation suffix which is mapped
to a subtype of the abstract type `SQLOperation` and used for dispatch
when executing the query.

| Suffix    | Operation                | Description                           |
|-----------|--------------------------|---------------------------------------|
| No suffix | `Select`              | Select query returning rows           |
| `^`       | `SelectOne`              | Return the first row from a query     |
| `$`       | `SelectValue`            | Return the first value from a query   |
| `!`       | `InsertUpdateDelete`     | Insert/Update/Delete a row            |
| `*!`      | `InsertUpdateDeleteMany` | Insert/Update/Delete many rows        |
| `<!`      | `InsertReturning`        | Insert a row and return values        |
| `#`       | `Script`                 | A script with no arguments (e.g. DDL) |

## Running tests

One of the testsets tests query execution. In order to run it a role
with the name `$USER` must exist and have permission to create and
drop PostgreSQL databases. If this role doesn't exist the testset will
be skipped. 

To create this role you can run

```sh
sudo -u postgres createuser -d $USER
```

The testset will create a database called `test-yesql` which will be
dropped after the tests run, but if there is an error during the tests
the database might not be dropped. In this case just run `dropdb
test-yesql`.


