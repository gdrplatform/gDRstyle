testthat::test_that("package check works correct", {
  dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")

  # FAIL ON ERROR CHECK
  testthat::expect_no_error(checkPackage("fakePkg", dir, fail_on = "error"))
})
