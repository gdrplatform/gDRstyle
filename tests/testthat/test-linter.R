library(testthat)
library(gDRstyle)

test_that("linting functions work as expected", {
  # Bad.
  expect_error(lintPkg(file.path("tst_pkgs", "dummy_pkg_errors")), regex = "Found lints")
  expect_error(lintPkgDirs(file.path("tst_pkgs", "dummy_pkg_errors")), regex = "*test.R")
})
