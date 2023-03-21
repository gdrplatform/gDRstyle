#' Lint select subdirectories in a package directory.
#'
#' @param pkg_dir String of path to package directory.
#' @param shiny Boolean of whether or not a \code{shiny} directory should
#' also be lint.
#' Defaults to the current directory.
#'
#' @examples
#' lintPkgDirs(pkg_dir= ".")
#'
#' @return \code{NULL} invisibly.
#' @details
#' Will look for files in the following directories:
#' \code{"R"}, \code{"tests"}, and conditionally \code{"inst/shiny"}
#' if \code{shiny} is \code{TRUE}.
#' @export
lintPkgDirs <- function(pkg_dir = ".", shiny = FALSE) {
  dirs <- c("R", "tests")
  if (shiny) {
    dirs <- c(dirs, file.path("inst", "shiny"))
  }

  failures <- NULL
  for (sub_dir in dirs) {
    failure <- lintDir(pkg_dir = pkg_dir, sub_dir = sub_dir)
    failures <- c(failures, failure)
  }
  if (!is.null(failures)) {
    stop(sprintf(
      "Found linter failures in files: '%s'",
      paste0(failures, collapse = ", ")
    ))
  } else {
    message("All files OK!")
  }
  invisible(NULL)
}


#' @importFrom lintr lint
#' @keywords internal
lintDir <- function(pkg_dir = ".", sub_dir) {
  path <- file.path(pkg_dir, sub_dir)
  if (dir.exists(path)) {
    files <- list.files(
      path,
      full.names = TRUE,
      recursive = TRUE,
      pattern = "*.R"
    )
    failures <- NULL
    for (f in files) {
      message(sprintf("Linting file: %s", f))
      result <- lint(f, linters = linters_config)
      if (length(result) > 0L) {
        message(result)
        failures <- c(failures, f)
      }
    }
  } else {
    stop(sprintf("directory: '%s' does not exist to lint", path))
  }
  if (!is.null(failures)) {
    return(failures)
  }
  return(invisible(NULL))
}

#' Avoid new lines in sprintf output. Function helps to avoid line lenght
#' limits without affecting sprintf output
#'
#' @param fmt string, formatted as sprintf input
#'
#' @examples
#' sprintf(avoid_new_lines(
#'   "Lorem ipsum dolor sit amet, %s adipiscing elit, sed do eiusmod
#'   tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim
#'   veniam."
#' ), "consectetur")
#'
#' @return string
#' @export
avoid_new_lines <- function(fmt) {
  gsub("[[:space:]]{2,}", " ", fmt)
}
