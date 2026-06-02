# Lint NEWS.md entries for style and brevity

Checks that every bullet entry in `NEWS.md` follows the gDR style
guidelines: starts with an imperative verb, is concise (no verbose
phrases, no trailing period, within the character limit), that each
version section contains at most `max_bullets` entries, and that version
headers match the expected format.

## Usage

``` r
lintNewsEntries(pkg_dir = ".", max_chars = 120L, max_bullets = 3L)
```

## Arguments

- pkg_dir:

  character(1) path to the package root directory containing `NEWS.md`.
  Defaults to the current directory.

- max_chars:

  integer(1) maximum number of characters allowed per bullet entry
  (excluding the leading `"* "`). Defaults to `120L`.

- max_bullets:

  integer(1) maximum number of bullet entries allowed per version
  section. Defaults to `3L`.

## Value

`NULL` invisibly if no violations are found. Stops with an error listing
all violations otherwise.

## Examples

``` r
pkg_dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
lintNewsEntries(pkg_dir)
#> NEWS.md OK!
```
