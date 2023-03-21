library(testthat); library(gDRstyle)

test_that("checkDependencies works as expected", {
  expect_error(checkDependencies(
    dep_path = system.file(package = "gDRstyle", "testdata", "rplatform", "dependencies.yaml"),
    desc_path = system.file(package = "gDRstyle", "testdata", "DESCRIPTION"),
    combo_path = system.file(package = "gDRstyle", "testdata", "rplatform", "dependencies_combo.yaml")
  ),
  regex = "misaligned package versions between 'rplatform/dependencies.yaml'.+and package 'DESCRIPTION' file: B")
})

test_that("skiping in checkDependencies works as expected", {
  checkDependencies(
    dep_path = system.file(package = "gDRstyle", "testdata", "rplatform", "dependencies-NonDescription.yaml"),
    desc_path = system.file(package = "gDRstyle", "testdata", "DESCRIPTION"),
    combo_path = system.file(package = "gDRstyle", "testdata", "rplatform", "dependencies_combo.yaml")
  )
})

test_that("compare_versions works as expected", {
  rp <- list("A" = ">= 1.0.0", B = ">= 1.2.1")
  desc <- list("A" = ">= 1.0.0", B = ">=1.2.2")
  expect_equal(gDRstyle:::compare_versions(rp, rp), NULL)
  expect_equal(gDRstyle:::compare_versions(rp, desc), "B")
  expect_error(gDRstyle:::compare_versions(rp, desc[1]))

  rp2 <- list("A" = ">= 1.0.0", C = ">= 1.2.1")
  desc2 <- list("A" = ">= 1.0.0", C = "*")
  expect_equal(gDRstyle:::compare_versions(rp2, desc2), "C")
})
