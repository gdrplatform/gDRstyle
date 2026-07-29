# Get exported symbols from an installed package

Returns an empty character vector (with a message) when the package is
not installed, so the linter degrades gracefully in environments that
lack optional dependencies.

## Usage

``` r
.getPkgExports(pkg)
```

## Arguments

- pkg:

  string package name.

## Value

character vector of exported symbol names.
