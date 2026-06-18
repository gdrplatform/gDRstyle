# gDR style guide

## gDR style guide

A style guide for the gdrplatform organization.

### General R code

1.  Indentation

- 2 spaces for indentation

2.  Use of spaces

- Always utilize `if (` over `if(`
- Always include spaces around logical comparison `1 == 1` over `1==1`
- Always include spaces around logical entity `if (1 == 1) {}` over
  `if (1=1){}`
- Always include spaces around “full” subsets `[ , subset]` over
  `[, subset]`

3.  Naming conventions

- variables
  - Utilize lower_snake_case for variables
  - Assignment should use `<-` over `=`
  - variable name should reflect proper tense
    `validated_se <- validate_SE()` over `validate_se <- validate_SE()`
- function arguments
  - Utilize space between function arguments `function(a = "A")` over
    `function(a="A")`
  - Utilize lower_snake_case for function arguments
    `function(big_matrix)` over `function(bigMatrix)`
- function names
  - All action functions should start with verbs `compute_metrics_SE`
    over `metrics_SE`
  - All internal functions start with a `.`
  - Utilize lowerCamelCase for function names
  - Function names should be short and informative
  - Getters should start with `get*`, setters should start with `set*`,
    boolean checkers should start with `is*`

4.  Functions, functions, functions

- Functions definition
  - Functions definition should start on the same line as function name
  - Every parameter should be in separate line
  - Prepare separate functions for complicated defaults (of function
    parameters)

``` r
 # Good
fun <- function(param1,
                param2,
                param_with_dir_for_st_important = get_st_important_dir()) {
  # Code is indented by two spaces.
  ...
}
 # Bad
fun <- function(param1, param2, param_with_dir_for_st_important = file.path(system.file(paste(param1, "SE", "rds", sep = "."), package = "important_package"))) {
  ...
}
```

- Function assignment
  - Always utilize `<-` over `=` to differentiate function arguments
    assignments from function assignments `myFunction <- function()`
    over `myFunction = function()`
- Function export
  - All internal functions are not exported
  - All exported functions have `assert` tests for their parameters
- `vapply` over `sapply` (or `lapply` +
  [`unlist()`](https://rdrr.io/r/base/unlist.html) if predefining
  FUN.VALUE is difficult)
- Do not use `apply` on data.frame(s) (`mapply` is good for row-wise
  operations)
- Function returns
  - Use implicit returns over explicit

``` r
  # Good.
  foo <- function() {
    # Do stuff.
    x
  }
  # Bad.
  foo <- function() {
    # Do stuff.
    return(x)
  }
```

6.  Use of curly braces

- `if` and `else` statements should be surrounded by curly braces on the
  same line

``` r
if (TRUE) {
  NULL
} else {
  NULL
}
```

    ## NULL

- Assign simple if-else statements to a variable.

``` r
what_is_going_on <- if (is_check()) {
  flog <- "it's getting hot..."
} else if (is_mate()) {
  flog <- "Oh noooo..."
} else {
  flog <- "there is a hope..."
}
```

8.  Files

- Where possible, break code into smaller files
- Separate each function by 2 lines
- Tests should be named identically to the file in `R/` (`R/assays` =\>
  `tests/testthat/test-assays.R`)

9.  Namespacing

- Only double colon namespace packages that are not imported in
  `package.R`
- Common packages should all be imported in `package.R`
  - this includes: `checkmate`, `SummarizedExperiment`, etc.

10. Tests

- `expect_equal(obs, exp)` over `expect_equal(exp, obs)`
- Use specific `testthat` expectations over generic ones:
  - `expect_true(x == y)` → `expect_equal(x, y)`
  - `expect_true(x)` / `expect_false(x)` →
    `expect_true()`/`expect_false()` (not `expect_equal(x, TRUE)`)
  - `expect_equal(length(x), n)` → `expect_length(x, n)`
- Do not leave commented-out code in test files.

11. Pipes

- Do not use pipe operators (`%>%` or `|>`); use base R syntax instead.

12. String concatenation

- Use [`paste0()`](https://rdrr.io/r/base/paste.html) over
  `paste(..., sep = "")`.

13. Sequence generation

- Use `seq_len(n)` over `1:n` and `seq_along(x)` over `1:length(x)` to
  avoid off-by-one errors when `n` is zero.

14. Boolean values

- Use `TRUE`/`FALSE` instead of `T`/`F`. `T` and `F` are regular
  variables that can be overwritten (`T <- 5`).

15. NA comparisons

- Use `is.na(x)` instead of `x == NA`. The expression `x == NA` always
  returns `NA`, never `TRUE` or `FALSE`.

16. Logical operators

- Use `&&` and `||` in scalar conditions (e.g. inside `if`). Use `&` and
  `|` for element-wise operations on vectors.

17. Strings

- Use double quotes `"` instead of single quotes `'`.

18. Commented-out code

- Do not leave commented-out code in the codebase. Use version control
  instead.

19. Function complexity

- Keep cyclomatic complexity below 25. If a function exceeds this limit,
  extract logic into smaller helper functions.

20. Miscellaneous

- Exponentiation: always utilize `^` over `**` for exponentiation like
  `2 ^ 3` over `2**3`.
- Numerics: place `0`’s in front of decimals like `0.1` over `.1`
- Use named indexing over positional indexing
  `df[, "alias"] <- df[, "celllinename"]` over `df[, 1] <- df[, 2]`
- If anything is hardcoded (i.e. numbers or strings), consider
  refactoring by introducing additional function arguments or inserting
  logic over numbers.
  - `df[, fxn_that_returns_idx(x):length(x)] <- NA` over
    `df[, 2:length(x)] <- NA`
- Reassign repeated logic to a variable computed only once.

``` r
# Good.
idx <- foo()
if (length(idx) == 1) {
  f <- c(f[idx], f[-idx])
}
# Bad.
if (length(foo()) == 1) {
  f <- c(f[foo()], f[foo()])
}
```

### General Shiny code

1.  Do not use absolute IDs (non-namespaced IDs) inside modules. It
    breaks their modularity.
2.  When adding an identifier to an element in order to style it with
    CSS, always prefer classes over IDs, as they work more naturally
    with modules and they can be reused.
3.  Avoid inline CSS styles.
4.  In CSS file, each rule should be on its own line.
5.  Avoid using percentages for widths; instead, use bootstrap’s grid
    system by specifying columns.

### General package code

1.  Create file *{pkgname}-package.R* with `usethis::use_package_doc()`
2.  Update *{pkgname}-package.R* - it should have such lines:

``` r
#' @note To learn more about functions start with `help(package = "{pkgname}")`
#' @keywords internal
#' @return package help page
"_PACKAGE"
```

    ## [1] "_PACKAGE"

3.  Add in the DESCRIPTION `Roxygen: list(markdown = TRUE)`
4.  All constants, imports and side-effects tools should be in file
    *package.R*. Do not use *zzz.R*

- if some functions/packages are often used within the package, add
  `@import` or `@importFrom` always in one place - file *package.R*
- if using function from another package, use `namespace::function_name`

5.  Executes gDRstyle specific package checks with
    [`gDRstyle::checkPackage()`](https://gdrplatform.github.io/gDRstyle/reference/checkPackage.md)
    (use `bioc_check = TRUE` to verify if the requirements for
    Bioconductor are also met)

### Git best practices

1.  Follow [Conventional
    Commits](https://www.conventionalcommits.org/en/v1.0.0/)

- Commit messages should look like `<type>: <description>` where `type`
  can be one of:
  - `fix`: for bugfixes;
  - `feat`: for new features;
  - `docs`: for documentation changes;
  - `style`: for formatting changes that do not affect the meaning of
    the code;
  - `test`: for adding missing tests or correcting existing tests;
  - `refactor`: for code changes that neither fixes a bug nor adds a
    feature
  - `ci`: for changes to CI configuration
  - `chore`: for version bumps, NEWS.md updates, and build tooling
    changes

2.  Any change in code should be accompanied by a bumped version.

- new features - `MINOR` version;
- bugfixes and other changes - `PATCH` version. *Exceptions*: All public
  packages - as to-be-released on Bioconductor have version 0.99.x. Any
  changes in code should be accompanied by a bumped `MINOR` version
  regardless of the nature of the changes.

3.  If a PR does not include a version bump in `DESCRIPTION` and a
    matching entry in `NEWS.md`, the `auto-changelog` CI workflow will
    generate and commit them automatically using the PR diff.

## SessionInfo

``` r
sessionInfo()
```

    ## R version 4.6.0 (2026-04-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
    ##  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
    ##  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    ## [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] BiocStyle_2.40.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] digest_0.6.39       desc_1.4.3          R6_2.6.1           
    ##  [4] bookdown_0.47       fastmap_1.2.0       xfun_0.58          
    ##  [7] cachem_1.1.0        knitr_1.51          htmltools_0.5.9    
    ## [10] rmarkdown_2.31      lifecycle_1.0.5     cli_3.6.6          
    ## [13] sass_0.4.10         pkgdown_2.2.0       textshaping_1.0.5  
    ## [16] jquerylib_0.1.4     systemfonts_1.3.2   compiler_4.6.0     
    ## [19] tools_4.6.0         ragg_1.5.2          bslib_0.11.0       
    ## [22] evaluate_1.0.5      yaml_2.3.12         BiocManager_1.30.27
    ## [25] otel_0.2.0          jsonlite_2.0.0      rlang_1.2.0        
    ## [28] fs_2.1.0
