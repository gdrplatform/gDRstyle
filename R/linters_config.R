#' @noRd
linters_config <- lintr::linters_with_defaults(
  cyclocomp_linter = NULL,
  line_length_linter = lintr::line_length_linter(120),
  object_name_linter = NULL,
  seq_linter = NULL,
  trailing_blank_lines_linter = NULL,
  trailing_whitespace_linter = NULL,
  object_usage_linter = NULL,
  object_length_linter = NULL
)
