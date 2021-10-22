using Dates
using Intervals
using Test
using YeSQL

queries = load_path(joinpath(@__DIR__, "sql", "queries.sql"))

@testset "Test query loading" begin
    @test !(:get_unique_instruments in keys(queries))
    # load all SQL files
    qpath = load_path(joinpath(@__DIR__, "sql"))
    @test :create_test_types in keys(qpath)
end

@testset "Test interval string representation" begin
    d1 = Date(2020,1,1)
    d2 = Date(2021,1,1)
    @test YeSQL._libpq_literal(d1..d2) == "[2020-01-01,2021-01-01]"
    @test YeSQL._libpq_literal([d1..d2, d1..nothing]) == ["[2020-01-01,2021-01-01]", "[2020-01-01,)"]
    @test YeSQL._libpq_literal([3..4, Interval{Closed,Open}(3,10)]) == ["[3,4]", "[3,10)"]
    @test YeSQL._libpq_literal(d1..nothing) == "[2020-01-01,)"
    @test YeSQL._libpq_literal(Interval{Date}(nothing, nothing)) == "(,)"
    @test YeSQL._libpq_literal(Interval{Date,Unbounded,Open}(nothing,d2)) == "(,2021-01-01)"
    @test YeSQL._libpq_literal(Interval{Date,Unbounded,Closed}(nothing,d2)) == "(,2021-01-01]"
end

@testset "Test parsing of query names" begin
    names = Dict(
        "-- name: normal_select" => (YeSQL.Select(), :normal_select),
        "-- name: select_value\$" => (YeSQL.SelectValue(), :select_value),
        "-- name: select_one^" => (YeSQL.SelectOne(), :select_one),
        "-- name: script#" => (YeSQL.Script(), :script),
        "-- name: insert!" => (YeSQL.InsertUpdateDelete(), :insert),
        "-- name: insert_many*!" => (YeSQL.InsertUpdateDeleteMany(), :insert_many),
        "-- name: insert_returning^!" => (YeSQL.InsertReturning(), :insert_returning),
        "-- name: insert_returning_value\$!" => (YeSQL.InsertReturningValue(), :insert_returning_value),
    )

    for (name_str, (target_op, target_name)) in names
        nm = match(YeSQL.NAME_REGEX, name_str)
        operation, query_name = YeSQL._interpret(nm[:query_name])
        @test operation == target_op
        @test query_name == target_name
    end
end

@testset "Test query extraction from string" begin
    s1 = "-- name: string_query1\n select count(*) from my_table where mycolumn = :myvalue"
    s2 = "-- name: string_query2\n select count(*) from my_table where mycolumn = :myvalue"
    queries_from_str = load_string(s1)
    load_string!(queries_from_str, s2)
    @test length(queries_from_str) == 2
    for q in values(queries_from_str)
        @test q.args == [:myvalue]
    end
end

@testset "Test that duplicate query warning is generated" begin
    s = "-- name: string_query1\n select count(*) from my_table where mycolumn = :myvalue"
    q = load_string(s)
    @test_logs (:warn, r"string_query1 already defined and will be overwritten") load_string!(q, s)
end

@testset "Test operation, argument, and docstring extraction" begin
    ops = Dict(
        :get_musicians => YeSQL.Select(),
        :get_musician_id => YeSQL.SelectValue(),
    )
    args = Dict(
        :get_musicians => (:employed_date,),
        :get_musician_id => (:first_name, :last_name),
    )

    docstrings = Dict(
        :get_musicians => "Return musicians active on :employed_date. A superfluous line to test multi-line docstrings.",
        :get_musician_id => "Return musician id",
    )

    for qn in keys(args)
        q = queries[qn]
        @test all(a in q.args for a in args[qn])
        @test q.docstring == docstrings[qn]
        expected_query = strip(replace(read(joinpath("./sql", "expected", string(qn) * ".sql"), String),
                                       r"\s+" => " "))
        @test expected_query == q.query
        @test q.operation == ops[qn]
    end
end

@testset "Test that error is thrown for invalid path" begin
    @test_throws ArgumentError load_path("garbage.sql")
end

include("libpq_tests.jl")
