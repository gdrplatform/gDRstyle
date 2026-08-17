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

#' @keywords internal
.check_file_ticket_refs <- function(path) {
  if (!file.exists(path)) {
    return(list())
  }
  lines <- readLines(path, warn = FALSE)
  hits <- grep("GDR-[0-9]+", lines, perl = TRUE)
  lapply(hits, function(i) {
    list(msg = sprintf("%s:%d contains a Jira ticket reference: '%s'",
                       basename(path), i, trimws(lines[[i]])))
  })
}

#' @keywords internal
.find_pr_template <- function(pkg_dir) {
  gh <- file.path(pkg_dir, ".github", "PULL_REQUEST_TEMPLATE.md")
  if (file.exists(gh)) {
    return(gh)
  }
  gl_dir <- file.path(pkg_dir, ".gitlab", "merge_request_templates")
  if (dir.exists(gl_dir)) {
    mds <- list.files(gl_dir, pattern = "\\.md$", full.names = TRUE)
    if (length(mds) > 0L) {
      return(mds[[1L]])
    }
  }
  NULL
}

#' Lint commit messages for parenthesized Jira ticket references
#'
#' The ticket ID belongs in the branch name only. Commit messages must not
#' carry a parenthesized reference such as \code{(GDR-<id>)}.
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
#' carry any reference such as \code{GDR-<id>} or \code{(GDR-<id>)}.
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

#' Lint NEWS.md and DESCRIPTION for Jira ticket references
#'
#' The ticket ID belongs in the branch name only. It must not appear in the
#' changelog (\code{NEWS.md}) or package metadata (\code{DESCRIPTION}).
#'
#' @param pkg_dir character(1) path to the package root directory. Defaults to
#'   the current directory.
#'
#' @return \code{NULL} invisibly if no violations are found. Stops with an
#'   error listing all violations otherwise.
#'
#' @examples
#' pkg_dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
#' lintTicketRefs(pkg_dir)
#'
#' @keywords linter
#' @export
lintTicketRefs <- function(pkg_dir = ".") {
  checkmate::assert_directory_exists(pkg_dir)
  files <- file.path(pkg_dir, c("NEWS.md", "DESCRIPTION"))
  violations <- unlist(
    lapply(files, .check_file_ticket_refs),
    recursive = FALSE
  )
  .stop_on_violations(violations, "Ticket reference violations")
}

#' Lint a merge/pull request title and body
#'
#' Convenience wrapper for CI: checks the title for ticket references and, when
#' the repository ships a PR/MR template, checks that the body keeps its
#' sections. The template check is skipped (with a message) when no template is
#' present, so repositories without one are not blocked.
#'
#' @param title character(1) merge/pull request title.
#' @param body character(1) merge/pull request description.
#' @param pkg_dir character(1) path to the repository root used to locate the
#'   PR/MR template. Defaults to the current directory.
#'
#' @return \code{NULL} invisibly if no violations are found. Stops with an
#'   error otherwise.
#'
#' @examples
#' lintMergeRequest("feat: add contribution linter", "details", tempdir())
#'
#' @keywords linter
#' @export
lintMergeRequest <- function(title, body, pkg_dir = ".") {
  checkmate::assert_string(title)
  checkmate::assert_string(body)
  checkmate::assert_directory_exists(pkg_dir)
  lintPrTitle(title)
  tmpl <- .find_pr_template(pkg_dir)
  if (is.null(tmpl)) {
    message("PR template check skipped: no template found in ", pkg_dir)
  } else {
    checkPrTemplate(body, tmpl)
  }
  invisible(NULL)
}
