# Avoid new lines in sprintf output. Function helps to avoid line lenght limits without affecting sprintf output

Avoid new lines in sprintf output. Function helps to avoid line lenght
limits without affecting sprintf output

## Usage

``` r
avoid_new_lines(fmt)
```

## Arguments

- fmt:

  string, formatted as sprintf input

## Value

string

## Examples

``` r
sprintf(avoid_new_lines(
  "Lorem ipsum dolor sit amet, %s adipiscing elit, sed do eiusmod
  tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
  veniam."
), "consectetur")
#> [1] "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam."
```
