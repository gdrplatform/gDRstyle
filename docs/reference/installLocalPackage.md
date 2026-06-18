# Install locally cloned repo for builiding image purposes

Install locally cloned repo for builiding image purposes

## Usage

``` r
installLocalPackage(repo_path, additionalRepos = NULL, base_dir = "/mnt/vol")
```

## Arguments

- repo_path:

  String of repository directory.

- additionalRepos:

  List of additional Repos

- base_dir:

  String of base working directory.

## Value

`NULL`

## Examples

``` r
installLocalPackage(system.file(
package = "gDRstyle", "tst_pkgs", "dummy_pkg"
))
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> * checking for file ‘/tmp/RtmpcjFZmf/file1d7d5e5d9683/dummy_pkg/DESCRIPTION’ ... OK
#> * preparing ‘fakePkg’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Removed empty directory ‘fakePkg/tests/testthat/_snaps’
#> * building ‘fakePkg_1.0.tar.gz’
#> 
#> Installing package into ‘/tmp/RtmpcjFZmf/temp_libpath1d7d296a93d5’
#> (as ‘lib’ is unspecified)
```
