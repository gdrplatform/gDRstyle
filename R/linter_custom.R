#' roxygen_author_tag_linter
#'
#' Check that function has documented specific tag in Roxygen skeleton (default \code{@@author}).
#'
#' @param tag character (default \code{@@author})
#'
#' @return \code{\link[lintr]{Linter}}
#' @export
#'
#' @import lintr
#'
#' @examples
#' \dontrun{
#'   linters_config <- lintr::with_defaults(
#'   line_length_linter = lintr::line_length_linter(120),
#'   roxygen_author_tag_linter = roxygen_author_tag_linter()
#'   )
#' }
roxygen_author_tag_linter <- function(tag = "@author") {
  stopifnot(length(tag) == 1, nzchar(tag))

  Linter(function(source_file) {
    lapply(
      ids_with_token(source_file, "FUNCTION"),
      function(id) {

        parsed <- with_id(source_file, id)
        flines <- rev(readLines(source_file$filename)[1:parsed$line1 - 1L])
        # drop lines without prefix `#'`
        idx <- NA
        for (i in seq_len(length(flines))) {
          if (grepl(pattern = "@noRd", flines[i])) # skip check if @noRd tag is present
            return()
          else if (grepl(pattern = "^#'", flines[i]))
            idx <- i
          else
            break
        }

        # if idx is NA it means function has no documentation - skip check because
        # it may be some internal function or part of apply, e.g. sapply(vector, function(x) ..
        if (is.na(idx))
          return()

        # drop lines after one without prefix `#'`
        flines_strip <- flines[seq_len(length(idx))]

        # check if tag exists
        is_tag_found <- any(sapply(flines_strip, function(x) grepl(pattern = tag, x), USE.NAMES = FALSE))

        if (!is_tag_found) {
          Lint(
            filename = source_file$filename,
            line_number = parsed$line1,
            column_number = parsed$col1,
            type = "style",
            message = sprintf("Tag \"%s\" not found in Roxygen skeleton.", tag),
            line = source_file$lines[as.character(parsed$line1)]
          )
        }

      })
  })
}
