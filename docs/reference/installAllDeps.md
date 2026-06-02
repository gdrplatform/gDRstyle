# Install all package dependencies from yaml file for building image purposes

Install all package dependencies from yaml file for building image
purposes

## Usage

``` r
installAllDeps(
  additionalRepos = NULL,
  base_dir = "/mnt/vol",
  use_ssh = FALSE,
  test_mode = FALSE
)
```

## Arguments

- additionalRepos:

  List of additional Repos

- base_dir:

  String of base working directory.

- use_ssh:

  logical, if use ssh keys

- test_mode:

  logical, whether to run the function in the test mode (if TRUE the
  dependencies are not installed but only listed)

## Value

`NULL`

## Examples

``` r
installAllDeps(
  base_dir = system.file(package = "gDRstyle", "testdata"),
  test_mode = TRUE
)
#> $testthat
#> $testthat$source
#> [1] "CRAN"
#> 
#> $testthat$ver
#> [1] ">= 3.0.0"
#> 
#> 
#> $R
#> $R$source
#> [1] "CRAN"
#> 
#> $R$ver
#> [1] ">= 4.2"
#> 
#> 
```
