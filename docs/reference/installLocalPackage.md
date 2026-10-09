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
#> * checking for file ‘/tmp/RtmpOVziei/file1914523491e9/dummy_pkg/DESCRIPTION’ ... OK
#> * preparing ‘fakePkg’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Removed empty directory ‘fakePkg/tests/testthat/_snaps’
#> * building ‘fakePkg_1.0.0.tar.gz’
#> 
#> Installing package into ‘/tmp/RtmpOVziei/temp_libpath19143389f881’
#> (as ‘lib’ is unspecified)
```
