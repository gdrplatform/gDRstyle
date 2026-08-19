# Lint a merge/pull request title and body

Convenience wrapper for CI: checks the title for ticket references and,
when the repository ships a PR/MR template, checks that the body keeps
its sections. The template check is skipped (with a message) when no
template is present, so repositories without one are not blocked.

## Usage

``` r
lintMergeRequest(title, body, pkg_dir = ".", branch = NULL)
```

## Arguments

- title:

  character(1) merge/pull request title.

- body:

  character(1) merge/pull request description.

- pkg_dir:

  character(1) path to the repository root used to locate the PR/MR
  template. Defaults to the current directory.

- branch:

  character(1) source branch name, or `NULL` to skip the branch-name
  check. Defaults to `NULL`.

## Value

`NULL` invisibly if no violations are found. Stops with an error
otherwise.

## Examples

``` r
lintMergeRequest("feat: add contribution linter", "details", tempdir())
#> PR title lint violations: OK!
#> PR template check skipped: no template found in /tmp/Rtmp04MQV4
```
