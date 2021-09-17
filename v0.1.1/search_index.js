var documenterSearchIndex = {"docs":
[{"location":"pages/api/#API","page":"API","title":"API","text":"","category":"section"},{"location":"pages/api/#Public","page":"API","title":"Public","text":"","category":"section"},{"location":"pages/api/","page":"API","title":"API","text":"load_path\nload_path!\nload_string\nload_string!","category":"page"},{"location":"pages/api/#YeSQL.load_path","page":"API","title":"YeSQL.load_path","text":"load_path(path; glob_pattern) -> Dict{Symbol, YeSQL.SQLQuery}\n\n\nRead files(s) at path and return extracted SQLQuerys. If path is a directory then include files matching glob_pattern.\n\n\n\n\n\n","category":"function"},{"location":"pages/api/#YeSQL.load_path!","page":"API","title":"YeSQL.load_path!","text":"load_path!(queries::AbstractDict, path; glob_pattern)\n\n\nRead files(s) at path and insert extracted SQLQuerys into queries. If path is a directory then include files matching glob_pattern.\n\n\n\n\n\n","category":"function"},{"location":"pages/api/#YeSQL.load_string","page":"API","title":"YeSQL.load_string","text":"load_string(query_text::AbstractString) -> Dict{Symbol, YeSQL.SQLQuery}\n\n\nParse query_text and return extracted SQLQuerys\n\n\n\n\n\n","category":"function"},{"location":"pages/api/#YeSQL.load_string!","page":"API","title":"YeSQL.load_string!","text":"load_string!(queries::AbstractDict, query_text::AbstractString)\n\n\nParse query_text and insert extracted SQLQuerys into queries\n\n\n\n\n\n","category":"function"},{"location":"pages/api/#Internals","page":"API","title":"Internals","text":"","category":"section"},{"location":"pages/api/#Query-representation","page":"API","title":"Query representation","text":"","category":"section"},{"location":"pages/api/","page":"API","title":"API","text":"YeSQL.SQLQuery","category":"page"},{"location":"pages/api/#YeSQL.SQLQuery","page":"API","title":"YeSQL.SQLQuery","text":"struct SQLQuery{O<:YeSQL.SQLOperation}\n\nSQL query with fields extracted from a .sql file or string\n\nFields\n\nname::Symbol\nQuery name\nquery::String\nProcessed query string\ndocstring::String\nDocstring\nargs::Vector{Symbol}\nArgument list\noperation::YeSQL.SQLOperation\nSQLOperation derived from the operation suffix\n\nQuery syntax\n\nEach query should be preceded by comment lines defining the query name and operation type, and an optional docstring:\n\n-- name: <name><operation_suffix>\n-- <docstring>  (optional)\n<query text>\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#SQL-Operations","page":"API","title":"SQL Operations","text":"","category":"section"},{"location":"pages/api/","page":"API","title":"API","text":"These empty types are used for dispatch when executing a query. When queries are loaded the query name suffix is used to determine the appropriate operation.","category":"page"},{"location":"pages/api/","page":"API","title":"API","text":"YeSQL.SQLOperation\nYeSQL.Select\nYeSQL.SelectOne\nYeSQL.SelectValue\nYeSQL.InsertUpdateDelete\nYeSQL.InsertUpdateDeleteMany\nYeSQL.InsertReturning\nYeSQL.Script","category":"page"},{"location":"pages/api/#YeSQL.SQLOperation","page":"API","title":"YeSQL.SQLOperation","text":"Abstract parent type\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.Select","page":"API","title":"YeSQL.Select","text":"A select query returning potentially many rows. No suffix.\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.SelectOne","page":"API","title":"YeSQL.SelectOne","text":"A query returning a single row. Name suffix: ^\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.SelectValue","page":"API","title":"YeSQL.SelectValue","text":"A query returning a single value. Name suffix: $\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.InsertUpdateDelete","page":"API","title":"YeSQL.InsertUpdateDelete","text":"An operation which inserts/updates/deletes a row. Name suffix: !\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.InsertUpdateDeleteMany","page":"API","title":"YeSQL.InsertUpdateDeleteMany","text":"An operation which inserts/updates/deletes many rows. Name suffix: *!\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.InsertReturning","page":"API","title":"YeSQL.InsertReturning","text":"An operation which inserts a row returns a row of values. Name suffix: <!\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#YeSQL.Script","page":"API","title":"YeSQL.Script","text":"A sql script run without arguments. Name suffix: #\n\n\n\n\n\n","category":"type"},{"location":"pages/api/#Functions","page":"API","title":"Functions","text":"","category":"section"},{"location":"pages/api/","page":"API","title":"API","text":"YeSQL._interpret\nYeSQL._extract!","category":"page"},{"location":"pages/api/#YeSQL._interpret","page":"API","title":"YeSQL._interpret","text":"_interpret(query_name::AbstractString) -> Any\n\n\nInterpret query_name and return an SQLOperation and name as a symbol\n\nYeSQL._interpret(\"my_script_query#\")\n\n# output\n\n(YeSQL.Script(), :my_script_query)\n\n\n\n\n\n","category":"function"},{"location":"pages/api/#YeSQL._extract!","page":"API","title":"YeSQL._extract!","text":"_extract!(queries::AbstractDict, queries_text::AbstractString)\n\n\nParse queries_text and insert extracted SQLQuerys into queries\n\n\n\n\n\n","category":"function"},{"location":"","page":"Home","title":"Home","text":"CurrentModule = YeSQL","category":"page"},{"location":"#YeSQL","page":"Home","title":"YeSQL","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"YeSQL.jl provides a way to load SQL queries and operations directly from .sql files and execute them from Julia. It was inspiried by similar packages for Python (anosql, aiosql) and Clojure (yesql, HugSQL).","category":"page"},{"location":"","page":"Home","title":"Home","text":"In contrast to writing queries as strings in code, or using an ORM, with this approach queries can be written, version controlled, formatted (pgFormatter), run (psql), and debugged outside Julia using tools specifically designed for SQL.","category":"page"},{"location":"#Limitations","page":"Home","title":"Limitations","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Currently there is only an adapter defined for PostgreSQL via LibPQ.jl because that's all I use.  It should be possible to write adapters for other databases (e.g. SQLite).","category":"page"},{"location":"#Installation","page":"Home","title":"Installation","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"] add git@github.com:tah-alv/YeSQL.jl.git","category":"page"},{"location":"","page":"Home","title":"Home","text":"or ","category":"page"},{"location":"","page":"Home","title":"Home","text":"using Pkg\nPkg.add(\"git@github.com:tah-alv/YeSQL.jl.git\")","category":"page"},{"location":"#Example","page":"Home","title":"Example","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Say we have the file queries.sql with the following queries","category":"page"},{"location":"","page":"Home","title":"Home","text":"-- name: create_musicians#\n-- Create a table and index (Script operation)\nCREATE TABLE zappa_musicians (\n    musician_id serial PRIMARY KEY,\n    first_name text,\n    last_name text,\n    instrument text,\n    UNIQUE (first_name, last_name, instrument)\n);\n\nCREATE INDEX instrument_idx ON zappa_musicians (instrument);\n\n-- name: insert_musician<!\n-- Insert a musician and return musician_id (InsertReturning operation)\nINSERT INTO zappa_musicians (\n    first_name,\n    last_name,\n    instrument)\nVALUES (\n    :first_name,\n    :last_name,\n    :instrument)\nRETURNING\n    musician_id;\n\n-- name: insert_musicians*!\n-- Insert several musicians (InsertUpdateDeleteMany operation)\nINSERT INTO zappa_musicians (\n    first_name,\n    last_name,\n    instrument)\nVALUES (\n    :first_name,\n    :last_name,\n    :instrument)\nRETURNING\n    musician_id;\n\n-- name: get_musicians\n-- Return musicians playing :instrument (Select operation)\nSELECT\n    first_name,\n    last_name\nFROM\n    zappa_musicians\nWHERE\n    instrument = :instrument;\n\n-- name: get_musician_id$\n-- Return the musician_id matching :first_name, :last_name and :instrument (SelectValue operation)\nSELECT\n    musician_id\nFROM\n    zappa_musicians\nWHERE\n    first_name = :first_name\n    AND last_name = :last_name\n    AND instrument = :instrument;","category":"page"},{"location":"","page":"Home","title":"Home","text":"We can interact with our database from Julia like this","category":"page"},{"location":"","page":"Home","title":"Home","text":"using YeSQL\nusing LibPQ\n\nconn = LibPQ.Connection(\"<connection string>\")\n\nqueries = YeSQL.load_path(\"./queries.sql\")\n\n# Create the table:\nqueries[:create_musicians](conn)\n\n# Insert some rows...\n# arguments can be passed as a Dict or NamedTuple\nmusician = (first_name=\"Adrian\", last_name=\"Belew\", instrument=\"guitar\")\n# Insert a row and get the returned fields as a NamedTuple\n(musician_id,) = queries[:insert_musician](conn, musician) # musician_id = 1\n\n# Insert multiple rows \nmusicians = (first_name=[\"Ruth\", \"Mark\"], last_name=[\"Underwood\", \"Volman\"],\n             instrument=[\"percussion\", \"vocals\"])\nqueries[:insert_musicians](conn, musicians)\n\n# Select and iterate over rows \nfor row in queries[:get_musicians](conn, Dict(:instrument => \"guitar\"))\n    println(\"$(row.first_name) $(row.last_name) played guitar\") \nend\n\n# Select a musician_id as an integer\nruth_id = queries[:get_musician_id](\n    conn, (first_name=\"Ruth\", last_name=\"Underwood\", instrument=\"percussion\"))\n\nclose(conn)","category":"page"},{"location":"#Loading-queries","page":"Home","title":"Loading queries","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Queries can either be loaded from a .sql file or directory containing multiple files using load_path(path) or from a string using load_string(query_string). These functions return a Dict{Symbol, SQLQuery} mapping query names to queries. Queries can be added to an existing dictionary using the mutating versions load_path!(queries, path) and load_string!(queries, query_string).","category":"page"},{"location":"","page":"Home","title":"Home","text":"An SQLQuery has the following structure:","category":"page"},{"location":"","page":"Home","title":"Home","text":"struct SQLQuery{O<:SQLOperation}\n    name::Symbol                # query name\n    query::String # query with comments removed and named arguments replaced with $1,$2 etc.\n    docstring::String           # query docstring\n    args::Vector{Symbol}        # named arguments\n    operation::O                # SQLOperation for execution dispatch\nend","category":"page"},{"location":"#Specifying-query-names-and-operation-types","page":"Home","title":"Specifying query names and operation types","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"In a .sql file or string queries must be separated by comment lines which define the query names and operation types: -- name: <query name><operation suffix>. Currently multi-line comments (/* ... */ ) aren't recognized.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Query operations are indicated by an operation suffix which is mapped to a subtype of the abstract type SQLOperation and used for dispatch when executing the query.","category":"page"},{"location":"","page":"Home","title":"Home","text":"Suffix Operation Description\nNo suffix Select Select query returning rows\n^ SelectOne Return the first row from a query\n$ SelectValue Return the first value from a query\n! InsertUpdateDelete Insert/Update/Delete a row\n*! InsertUpdateDeleteMany Insert/Update/Delete many rows\n<! InsertReturning Insert a row and return values\n# Script A script with no arguments (e.g. DDL)","category":"page"},{"location":"#Running-tests","page":"Home","title":"Running tests","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"One of the testsets tests query execution. In order to run it a role with the name $USER must exist and have permission to create and drop PostgreSQL databases. If this role doesn't exist the testset will be skipped. ","category":"page"},{"location":"","page":"Home","title":"Home","text":"To create this role you can run","category":"page"},{"location":"","page":"Home","title":"Home","text":"sudo -u postgres createuser -d $USER","category":"page"},{"location":"","page":"Home","title":"Home","text":"The testset will create a database called test-yesql which will be dropped after the tests run, but if there is an error during the tests the database might not be dropped. In this case just run dropdb test-yesql.","category":"page"}]
}
