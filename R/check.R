#' Check package
#'
#' @param pkgName String of package name.
#' @param pkgDir String of path to package directory.
#' @param repoDir String of path to repository directory.
#'
#' @export
checkPackage <- function(pkgName, repoDir, subdir = NULL) {
  pkgDir <- if (is.null(subdir) || subdir == "~") {
    file.path(repoDir)
  } else {
    options(pkgSubdir = subdir)
    file.path(repoDir, subdir)
  }

  stopifnot(
    dir.exists(repoDir),
    dir.exists(pkgDir)
  )

  cat("Lint")
  gDRstyle::lintPkgDirs(pkgDir)
  
  cat("Tests")
  testthat::test_local(pkgDir, stop_on_failure = TRUE)
  
  cat("Check")
  rcmdcheck::rcmdcheck(
    pkgDir, 
    error_on = "error", 
    args = c("--no-build-vignettes", "--no-examples", "--no-manual", "--no-tests")
  )
  
  depsYaml <- file.path(repoDir, "rplatform", "dependencies.yaml")
  if (file.exists(depsYaml)) {
    cat("Deps")
    gDRstyle::checkDependencies(
      desc_path = file.path(pkgDir, "DESCRIPTION"), 
      dep_path = depsYaml
    )
  }
}
