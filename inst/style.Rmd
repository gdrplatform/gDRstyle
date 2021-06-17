# gDR style

## General R code

1. Indentation
  * 2 spaces for indentation
2. Use of spaces
  * Always utilize `if (` over `if(`
  * Always include spaces around logical comparison `1 == 1` over `1==1`
  * Always include spaces around logical entity `if (1 == 1) {}` over `if (1=1){}`
  * Always include spaces around "full" subsets `[ , subset]` over `[, subset]`
3. Naming conventions
  * variables
    * Utilize lower_snake_case for variables
    * Assignment should use `<-` over `=`
    * variable name should reflect proper tense `validated_se <- validate_SE()` over `validate_se <- validate_SE()`
  * function arguments
    * Utilize space between function arguments `function(a = "A")` over `function(a="A")`
    * Utilize lower_snake_case for function arguments `function(big_matrix)` over `function(bigMatrix)`
  * function names
    * All action functions should start with verbs `compute_metrics_SE` over `metrics_SE`
    * All internal functions start with a `.`
    * Utilize lowerCamelCase for function names
    * Function names should be short and informative
    * Getters should start with `get*`, setters should start with `set*`, boolean checkers should start with `is*`
4. Functions, functions, functions
  * Functions definition
    * Functions definition should start on the same line as function name
    * Every parameter should be in separate line
    * Prepare separate functions for complicated defaults (of function parameters)
```{r}
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

  * Function assignment
    * Always utilize `<-` over `=` to differentiate function arguments assignments from function assignments `myFunction <- function()` over `myFunction = function()`
  * Function export
    * All internal functions are not exported
    * All exported functions have `assert` tests for their parameters
  * `vapply` over `sapply` (or `lapply` + `unlist()` if predefining FUN.VALUE is difficult)
  * Do not use `apply` on data.frame(s) (`mapply` is good for row-wise operations) 
  * Function returns
    * Use implicit returns over explicit
```
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
6. Use of curly braces
  * `if` and `else` statements should be surrounded by curly braces on the same line

```{r}
if (TRUE) {
  NULL
} else {
  NULL
}
```

  * Assign simple if-else statements to a variable.
```{r}
what_is_going_on <- if (is_check()) {
  flog <- "it's getting hot..."
} else if (is_mate()) {
  flog <- "Oh noooo..."
} else {
  flog <- "there is a hope..."
}
```

8. Files
  * Where possible, break code into smaller files
  * Separate each function by 2 lines
  * Tests should be named identically to the file in `R/` (`R/assays` => `tests/testthat/test-assays.R`)
9. Namespacing
  * Only double colon namespace packages that are not imported in `package.R`
  * Common packages should all be imported in `package.R`
    + this includes: `checkmate`, `SummarizedExperiment`, etc.
10. Tests
  * `expect_equal(obs, exp)` over `expect_equal(exp, obs)`
11. Miscellaneous
  * Exponentiation: always utilize `^` over `**` for exponentiation like `2 ^ 3` over `2**3`.
  * Numerics: place `0`'s in front of decimals like `0.1` over `.1`
  * Use named indexing over positional indexing `df[, "alias"] <- df[, "celllinename"]` over `df[, 1] <- df[, 2]`
  * If anything is hardcoded (i.e. numbers or strings), consider refactoring by introducing additional function arguments or inserting logic over numbers.
    * `df[, fxn_that_returns_idx(x):length(x)] <- NA` over `df[, 2:length(x)] <- NA`
  * Reassign repeated logic to a variable computed only once.
```
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

## General Shiny code
1. Do not use absolute IDs (non-namespaced IDs) inside modules. It breaks their modularity.
2. When adding an identifier to an element in order to style it with CSS, always prefer classes over IDs, as they work more naturally with modules and they can be reused.
3. Avoid inline CSS styles.
4. In CSS file, each rule should be on its own line.
5. Avoid using percentages for widths; instead, use bootstrap's grid system by specifying columns.
