library(testthat)
library(gDRstyle)

test_that("linting functions work as expected", {
  # Bad.
  pkg_path <- file.path("tst_pkgs", "dummy_pkg_errors")
  print(getwd())
  expect_error(withr::with_dir(pkg_path), print(getwd()))
  expect_error(withr::with_dir(pkg_path, lintPkg(".")), regex = "Found lints")
  expect_error(withr::with_dir(pkg_path, lintPkgDirs(".")), regex = "*test.R")
})
