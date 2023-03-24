#' roxygen_tag_linter
#'
#' Check that function has documented specific tag in Roxygen
#' skeleton (default \code{@author}).
#'
#' @param tag character (default \code{@author})
#'
#' @author Kamil Foltynski <kamil.foltynski@contractors.roche.com>
#'
#' @examples
#' linters_config <- lintr::with_defaults(
#'   line_length_linter = lintr::line_length_linter(120),
#'   roxygen_tag_linter = roxygen_tag_linter()
#' )
#'
#' @return linter class function
#' @export
roxygen_tag_linter <- function(tag = "@author") {

  stopifnot(length(tag) == 1, nzchar(tag))

  fun <- function(source_file) {
    lapply(
      lintr::ids_with_token(source_file, "FUNCTION"),
      function(id) {

        parsed <- lintr::with_id(source_file, id)
        flines <- rev(
          readLines(source_file$filename)[seq_len(parsed$line1 - 1L)]
        )

        idx <- skip_lines_withou_prefix(flines = flines)
        # if idx is NA it means function has no documentation - skip check
        # because it may be some internal function or part of apply,
        # e.g. sapply(vector, function(x) ..
        if (is.na(idx))
          return()
        # drop lines after one without prefix `#'`
        flines_strip <- flines[seq_len(idx)]

        # check if tag exists
        is_tag_found <- any(vapply(
          flines_strip,
          function(x) grepl(pattern = tag, x),
          USE.NAMES = FALSE,
          FUN.VALUE = logical(1)
        ))

        if (!is_tag_found) {
          lintr::Lint(
            filename = source_file$filename,
            line_number = parsed$line1,
            column_number = parsed$col1,
            type = "style",
            message = sprintf("Tag \"%s\" not found in Roxygen skeleton.", tag),
            line = source_file$lines[as.character(parsed$line1)]
          )
        }

      })
  }
  # to ensure backward compatibility, temporarily change the class by hand,
  # it future we should switch to `lintr::Linter(function(source_file) {...}`
  class(fun) <- "linter"
  fun
}

skip_lines_withou_prefix <- function(flines) {
  idx <- NA
  for (i in seq_len(length(flines))) {
    if (grepl(pattern = "@noRd", flines[i]))
      # skip check if @noRd tag is present
      return(NA)
    else if (grepl(pattern = "^#'", flines[i]))
      idx <- i
    else
      break
  }

  idx
}
