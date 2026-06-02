# roxygen_tag_linter

Check that function has documented specific tag in Roxygen skeleton
(default `@author`).

## Usage

``` r
roxygen_tag_linter(tag = "@author")
```

## Arguments

- tag:

  character (default `@author`)

## Value

linter class function

## Author

Kamil Foltynski <kamil.foltynski@contractors.roche.com>

## Examples

``` r
linters_config <- lintr::linters_with_defaults(
  line_length_linter = lintr::line_length_linter(120),
  roxygen_tag_linter = roxygen_tag_linter()
)
```
