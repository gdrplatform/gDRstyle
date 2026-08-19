# internal_docs_linter

Flag a documented function whose Roxygen block does not declare its
visibility. Every function with a `#'` block must carry `@export`,
`@noRd`, or `@keywords internal`, so internal helpers do not leak into
`NAMESPACE` or the pkgdown reference. Undocumented functions (including
inline/anonymous ones) are ignored.

## Usage

``` r
internal_docs_linter()
```

## Value

linter class function

## Author

Bartosz Czech <bartosz.czech@contractors.roche.com>

## Examples

``` r
linters_config <- lintr::linters_with_defaults(
  internal_docs_linter = internal_docs_linter()
)
```
