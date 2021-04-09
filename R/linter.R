#' @export
lintPkg <- function(pkg_name) {
  flint <- getFilesToLint(pkg_name = pkg_name)
  lintAllFiles(flint)
}

#' @export
lintPkgInDir <- function(pkg_dir) {
  flint <- getFilesToLint(dir = pkg_dir)
  lintAllFiles(flint)
}

#############
# Internal
#############

getFilesToLint <- function(pkg_name = NULL, dir = NULL) {
  
  if (is.null(pkg_name) && is.null(dir)) {
    stop("define one of arguments: 'pkg_name' or 'dir'")
  } else if (!is.null(pkg_name)) {
    if (!is.null(dir)){
      warning("both 'pkg_name' or 'dir' are defined, only 'will be use'")
    }
    flint <- c(
      dir(system.file("R", package = pkg_name), full.names = TRUE),
      dir(system.file("tests", package = pkg_name), full.names = TRUE, recursive = TRUE),
      dir(system.file("shiny", package = pkg_name), full.names = TRUE, recursive = FALSE, pattern = "*.R")
    )
  } else {
    flint <- c(
      dir(file.path(dir, "R"), full.names = TRUE),
      dir(file.path(dir, "tests"), full.names = TRUE, recursive = TRUE),
      dir(file.path(dir, "shiny"), full.names = TRUE, recursive = FALSE, pattern = "*.R")
    )
  }

  # ignore extensions
  ignore.ext <- c("md", "html")
  if (!is.null(ignore.ext) && any(vapply(ignore.ext, function(x) nchar(x) > 0, FUN.VALUE = logical(1)))) {
    pattern <- paste0(sprintf(".*\\.%s$", ignore.ext), collapse = "|")
    flint <- flint[!grepl(pattern, flint, ignore.case = TRUE)]
  }
  
  flint
}


lintFile <- function(filepath) {
  print(paste("Linting file:", filepath))
  result <- lintr::lint(filepath, linters = linters_config)
  if (length(result) > 0) {
    print(result) # Show linter messages
    stop(paste0("Linter fails on file:", filepath))
  }
}


lintAllFiles <- function(files_to_lint) {
  for (filepath in files_to_lint) {
    lintFile(filepath)
  }
  print("All files OK!")
}
