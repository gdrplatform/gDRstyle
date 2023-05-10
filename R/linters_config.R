gDR_undesirable_functions <-
  lintr::modify_defaults(
    defaults = lintr::default_undesirable_functions,
    "library" = NULL,
    # we prefer not to use these functions because we use data.table as the primary data format
    "assert_data_frame",
    "rbind.fill"
  )

#' @noRd
linters_config <- 
  lintr::linters_with_defaults(
    cyclocomp_linter = NULL,
    line_length_linter = lintr::line_length_linter(120),
    object_name_linter = NULL,
    seq_linter = NULL,
    trailing_blank_lines_linter = NULL,
    trailing_whitespace_linter = NULL,
    object_usage_linter = NULL,
    object_length_linter = NULL,
    undesirable_function_linter = lintr::undesirable_function_linter(fun = gDR_undesirable_functions)
  )
