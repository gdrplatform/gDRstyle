testthat::test_that("package check works correct", {
  dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")

  # FAIL ON ERROR CHECK
  testthat::expect_no_error(checkPackage("fakePkg", dir, fail_on = "error"))
  # STRICT CHECK ON NOTES WITH VALID NOTES USED
  testthat::expect_no_error(checkPackage("fakePkg", dir, fail_on = "note"))
})
