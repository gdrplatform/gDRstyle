# Detect the R package that owns an Rmd file

Walks up the directory tree (max 6 levels) looking for a `DESCRIPTION`
file. A `DESCRIPTION` found more than 4 levels above the Rmd is
considered unrelated (e.g. a workspace root or Docker volume ancestor)
and `NULL` is returned with a warning.

## Usage

``` r
.detectHostPackage(rmd_path)
```

## Arguments

- rmd_path:

  string path to the Rmd file.

## Value

string package name, or `NULL` if not found.
