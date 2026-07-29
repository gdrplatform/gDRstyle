# Extract R code chunks from an Rmd file

Extract R code chunks from an Rmd file

## Usage

``` r
.extractRChunks(rmd_path)
```

## Arguments

- rmd_path:

  string path to an `.Rmd` file.

## Value

A list of named lists, each with `code` (character(1)) and `start_line`
(integer(1)).
