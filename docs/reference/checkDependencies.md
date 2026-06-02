# Check for alignment of package dependencies across Rplatform and package specifications.

Check the package depedency version specifications in the
`rplatform/dependencies.yaml` and `DESCRIPTION`.

## Usage

``` r
checkDependencies(
  dep_path,
  desc_path,
  skip_pkgs = "R",
  combo_path = "/mnt/vol/dependencies_combo.yaml"
)
```

## Arguments

- dep_path:

  String of path to the rplatform `dependencies.yaml` file.

- desc_path:

  String of the path to the package `DESCRIPTION` file.

- skip_pkgs:

  vector of packages from `DESCRIPTION` to skip; defaults to `R`

- combo_path:

  String of path to the combo image `dependencies.yaml` file. Defaults
  to the current directory.

## Value

`NULL` invisibly.

## Details

This function is used for its side effects in the event that there are
dependency clashes.

## Examples

``` r
checkDependencies(
  dep_path =
        system.file(package = "gDRstyle", "testdata", "dependencies.yaml"),
  desc_path = system.file(package = "gDRstyle", "DESCRIPTION"),
  skip_pkgs = c("testthat", "lintr")
)
```
