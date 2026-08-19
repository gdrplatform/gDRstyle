# consecutive_spaces_linter

Flag runs of two or more internal spaces, e.g. alignment padding before
`<-`/`=` (`x <- 1`) or extra spaces after a comma (`f(a, b)`). Leading
indentation, trailing whitespace, and spaces inside string literals or
comments (including alignment before an end-of-line comment) are
ignored.

## Usage

``` r
consecutive_spaces_linter()
```

## Value

linter class function

## Author

Bartosz Czech <bartosz.czech@contractors.roche.com>

## Examples

``` r
linters_config <- lintr::linters_with_defaults(
  consecutive_spaces_linter = consecutive_spaces_linter()
)
```
