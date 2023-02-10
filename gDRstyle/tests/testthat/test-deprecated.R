testthat::test_that("verify deprecated function", {
  testthat::expect_warning(
    lintPkgInDir(system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")),
    regexp = "is deprecated"
  )
})
