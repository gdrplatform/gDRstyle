# Lint a PR title for Jira ticket references

The ticket ID belongs in the branch name only. The PR title must not
carry any reference such as `GDR-<id>` or `(GDR-<id>)`.

## Usage

``` r
lintPrTitle(title)
```

## Arguments

- title:

  character(1) PR title.

## Value

`NULL` invisibly if no violations are found. Stops with an error
otherwise.

## Examples

``` r
lintPrTitle("feat: add contribution linter")
#> PR title lint violations: OK!
```
