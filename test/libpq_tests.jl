using Intervals
using Dates
using LibPQ

# Determine if postgres is installed
postgres_installed = try
    run(`createdb test-yesql`)
    true
catch
    @info "Not running LibPQ tests because PostgreSQL is not installed/configured"
    false
end

if postgres_installed
    @testset "Test LibPQ query execution" begin
        queries = load_path(joinpath(@__DIR__, "sql"))
        
        conn = LibPQ.Connection("""dbname=test-yesql user=$(ENV["USER"]) host=localhost""")

        # create a table
        queries[:create_table](conn)

        # insert a musician with dict params
        adrian = Dict(:first_name => "Adrian",
                      :last_name => "Belew",
                      :instrument =>"guitar",
                      :active => Date(1977, 1,1)..Date(1978,12,31))
        (id, ) = queries[:insert_musician_id](conn, adrian)
        @test id == 1

        id = queries[:get_musician_id](conn, adrian)
        @test id == 1

        # select data about a musician
        (first_name, last_name) = queries[:get_musician_name](conn, (musician_id=id,))
        @test first_name == adrian[:first_name]
        @test last_name == adrian[:last_name]

        # insert multiple musicians
        guitarists = (first_name=["Steve", "Mike"], last_name=["Vai", "Keneally"],
                      instrument=["guitar" for _ in 1:2],
                      active=[Date(1981, 1, 1)..Date(1987,12,31), Date(1988, 1, 1)..Date(1992,12,31)])
        queries[:insert_musicians](conn, guitarists)

        queries[:insert_musician](conn, (first_name="Pierre", last_name="Boulez", instrument="Conductor",
                                         active=Date(1984,1,1)..Date(1985,1,1)))

        # count, delete and count again
        @test queries[:count_musicians](conn) == 4
        queries[:delete_musician](conn, adrian)
        @test queries[:count_musicians](conn) == 3

        # test that adrian is deleted and nothing is returned
        id = queries[:get_musician_id](conn, adrian)
        @test id === missing
        row = queries[:get_musician_name](conn, (musician_id=1,))
        @test row === missing

        # test arrays of ranges
        queries[:create_test_types](conn)

        d1 = Date(2001,1,1)
        d2 = Date(2002,1,1)
        params = (int_val=4,
                  real_val=4.0,
                  double_val=4.0,
                  ts_val=now(),
                  intrange_val=4..10,
                  numrange_val=3.0..5.0,
                  daterange_val=d1..d2,
                  tsrange_val=(now()-Day(1))..now(),
                  int_array=[1,2],
                  real_array=Float32[1,2,3],
                  intrange_array=[4..10, Interval{Closed,Open}(4,10)],
                  daterange_array=[d1..d2, Interval{Closed,Open}(d1,d2)])

        queries[:insert_test_types](conn, params)

        close(conn)
        run(`dropdb test-yesql`)
    end
end
