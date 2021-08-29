using YeSQL
using Documenter

DocMeta.setdocmeta!(YeSQL, :DocTestSetup, :(using YeSQL); recursive=true)

makedocs(;
    modules=[YeSQL],
    authors="Todd Hay",
    repo="https://github.com/tah-alv/YeSQL.jl/blob/{commit}{path}#{line}",
    sitename="YeSQL.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://tah-alv.github.io/YeSQL.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/tah-alv/YeSQL.jl",
)
