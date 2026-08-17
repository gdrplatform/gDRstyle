#' @keywords internal
.stop_on_violations <- function(violations, header) {
  if (length(violations) > 0L) {
    stop(header, ":\n",
         paste0("  ", vapply(violations, `[[`, "", "msg"), collapse = "\n"))
  }
  message(header, ": OK!")
  invisible(NULL)
}

#' @keywords internal
.check_ticket_refs <- function(strings, pattern, label) {
  violations <- list()
  for (i in seq_along(strings)) {
    if (grepl(pattern, strings[[i]], perl = TRUE)) {
      violations <- c(violations, list(list(
        index = i,
        msg = sprintf("%s contains a Jira ticket reference: '%s'",
                      label, sub("\n.*$", "", strings[[i]]))
      )))
    }
  }
  violations
}

#' @keywords internal
.extract_template_headers <- function(template_path) {
  lines <- readLines(template_path, warn = FALSE)
  trimws(grep("^#{1,2} ", lines, value = TRUE), which = "right")
}

#' @keywords internal
.check_pr_template <- function(body, headers) {
  violations <- list()
  for (h in headers) {
    if (!grepl(h, body, fixed = TRUE)) {
      violations <- c(violations, list(list(
        header = h,
        msg = sprintf("PR body is missing required section header: '%s'", h)
      )))
    }
  }
  violations
}

#' Lint commit messages for parenthesized Jira ticket references
#'
#' The ticket ID belongs in the branch name only. Commit messages must not
#' carry a parenthesized reference such as \code{(GDR-1234)}.
#'
#' @param messages character vector of full commit messages.
#'
#' @return \code{NULL} invisibly if no violations are found. Stops with an
#'   error listing all violations otherwise.
#'
#' @examples
#' lintCommitMessages("fix: correct edge case in parser")
#'
#' @keywords linter
#' @export
lintCommitMessages <- function(messages) {
  checkmate::assert_character(messages, any.missing = FALSE)
  violations <- .check_ticket_refs(messages, "\\(GDR-[0-9]+\\)", "commit message")
  .stop_on_violations(violations, "Commit message lint violations")
}

#' Lint a PR title for Jira ticket references
#'
#' The ticket ID belongs in the branch name only. The PR title must not
#' carry any reference such as \code{GDR-1234} or \code{(GDR-1234)}.
#'
#' @param title character(1) PR title.
#'
#' @return \code{NULL} invisibly if no violations are found. Stops with an
#'   error otherwise.
#'
#' @examples
#' lintPrTitle("feat: add contribution linter")
#'
#' @keywords linter
#' @export
lintPrTitle <- function(title) {
  checkmate::assert_string(title)
  violations <- .check_ticket_refs(title, "GDR-[0-9]+", "PR title")
  .stop_on_violations(violations, "PR title lint violations")
}

#' Check a PR body against the gDR PR template
#'
#' Verifies that the PR body contains every section header from the
#' repository's \code{PULL_REQUEST_TEMPLATE.md}, so the template is actually
#' filled in rather than deleted.
#'
#' @param body character(1) PR body.
#' @param template_path character(1) path to the \code{PULL_REQUEST_TEMPLATE.md}
#'   file.
#'
#' @return \code{NULL} invisibly if no violations are found. Stops with an
#'   error listing the missing headers otherwise.
#'
#' @examples
#' tmpl <- tempfile()
#' writeLines(c("# Description", "## What changed?"), tmpl)
#' checkPrTemplate("# Description\n## What changed?\ndetails", tmpl)
#'
#' @keywords linter
#' @export
checkPrTemplate <- function(body, template_path) {
  checkmate::assert_string(body)
  checkmate::assert_file_exists(template_path)
  headers <- .extract_template_headers(template_path)
  violations <- .check_pr_template(body, headers)
  .stop_on_violations(violations, "PR template lint violations")
}
