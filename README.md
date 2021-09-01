# YeSQL

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://tah-alv.github.io/YeSQL.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://tah-alv.github.io/YeSQL.jl/dev)
[![Build Status](https://github.com/tah-alv/YeSQL.jl/workflows/CI/badge.svg)](https://github.com/tah-alv/YeSQL.jl/actions)

Load SQL queries and operations directly from *.sql* files and execute
them from Julia. 

## Limitations

Currently query execution is only supported for PostgreSQL via
[LibPQ.jl](https://github.com/invenia/LibPQ.jl).

## Installation

```julia
] add git@github.com:tah-alv/YeSQL.jl.git
```
or 
```julia
using Pkg
Pkg.add("git@github.com:tah-alv/YeSQL.jl.git")
```

