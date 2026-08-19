# Lint NEWS.md and DESCRIPTION for Jira ticket references

The ticket ID belongs in the branch name only. It must not appear in the
changelog (`NEWS.md`) or package metadata (`DESCRIPTION`).

## Usage

``` r
lintTicketRefs(pkg_dir = ".")
```

## Arguments

- pkg_dir:

  character(1) path to the package root directory. Defaults to the
  current directory.

## Value

`NULL` invisibly if no violations are found. Stops with an error listing
all violations otherwise.

## Examples

``` r
pkg_dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
lintTicketRefs(pkg_dir)
#> Ticket reference violations: OK!
```
