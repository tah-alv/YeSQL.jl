# API

## Public

```@docs
load_path
load_path!
load_string
load_string!
```

## Internals

### Query representation

```@docs
YeSQL.SQLQuery
```

### SQL Operations

These empty types are used for dispatch when executing a query. When
queries are loaded the query name suffix is used to determine the
appropriate operation.

```@docs
YeSQL.SQLOperation
YeSQL.Select
YeSQL.SelectOne
YeSQL.SelectValue
YeSQL.InsertUpdateDelete
YeSQL.InsertUpdateDeleteMany
YeSQL.InsertReturning
YeSQL.Script
```
### Functions

```@docs
YeSQL._interpret
YeSQL._extract!
```
