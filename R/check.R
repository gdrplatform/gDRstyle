# Let's assume there is a valid note:
#
# > checking R code for possible problems ... NOTE
# mini_facile_app: no visible binding for '<<-' assignment to ‘CONFIG’
#
# and we want every other note in this section (and others) to fail check.
# Accepted NOTE has 2 lines, therefore the length = 2. Then we want to
# check whether the content of this NOTE is correct, so we take one of the lines
# (eg. index_to_check = 2) and grep for content of this line 
# (eg. text_to_check = "assignment to" )
# This will result in any other NOTE failing check
#
# For instance if we take:
#
#   list(
#     list(length = 2, index_to_check = 2, text_to_check = "assignment to")
#   )
#
# then following NOTE will be treated as invalid
# > checking R code for possible problems ... NOTE
# mini_facile_app: no visible binding for '<<-' assignment to ‘CONFIG’
# sandbox_app : sandboxUI: no visible binding for global variable
# ‘pcg_path’
# Undefined global functions or variables:
#  pcg_path
#
test_notes_check <- function(check_results, valid_notes_list) {
  if (!is.null(check_results$notes)) {
    NOTEs <- strsplit(check_results$notes, "\n")
    
    is_note_valid <- vapply(NOTEs, function(note) {
      any(vapply(valid_notes_list, function(valid_note) {
        length_check <- length(note) == valid_note$length
        text_check <- grepl(valid_note$text_to_check, note[valid_note$index_to_check])
        length_check && text_check
      }, FUN.VALUE = logical(1)))
    }, FUN.VALUE = logical(1))
    
    if (!all(is_note_valid)) {
      stop("Check found unexpected NOTEs: \n", 
           paste0(check_results$notes[!is_note_valid], collapse = " "))
    }
  }
}

load_valid_notes <- function(repo_dir) {
  file_dir <- file.path(repo_dir,'rplatform','valid_notes2.R')
  
  if (file.exists(file_dir)) {
    source(file_dir)
  } else {
    list()
  }
}

test_notes <- function(check, repo_dir) {
  valid_notes <- load_valid_notes(repo_dir)
  
  if (length(valid_notes)) {
    test_notes_check(check, valid_notes)
  }
}

#' Check package
#'
#' @param pkgName String of package name.
#' @param pkgDir String of path to package directory.
#' @param repoDir String of path to repository directory.
#'
#' @export
checkPackage <- function(pkgName, repoDir, subdir = NULL, fail_on = "warning") {

  pkgDir <- if (is.null(subdir) || subdir == "~") {
    file.path(repoDir)
  } else {
    options(pkgSubdir = subdir)
    file.path(repoDir, subdir)
  }

  # stop on warning in tests if 'fail_on' level is below 'error'
  stopOnWarning <- if (fail_on %in% c("warning", "note")) {
    TRUE
  } else {
    FALSE
  }
  
  stopifnot(
    dir.exists(repoDir),
    dir.exists(pkgDir)
  )

  cat("Lint")
  gDRstyle::lintPkgDirs(pkgDir)
  
  cat("Tests")
  testthat::test_local(pkgDir, stop_on_failure = TRUE, stop_on_warning = stopOnWarning)
  
  cat("Check")
  check <- rcmdcheck::rcmdcheck(
    pkgDir, 
    error_on = fail_on, 
    args = c("--no-build-vignettes", "--no-examples", "--no-manual", "--no-tests")
  )
  
  test_notes(check, repoDir)
  
  depsYaml <- file.path(repoDir, "rplatform", "dependencies.yaml")
  if (file.exists(depsYaml)) {
    cat("Deps")
    gDRstyle::checkDependencies(
      desc_path = file.path(pkgDir, "DESCRIPTION"), 
      dep_path = depsYaml
    )
  }
}
