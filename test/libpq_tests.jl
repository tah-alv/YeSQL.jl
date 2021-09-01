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

        # count, delete and count again
        @test queries[:count_musicians](conn) == 3
        queries[:delete_musician](conn, adrian)
        @test queries[:count_musicians](conn) == 2

        close(conn)
        run(`dropdb test-yesql`)
    end
end
