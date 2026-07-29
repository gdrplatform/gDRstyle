# Replace mustache template expressions with safe R literals

Rmd report templates often contain `{{param}}` mustache syntax. This
function replaces those tokens so the R chunk can be parsed without
syntax errors.

## Usage

``` r
.stripMustache(code)
```

## Arguments

- code:

  string R code possibly containing mustache tokens.

## Value

string code with mustache tokens replaced.
