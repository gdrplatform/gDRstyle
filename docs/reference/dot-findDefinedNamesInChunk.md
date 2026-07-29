# Extract locally defined names from a single R chunk using the AST

Uses [`getParseData()`](https://rdrr.io/r/utils/getParseData.html) to
find the left-hand side of `<-` assignment expressions. The AST approach
is preferred over regex because it correctly handles indirect
assignments such as `x <- if (cond) a else b` without producing false
positives from function default arguments (`f = function(x = 1)`).
`EQ_ASSIGN` (`=`) is intentionally excluded to avoid matching function
formals.

## Usage

``` r
.findDefinedNamesInChunk(code)
```

## Arguments

- code:

  string R code for a single chunk.

## Value

character vector of locally defined names.
