test_that("custom linter `roxygen_tag_linter` works as expected", {
  linters_config <- lintr::with_defaults(
    roxygen_tag_linter = roxygen_tag_linter()
  )
  file <- system.file("testdata", "dummy_functions.R", package = "gDRstyle")
  lint_results <- lintr::lint(file, linters = linters_config)
  lint_results_df <- data.frame(lint_results, stringsAsFactors = FALSE)
  testthat::expect_equal(lint_results_df$line_number, c(6L, 26L))
  testthat::expect_true(all(grepl("Tag \"@author\" not found in Roxygen skeleton.", lint_results_df$message)))
})
