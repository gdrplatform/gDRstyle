#' Lint a package.
#'
#' Convenience function with embedded gDRplatform linting configuration.
#'
#' @param pkg_dir String of path to package directory.
#' Defaults to the current directory.
#'
#' @return \code{NULL} invisibly.
#'
#' @importFrom lintr lint_package
#' @export
lintPkg <- function(pkg_dir = ".") {
  result <- lint_package(pkg_dir, linters = linters_config)
  if (length(result) > 0L) {
    print(result)
    stop("Found lints")
  }
  invisible(NULL)
}


#' Lint select subdirectories in a package directory.
#' @param pkg_dir String of path to package directory.
#' Defaults to the current directory.
#' @return \code{NULL} invisibly.
#' @export
lintPkgInDir <- function(pkg_dir = ".") {
  .Deprecated("lintPkgDirs")
  lintPkgDirs(pkg_dir = pkg_dir)
}


#' Lint select subdirectories in a package directory.
#' @param pkg_dir String of path to package directory.
#' @param shiny Boolean of whether or not a \code{shiny} directory should
#' also be lint.
#' Defaults to the current directory.
#'
#' @return \code{NULL} invisibly.
#' @details
#' Will look for files in the following directories:
#' 
#' @export
lintPkgDirs <- function(pkg_dir = ".", shiny = FALSE) {
  dirs <- c("R", "tests")
  if (shiny) {
    dirs <- c(dirs, "shiny")
  }

  for (sub_dir in dirs) {
    lintDir(pkg_dir = pkg_dir, sub_dir = sub_dir)
  }
  print("All files OK!")
  invisible(NULL)
}


#' @importFrom lintr lint
#' @keywords internal
lintDir <- function(pkg_dir = ".", sub_dir) {
  path <- file.path(pkg_dir, sub_dir)
  if (dir.exists(path)) {
    files <- list.files(path, full.names = TRUE, recursive = TRUE, pattern = "*.R")
    failures <- NULL 
    for (f in files) {
      print(paste("Linting file:", f))
      result <- lint(f, linters = linters_config)
      if (length(result) > 0L) {
        print(result)
        failures <- c(failures, f)
      }
    }
  } else {
    stop(sprintf("directory: '%s' does not exist to lint", path))
  } 
  if (!is.null(failures)) {
    stop(sprintf("Found linter failures in files: '%s'", paste0(failures, sep = ", ")))
  }
}
