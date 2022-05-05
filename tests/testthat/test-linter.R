test_that("linting functions work as expected", {
  # Bad.
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg_errors")
  expect_error(withr::with_dir(pkg_path, lintPkg(".")), regex = "Found lints")
  expect_error(withr::with_dir(pkg_path, lintPkgDirs(".")), regex = "*test.R")

  # Good.
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
  expect_error(withr::with_dir(pkg_path, lintPkg(".")), NA)
  expect_error(withr::with_dir(pkg_path, lintPkgDirs(".")), NA)
})
