testthat::test_that("custom `gDR_undesirable_functions` works as expected", {
  linters_config <- lintr::linters_with_defaults(
    undesirable_function_linter = lintr::undesirable_function_linter(fun = gDR_undesirable_functions)
  )
  file <- system.file("testdata", "dummy_functions_df.R", package = "gDRstyle")
  lint_results <- lintr::lint(file, linters = linters_config)
  lint_results_df <- data.frame(lint_results, stringsAsFactors = FALSE)
  testthat::expect_equal(lint_results_df$line_number, c(7L, 19L))
  testthat::expect_true(all(grepl("\"assert_data_frame\"|\"rbind.fill\"", lint_results_df$message)))
})