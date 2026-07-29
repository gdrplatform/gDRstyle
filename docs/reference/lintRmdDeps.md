# Check an Rmd file for unresolved function calls

Parses all R chunks in an Rmd file, collects packages loaded via
[`library()`](https://rdrr.io/r/base/library.html) /
[`require()`](https://rdrr.io/r/base/library.html), detects the host
package from the nearest `DESCRIPTION` file, identifies locally defined
names, and flags any unqualified function call that cannot be resolved
to a known symbol.

## Usage

``` r
lintRmdDeps(rmd_path, verbose = FALSE)
```

## Arguments

- rmd_path:

  string path to an `.Rmd` file.

- verbose:

  logical(1) if `TRUE`, prints diagnostics (host package, loaded
  packages, local definitions, known symbol count). Default `FALSE`.

## Value

A `data.table` with columns `func` (character) and `line` (integer) -
one row per unique unresolved call site. Returns `NULL` when the file
contains no R chunks.

## Details

Mustache template syntax (`{{param}}`) is stripped before parsing so
parametrised report templates can be checked without syntax errors.

## Examples

``` r
if (FALSE) { # \dontrun{
# Check a single template
lintRmdDeps("inst/report_templates/3-analysis.Rmd")

# Check with verbose diagnostics
lintRmdDeps("inst/report_templates/3-analysis.Rmd", verbose = TRUE)
} # }
```
