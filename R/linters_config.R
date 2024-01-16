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
    "read.csv" = "pleae use `data.table::fread` instead (data.table is primary data format)",
    "as.data.frame" = "please use `data.table::as.data.table` instead (data.table is primary data format)",
    "reshape2" = "please use functions from `data.table` package (data.table is primary data format)"
  )

#' @noRd
linters_config <- 
  lintr::linters_with_defaults(
    cyclocomp_linter = NULL,
    indentation_linter = NULL,
    line_length_linter = lintr::line_length_linter(120),
    object_name_linter = NULL,
    seq_linter = NULL,
    trailing_blank_lines_linter = NULL,
    trailing_whitespace_linter = NULL,
    object_usage_linter = NULL,
    object_length_linter = NULL,
    undesirable_function_linter = lintr::undesirable_function_linter(fun = gDR_undesirable_functions)
  )
