# Lint select subdirectories in a package directory.

Lint select subdirectories in a package directory.

## Usage

``` r
lintPkgDirs(pkg_dir = ".", shiny = FALSE)
```

## Arguments

- pkg_dir:

  String of path to package directory.

- shiny:

  Boolean of whether or not a `shiny` directory should also be lint.
  Defaults to the current directory.

## Value

`NULL` invisibly.

## Details

Will look for files in the following directories: `"R"`, `"tests"`, and
conditionally `"inst/shiny"` if `shiny` is `TRUE`.

## Examples

``` r
lintPkgDirs(
    pkg_dir= system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg"))
#> Linting file: /tmp/RtmpVW76rT/temp_libpath1cd539c07085/gDRstyle/tst_pkgs/dummy_pkg/R/test.R
#> Linting file: /tmp/RtmpVW76rT/temp_libpath1cd539c07085/gDRstyle/tst_pkgs/dummy_pkg/tests/testthat.R
#> Linting file: /tmp/RtmpVW76rT/temp_libpath1cd539c07085/gDRstyle/tst_pkgs/dummy_pkg/tests/testthat/test-pkg.R
#> All files OK!
```
