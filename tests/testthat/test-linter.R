library(testthat)
library(gDRstyle)

test_that("linting functions work as expected", {
  devtools::wd()
  expect_error(lintPkg(), regex = "Found lints")
  expect_error(lintPkgDirs(), regex = "*test.R")
})
