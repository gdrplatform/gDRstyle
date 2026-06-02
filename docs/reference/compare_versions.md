# Compare listed package versions dependencies.

Compare listed package versions in the dependencies.yaml file as
compared to the package DESCRIPTION file.

## Usage

``` r
compare_versions(rp, desc)
```

## Arguments

- rp:

  Named list of package version requirements specified by rplatform
  `dependencies.yaml`.

- desc:

  Named list of package version requirements specified by package
  `DESCRIPTION` file.

## Value

Character vector of any misaligned package versions between rplatform
`dependencies.yaml` and package `DESCRIPTION`.
