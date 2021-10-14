# YeSQL

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tah-alv.github.io/YeSQL.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tah-alv.github.io/YeSQL.jl/dev)
[![Build Status](https://github.com/tah-alv/YeSQL.jl/workflows/CI/badge.svg)](https://github.com/tah-alv/YeSQL.jl/actions)

Load SQL queries and operations directly from *.sql* files and execute
them from Julia. 

## Limitations

Currently query execution is only supported for PostgreSQL via
[LibPQ.jl](https://github.com/invenia/LibPQ.jl).

When developing queries as part of a package changes made in the
*.sql* files will not be reflected when the package is reloaded. A
workaround is to manually remove the cached package:
```julia
id = Base.identify_package("<package name>")
map(rm, Base.find_all_in_cache_path(id))
```

## Installation

```julia
] add git@github.com:tah-alv/YeSQL.jl.git
```
or 
```julia
using Pkg
Pkg.add("git@github.com:tah-alv/YeSQL.jl.git")
```

