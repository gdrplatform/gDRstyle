test_that("linting functions work as expected", {
  # Bad.
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg_errors")
  expect_error(withr::with_dir(pkg_path, lintPkgDirs(".")), regex = "*test.R")

  # Good.
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
  expect_error(withr::with_dir(pkg_path, lintPkgDirs(".")), NA)
})

test_that("avoid_new_lines works as expected", {
  text <- "Lorem ipsum dolor sit amet, %s adipiscing elit, sed do eiusmod
    tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
    veniam."

  expect_true(grepl("\n", sprintf(text, "consectetur")))
  expect_false(grepl("\n", sprintf(avoid_new_lines(text), "consectetur")))
})
