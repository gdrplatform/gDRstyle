lint_lines <- function(lines) {
  f <- withr::local_tempfile(fileext = ".R")
  writeLines(lines, f)
  lintr::lint(f, linters = list(consecutive_spaces_linter()))
}

testthat::test_that("consecutive_spaces_linter flags alignment before operators", {
  res <- lint_lines("x   <- 1")
  testthat::expect_length(res, 1L)
  testthat::expect_equal(res[[1L]]$line_number, 1L)
})

testthat::test_that("consecutive_spaces_linter flags double space after comma", {
  res <- lint_lines("f(a,  b)")
  testthat::expect_length(res, 1L)
})

testthat::test_that("consecutive_spaces_linter ignores leading indentation", {
  res <- lint_lines(c("foo <- function() {", "    x <- 1", "}"))
  testthat::expect_length(res, 0L)
})

testthat::test_that("consecutive_spaces_linter ignores spaces inside strings", {
  res <- lint_lines('s <- "a    b"')
  testthat::expect_length(res, 0L)
})

testthat::test_that("consecutive_spaces_linter ignores comments and aligned trailing comments", {
  res <- lint_lines(c("# a    padded comment", "z <- 1   # aligned comment"))
  testthat::expect_length(res, 0L)
})

testthat::test_that("consecutive_spaces_linter accepts single-spaced code", {
  res <- lint_lines(c("ok <- foo(a, b)", "df[, x]"))
  testthat::expect_length(res, 0L)
})
