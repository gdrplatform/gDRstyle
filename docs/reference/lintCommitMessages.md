# Lint commit messages for parenthesized Jira ticket references

The ticket ID belongs in the branch name only. Commit messages must not
carry a parenthesized reference such as `(GDR-<id>)`.

## Usage

``` r
lintCommitMessages(messages)
```

## Arguments

- messages:

  character vector of full commit messages.

## Value

`NULL` invisibly if no violations are found. Stops with an error listing
all violations otherwise.

## Examples

``` r
lintCommitMessages("fix: correct edge case in parser")
#> Commit message lint violations: OK!
```
