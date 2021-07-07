library(testthat)
library(gDRstyle)

test_that("lintPkg works as expected", {
  expect_error(lintPkg("."), NA)
})
