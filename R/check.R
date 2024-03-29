#' Assume there is a valid note:
#' ```
#' > checking R code for possible problems ... NOTE
#' mini_app: no visible binding for '<<-' assignment to ‘CONFIG’
#' ```
#' and we want every other note in this section (and others) to fail check.
#' Accepted NOTE has 2 lines, therefore the length = 2. Then we want to
#' check whether the content of this NOTE is correct, so we take one of
#' the lines (eg. index_to_check = 2) and grep for content of this line
#' (eg. text_to_check = "assignment to" )
#' This will result in any other NOTE failing check
#' Take:
#' ````
#'   list(
#'     list(length = 2, index_to_check = 2, text_to_check = "assignment to")
#'   )
#' ``
#' then following NOTE will be treated as invalid
#' > checking R code for possible problems ... NOTE
#' mini_app: no visible binding for '<<-' assignment to ‘CONFIG’
#' sandbox_app : sandboxUI: no visible binding for global variable
#' ‘pcg_path’
#' Undefined global functions or variables:
#'  pcg_path
#' @return \code{NULL}
#' @keywords internal
test_notes_check <- function(check_results,
                             bioccheck_results,
                             valid_notes_list) {

  if (!is.null(bioccheck_results)) {
    
    # assure the length of each Bioc note will be always == 1
    bioccheck_results$note <-
      lapply(bioccheck_results$note, function(x) {
        toString(unlist(x))
      })
    check_results$notes <- c(check_results$notes,
                             unlist(bioccheck_results$note))
  }
  
  if (!is.null(check_results$notes)) {
    NOTEs <- strsplit(check_results$notes, "\n")

    is_note_valid <- vapply(NOTEs, function(note) {
      any(vapply(valid_notes_list, function(valid_note) {
        length_check <- length(note) == valid_note$length
        text_check <- grepl(
          valid_note$text_to_check,
          note[valid_note$index_to_check]
        )
        length_check && text_check
      }, FUN.VALUE = logical(1)))
    }, FUN.VALUE = logical(1))

    if (!all(is_note_valid)) {
      stop("Check found unexpected NOTEs: \n",
           paste0(check_results$notes[!is_note_valid], collapse = " "))
    }
  }
}

#' Load notes
#'
#' @param repo_dir String of path to repository directory.
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
load_valid_notes <- function(repo_dir) {
  file_dir <- file.path(repo_dir, "rplatform", "valid_notes2.R")

  local <- if (file.exists(file_dir)) {
    source(file_dir)$value
    } else {
      list()
    }
  globalPath <- system.file(package = "gDRstyle",
                            lib.loc = withr::local_libpaths(),
                            "config",
                            "note.json")
  global <- rjson::fromJSON(file = globalPath)$global
  c(local, global)
}

#' Test notes
#'
#' @param check rcmdcheck object with R CMD check results
#' @param biocCheck BiocCheck object with BiocCheck results
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
test_notes <- function(check,
                       biocCheck,
                       repo_dir) {
  valid_notes <- load_valid_notes(repo_dir)

  test_notes_check(check, biocCheck, valid_notes)
}

#' Run check
#'
#' Run R CMD check from R programmatically
#'
#' @param pkgDir String of path to package directory
#' @param repoDir String of path to repository directory.
#' @param fail_on String specifying the level at which check fail. Supported
#' values: \code{"note"}, \code{"warning"} and \code{"error"}.
#' @param run_examples Logical whether examples check should be performed
#' @param bioc_check Logical whether bioc check should be performed
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
rcmd_check_with_notes <- function(pkgDir, 
                                  repoDir, 
                                  fail_on,
                                  run_examples,
                                  bioc_check,
                                  build_vignettes, 
                                  check_vignettes,
                                  as_cran) {
  # rcmdcheck gets warning instead of note
  error_on <- `if`(fail_on == "note", "warning", fail_on)
  check_args <- c("--no-manual", "--no-tests")
  build_args <- character(0)

  if (!run_examples) {
    check_args <- c(check_args, "--no-examples")
  }
  
  if (!check_vignettes) {
    check_args <- c(check_args, "--ignore-vignettes")
  }

  if (as_cran) {
    check_args <- c(check_args, "--as-cran")
  }
  
  if (!build_vignettes) {
    build_args <- c(build_args, "--no-build-vignettes")
  }

  check <- rcmdcheck::rcmdcheck(
    pkgDir,
    error_on = error_on,
    args = check_args,
    build_args = build_args
  )
  
  biocCheck <- if (bioc_check) {
    build_file <- pkgbuild::build(pkgDir)
    BiocCheck::BiocCheck(
      package = build_file,
      `no-check-unit-tests` = TRUE, # unit tests are called in previous step
      `no-check-formatting` = TRUE, # follow gDR style guides
      `no-check-CRAN` = TRUE, # may cause random error in CI
      `no-check-version-num` = TRUE,
      `no-check-R-ver` = TRUE
    )
  } else {
    NULL
  }

  if (fail_on == "note") {
    test_notes(check, biocCheck, repoDir)
  }
}

#' Check R package
#'
#' Used in gDR platform pacakges' CI/CD pipelines to check that the package
#' abides by gDRstyle stylistic requirements, passes \code{rcmdcheck}, and
#' ensures that the \code{dependencies.yml} file used to build
#' gDR platform's docker image is kept up-to-date with the dependencies
#' listed in the package's \code{DESCRIPTION} file.
#'
#' @param pkgName String of package name.
#' @param repoDir String of path to repository directory.
#' @param subdir String of relative path to the R package root directory
#' from the \code{repoDir}.
#' @param fail_on String specifying the level at which check fail. Supported
#' values: \code{"note"}, \code{"warning"} (default) and \code{"error"}.
#' @param bioc_check Logical whether bioc check should be performed
#' @param run_examples Logical whether examples check should be performed
#' @param skip_lint skip lint checks
#' @param skip_tests skip tests
#' @param build_vignettes build vignettes
#' @param check_vignettes check vignettes
#' @param as_cran run with as_cran flag
#'
#' @examples
#' checkPackage(
#'   pkgName = "fakePkg",
#'   repoDir = system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg"),
#'   fail_on = "error"
#' )
#'
#' @return \code{NULL} invisibly.
#' @keywords check
#' @export
checkPackage <- function(pkgName,
                         repoDir,
                         subdir = NULL,
                         fail_on = "warning",
                         bioc_check = FALSE,
                         run_examples = TRUE,
                         skip_lint = FALSE,
                         skip_tests = FALSE,
                         build_vignettes = TRUE,
                         check_vignettes = TRUE,
                         as_cran = FALSE) {

  checkmate::assert_flag(as_cran)
  fail_on <- match.arg(fail_on, c("error", "warning", "note"))

  pkgDir <- if (is.null(subdir) || subdir == "~") {
    file.path(repoDir)
  } else {
    withr::local_options(list(pkgSubdir = subdir))
    file.path(repoDir, subdir)
  }
  stopifnot(dir.exists(repoDir), dir.exists(pkgDir))
  # stop on warning in tests if 'fail_on' level is below 'error'
  stopOnWarning <- fail_on %in% c("warning", "note")

  if (!skip_lint) {
    message("Lint")
    utils::timestamp()
    with_shiny <- file.exists(file.path(pkgDir, "inst", "shiny"))
    gDRstyle::lintPkgDirs(pkgDir, shiny = with_shiny)
  } else {
    message("Lint skipped")
  }

 
  if (!skip_tests &&
      file.exists(file.path(pkgDir, "tests"))) {
    message("Tests")
    utils::timestamp()
    testthat::test_local(pkgDir,
                         stop_on_failure = TRUE,
                         stop_on_warning = stopOnWarning)
  } else {
    message("Tests skipped")
  }

  message("Check")
  utils::timestamp()
  rcmd_check_with_notes(
    pkgDir = pkgDir, 
    repoDir = repoDir, 
    fail_on = fail_on,
    bioc_check = bioc_check,
    run_examples = run_examples,
    build_vignettes = build_vignettes,
    check_vignettes = check_vignettes,
    as_cran = as_cran
  )

  depsYaml <- file.path(repoDir, "rplatform", "dependencies.yaml")
  if (file.exists(depsYaml)) {
    message("Deps")
    utils::timestamp()
    gDRstyle::checkDependencies(
      desc_path = file.path(pkgDir, "DESCRIPTION"),
      dep_path = depsYaml
    )
  }
  
  message("Finished")
  utils::timestamp()
  
  invisible(NULL)
}
