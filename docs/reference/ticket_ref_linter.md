# ticket_ref_linter

Flag Jira ticket references such as `GDR-<id>` left in the source (in
code, comments, or strings). The ticket ID belongs in the branch name
only, never in the committed source. A reference inside a `TODO` or
`FIXME` comment is allowed, since it legitimately links deferred work to
the ticket that tracks it.

## Usage

``` r
ticket_ref_linter()
```

## Value

linter class function

## Author

Bartosz Czech <bartosz.czech@contractors.roche.com>

## Examples

``` r
linters_config <- lintr::linters_with_defaults(
  ticket_ref_linter = ticket_ref_linter()
)
```
