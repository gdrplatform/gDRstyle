#' @noRd
linter_helper_function <- if (packageVersion("lintr") >= "3.0.0") {
  lintr::linters_with_defaults
} else {
  lintr::with_defaults
}
linters_config <- linter_helper_function(
  cyclocomp_linter = NULL,
  line_length_linter = lintr::line_length_linter(120),
  object_name_linter = NULL,
  seq_linter = NULL,
  trailing_blank_lines_linter = NULL,
  trailing_whitespace_linter = NULL,
  object_usage_linter = NULL,
  object_length_linter = NULL
)
