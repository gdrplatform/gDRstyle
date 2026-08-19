# Lint a branch name

Feature branches must be named after the Jira ticket only, e.g.
`GDR-NNNN`, with no trailing description. Branches matching `exempt`
(protected and Bioconductor release branches by default) are skipped, so
long-lived branches created before this rule are not blocked.

## Usage

``` r
lintBranchName(
  branch,
  pattern = "^GDR-[0-9]+$",
  exempt = "^(main|master|devel|RELEASE_[0-9]+_[0-9]+)$"
)
```

## Arguments

- branch:

  character(1) branch name.

- pattern:

  character(1) regular expression a feature branch name must match.
  Defaults to `"^GDR-[0-9]+$"`.

- exempt:

  character(1) regular expression for branch names that are skipped
  entirely. Defaults to `main`, `master`, `devel` and `RELEASE_<x>_<y>`
  Bioconductor branches.

## Value

`NULL` invisibly if the name is valid. Stops with an error otherwise.

## Examples

``` r
lintBranchName("GDR-1234") # nolint: ticket_ref_linter.
#> Branch name lint violations: OK!
```
