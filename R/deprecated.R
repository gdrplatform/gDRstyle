#' Lint select subdirectories in a package directory.
#' @param pkg_dir String of path to package directory.
#' Defaults to the current directory.
#' @return \code{NULL} invisibly.
#' @export
lintPkgInDir <- function(pkg_dir = ".") {
  .Deprecated("lintPkgDirs")
  lintPkgDirs(pkg_dir = pkg_dir)
}



