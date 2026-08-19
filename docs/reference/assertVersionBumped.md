# Assert that a package version was bumped

Compares the incoming `DESCRIPTION` `Version` against the version on the
target branch and stops unless it strictly increased. Intended for CI on
merge/pull requests, giving GitLab the version-bump guarantee that the
GitHub `auto-changelog` workflow provides.

## Usage

``` r
assertVersionBumped(old_version, new_version)
```

## Arguments

- old_version:

  character(1) version on the target branch.

- new_version:

  character(1) version proposed by the merge/pull request.

## Value

`NULL` invisibly if the version increased. Stops with an error
otherwise.

## Examples

``` r
assertVersionBumped("1.0.0", "1.0.1")
#> Version bump: OK!
```
