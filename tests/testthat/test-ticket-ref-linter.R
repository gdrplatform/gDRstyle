# nolint start: ticket_ref_linter.
lint_ticket <- function(lines) {
  f <- withr::local_tempfile(fileext = ".R")
  writeLines(lines, f)
  lintr::lint(f, linters = list(ticket_ref_linter()))
}

testthat::test_that("ticket_ref_linter flags a reference in a comment", {
  res <- lint_ticket("x <- 1 # workaround for GDR-1234")
  testthat::expect_length(res, 1L)
  testthat::expect_equal(res[[1L]]$line_number, 1L)
})

testthat::test_that("ticket_ref_linter flags a reference in a string", {
  res <- lint_ticket('msg <- "see GDR-42 for context"')
  testthat::expect_length(res, 1L)
})

testthat::test_that("ticket_ref_linter flags multiple references on one line", {
  res <- lint_ticket("# GDR-1 and GDR-2")
  testthat::expect_length(res, 2L)
})

testthat::test_that("ticket_ref_linter accepts code without ticket references", {
  res <- lint_ticket(c("foo <- function(x) {", "  x + 1", "}"))
  testthat::expect_length(res, 0L)
})

testthat::test_that("ticket_ref_linter allows a reference in a TODO comment", {
  res <- lint_ticket("x <- unique(y) # TODO drop after GDR-3163")
  testthat::expect_length(res, 0L)
})

testthat::test_that("ticket_ref_linter allows a reference in a FIXME comment", {
  res <- lint_ticket("# FIXME: revisit once GDR-42 lands")
  testthat::expect_length(res, 0L)
})

testthat::test_that("ticket_ref_linter still flags a reference outside a TODO", {
  res <- lint_ticket(c(
    "# TODO clean up GDR-1 later",
    'msg <- "blocked by GDR-2"'
  ))
  testthat::expect_length(res, 1L)
  testthat::expect_equal(res[[1L]]$line_number, 2L)
})
# nolint end
