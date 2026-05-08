gDR_undesirable_operators <-
  lintr::modify_defaults(
    defaults = lintr::default_undesirable_operators,
    "%>%" = "please use base R syntax instead of magrittr pipe",
    "|>" = "please use base R syntax instead of native pipe"
  )

gDR_undesirable_functions <-
  lintr::modify_defaults(
    defaults = lintr::default_undesirable_functions,
    "library" = NULL,
    # we use also these functions in our code but it would be cleaned eventually
    "mapply" = NULL,
    "options" = NULL,
    "source" = NULL,
    "Sys.setenv" = NULL,
    "structure" = NULL,
    # we prefer not to use these functions because we use data.table as the primary data format
    "assert_data_frame" = "please use `checkmate::assert_data_table` instead (data.table is primary data format)",
    "rbind.fill" = "please use `data.table::rbindlist` instead (data.table is primary data format)",
    "read.csv" = "please use `data.table::fread` instead (data.table is primary data format)",
    "as.data.frame" = "please use `data.table::as.data.table` instead (data.table is primary data format)",
    "reshape2" = "please use functions from `data.table` package (data.table is primary data format)",
    "debug" = NULL
  )

#' @noRd
linters_config <-
  if (packageVersion("lintr") < "3.2.0") {
    lintr::linters_with_defaults(
      cyclocomp_linter = lintr::cyclocomp_linter(complexity_limit = 25),
      indentation_linter = NULL,
      line_length_linter = lintr::line_length_linter(120),
      object_name_linter = NULL,
      object_usage_linter = NULL,
      object_length_linter = NULL,
      expect_true_false_linter = lintr::expect_true_false_linter(),
      length_test_linter = lintr::length_test_linter(),
      paste_linter = lintr::paste_linter(),
      undesirable_function_linter = lintr::undesirable_function_linter(fun = gDR_undesirable_functions),
      undesirable_operator_linter = lintr::undesirable_operator_linter(op = gDR_undesirable_operators),
      yoda_test_linter = lintr::yoda_test_linter()
    )
  } else {
    lintr::linters_with_defaults(
      return_linter = NULL,
      indentation_linter = NULL,
      line_length_linter = lintr::line_length_linter(120),
      object_name_linter = NULL,
      object_usage_linter = NULL,
      object_length_linter = NULL,
      expect_true_false_linter = lintr::expect_true_false_linter(),
      length_test_linter = lintr::length_test_linter(),
      paste_linter = lintr::paste_linter(),
      undesirable_function_linter = lintr::undesirable_function_linter(fun = gDR_undesirable_functions),
      undesirable_operator_linter = lintr::undesirable_operator_linter(op = gDR_undesirable_operators),
      yoda_test_linter = lintr::yoda_test_linter()
    )
  }
