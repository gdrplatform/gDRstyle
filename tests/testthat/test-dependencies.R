testthat::test_that("checkDependencies works as expected", {
  testthat::expect_error(checkDependencies(
    dep_path = system.file(
      package = "gDRstyle", "testdata", "rplatform", "dependencies.yaml"
    ),
    desc_path = system.file(package = "gDRstyle", "testdata", "DESCRIPTION"),
    combo_path = system.file(
      package = "gDRstyle", "testdata", "rplatform", "dependencies_combo.yaml"
    )
  ),
    regex = avoid_new_lines("misaligned package versions between
      'rplatform/dependencies.yaml' and package 'DESCRIPTION' file: B")
  )
})

testthat::test_that("skiping in checkDependencies works as expected", {
  checkDependencies(
    dep_path = system.file(
      package = "gDRstyle",
      "testdata", "rplatform", "dependencies-NonDescription.yaml"
    ),
    desc_path = system.file(package = "gDRstyle", "testdata", "DESCRIPTION"),
    combo_path = system.file(
      package = "gDRstyle",
      "testdata", "rplatform", "dependencies_combo.yaml"
    )
  )
})

testthat::test_that("compare_versions works as expected", {
  rp <- list("A" = ">= 1.0.0", B = ">= 1.2.1")
  desc <- list("A" = ">= 1.0.0", B = ">=1.2.2")
  testthat::expect_equal(gDRstyle:::compare_versions(rp, rp), NULL)
  testthat::expect_equal(gDRstyle:::compare_versions(rp, desc), "B")
  testthat::expect_error(gDRstyle:::compare_versions(rp, desc[1]))

  rp2 <- list("A" = ">= 1.0.0", C = ">= 1.2.1")
  desc2 <- list("A" = ">= 1.0.0", C = "*")
  testthat::expect_equal(gDRstyle:::compare_versions(rp2, desc2), "C")
})
