# Find unqualified function calls in a single R chunk

Parses the chunk and returns all `SYMBOL_FUNCTION_CALL` tokens that are
not immediately preceded by a namespace operator (`::` or `:::`).

## Usage

``` r
.findUnqualifiedCalls(code)
```

## Arguments

- code:

  string R code for a single chunk.

## Value

data.table with columns `func` (character) and `line` (integer), or an
empty data.table on parse error.
