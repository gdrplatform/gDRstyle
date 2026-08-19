# Lint version consistency between NEWS.md and DESCRIPTION

Checks that the top `NEWS.md` header matches the package metadata: the
package name, version, and date in `## <Pkg> <version> - <date>` must
equal the `Package`, `Version`, and `Date` fields in `DESCRIPTION`. This
catches a version bump that forgot to update the changelog (or vice
versa).

## Usage

``` r
lintVersionConsistency(pkg_dir = ".")
```

## Arguments

- pkg_dir:

  character(1) path to the package root directory. Defaults to the
  current directory.

## Value

`NULL` invisibly if consistent. Stops with an error listing all
mismatches otherwise.

## Examples

``` r
pkg_dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
lintVersionConsistency(pkg_dir)
#> Version consistency violations: OK!
```
