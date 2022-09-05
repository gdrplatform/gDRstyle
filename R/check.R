#' Check package
#'
#' @param pkgName String of package name.
#' @param pkgDir String of path to package directory.
#' @param repoDir String of path to repository directory.
#'
#' @export
checkPackage <- function(pkgName, repoDir, subdir) {
  pkgDir <- if(subdir) {
    file.path(repoDir, pkgName)
  } else {
    file.path(repoDir)
  }

  stopifnot(
    dir.exists(repoDir),
    dir.exists(pkgDir)
  )

  cat("Lint")
  gDRstyle::lintPkgDirs(pkgDir)
  
  cat("Tests")
  devtools::test(pkgDir, stop_on_failure = TRUE)
  
  cat("Check")
  devtools::check(pkgDir, error_on = "error", args = c('--no-build-vignettes', '--no-examples', '--no-manual', '--no-tests'))
  
  cat("Deps")
  gDRstyle::checkDependencies(
    desc_path = paste0(repoDir, '/', pkgName, '/DESCRIPTION'), 
    dep_path = paste0(repoDir, '/rplatform/dependencies.yaml')
  )
}
