#' @export
lintPkg <- function(pkg_name) {
  flint <- getFilesToLint(pkg_name)
  lintAllFiles(flint)
}

#############
# Internal
#############

getFilesToLint <- function(pkg_name) {
  pkg_base_path <- system.file(".", package=pkg_name)
  flint <- c(
    dir(paste0(pkg_base_path, "/R"), full.names = TRUE),
    dir(paste0(pkg_base_path, "/tests"), full.names = TRUE, recursive = TRUE),
    dir(paste0(pkg_base_path, "/inst/shiny"), full.names = TRUE, recursive = FALSE, pattern = "*.R")
  )

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
