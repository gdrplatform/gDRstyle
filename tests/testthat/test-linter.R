library(testthat)
library(gDRstyle)

test_that("linting functions work as expected", {
  # Bad.
  expect_error(lintPkg("dummy_pkg_errors"), regex = "Found lints")
  expect_error(lintPkgDirs("dummy_pkg_errors"), regex = "*test.R")
})
