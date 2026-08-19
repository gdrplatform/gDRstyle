# Check a PR body against the gDR PR template

Verifies that the PR body contains every section header from the
repository's `PULL_REQUEST_TEMPLATE.md`, so the template is actually
filled in rather than deleted.

## Usage

``` r
checkPrTemplate(body, template_path)
```

## Arguments

- body:

  character(1) PR body.

- template_path:

  character(1) path to the `PULL_REQUEST_TEMPLATE.md` file.

## Value

`NULL` invisibly if no violations are found. Stops with an error listing
the missing headers otherwise.

## Examples

``` r
tmpl <- tempfile()
writeLines(c("# Description", "## What changed?"), tmpl)
checkPrTemplate("# Description\n## What changed?\ndetails", tmpl)
#> PR template lint violations: OK!
```
