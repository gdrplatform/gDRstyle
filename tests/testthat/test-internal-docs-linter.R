lint_docs <- function(lines) {
  f <- withr::local_tempfile(fileext = ".R")
  writeLines(lines, f)
  lintr::lint(f, linters = list(internal_docs_linter()))
}

testthat::test_that("internal_docs_linter flags a documented function without a marker", {
  res <- lint_docs(c("#' Title only", "foo <- function(x) x"))
  testthat::expect_length(res, 1L)
})

testthat::test_that("internal_docs_linter accepts @export", {
  res <- lint_docs(c("#' Title", "#' @export", "foo <- function(x) x"))
  testthat::expect_length(res, 0L)
})

testthat::test_that("internal_docs_linter accepts @noRd", {
  res <- lint_docs(c("#' @noRd", "foo <- function(x) x"))
  testthat::expect_length(res, 0L)
})

testthat::test_that("internal_docs_linter accepts @keywords internal", {
  res <- lint_docs(c("#' @keywords internal", "foo <- function(x) x"))
  testthat::expect_length(res, 0L)
})

testthat::test_that("internal_docs_linter ignores undocumented functions", {
  res <- lint_docs(c("foo <- function(x) x", "bar <- lapply(1, function(z) z)"))
  testthat::expect_length(res, 0L)
})
