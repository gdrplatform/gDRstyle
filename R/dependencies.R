#' Check for alignment of package dependencies across Rplatform and package specifications.
#'
#' Check the package depedency version specifications in the \code{rplatform/dependencies.yaml} and \code{DESCRIPTION}.
#'
#' @param dep_path String of path to the rplatform \code{dependencies.yaml} file.
#' @param desc_path String of the path to the package \code{DESCRIPTION} file.
#' @param pkg_dir String of path to package directory. 
#' Defaults to the current directory.
#'
#' @return \code{NULL} invisibly.
#' @details This function is used for its side effects in the event that there are dependency clashes.
#' @importFrom yaml read_yaml
#' @importFrom desc desc_get_deps
#' @export
checkDependencies <- function(dep_path, desc_path) {
  if (file.exists(dep_path)) {
    rp_deps <- read_yaml(dep_path)
  } else {
    stop(sprintf("'%s' file not found", dep_path))
  }

  if (length(desc_path) > 1L) {
    stop("more than one 'DESCRIPTION' file found")
  }
  if (!file.exists(desc_path)) {
    stop(sprintf("'%s' file not found", desc_path))
  }
  desc_deps <- desc_get_deps(desc_path)

  # Subset to those with version requirements.
  rp_pkgs <- rp_deps$pkgs
  
  skiped_packages <- lapply(rp_pkgs, function(x){
    !isTRUE(x$NonDescription)
  })
  rp_pkgs <- rp_pkgs[unlist(skiped_packages)]
  
  rp_ver <- lapply(rp_pkgs, function(x) {
    if (is.null(x$ver)) {
      "*"
    } else {
      x$ver
    }
  }) 

  idx <- match(names(rp_ver), desc_deps$package)
  if (any(na_idx <- is.na(idx))) {
    stop(sprintf("packages specified in 'dependencies.yaml' not present in 'DESCRIPTION': %s",
      paste0(names(rp_ver)[na_idx], collapse=", ")))
  }
  xrp_ver <- desc_deps[idx, "version"]
  names(xrp_ver) <- desc_deps[idx, "package"]

  bad_pkgs <- compare_versions(rp_ver, xrp_ver)

  # Reverse search.
  desc_pkgs <- desc_deps[desc_deps$version != "*", c("package")]
  bad_pkgs <- unique(c(bad_pkgs, setdiff(desc_pkgs, names(rp_pkgs))))
  
  if (length(bad_pkgs) != 0L) {
    stop(sprintf("misaligned package versions between 'rplatform/dependencies.yaml' and package 'DESCRIPTION' file: %s", paste0(bad_pkgs, collapse=", ")))
  }
  invisible(NULL)
}


#' Compare listed package versions in the dependencies.yaml file as compared to the package DESCRIPTION file.
#'
#' Compare listed package versions in the dependencies.yaml file as compared to the package DESCRIPTION file.
#'
#' @param rp Named list of package version requirements specified by rplatform \code{dependencies.yaml}.
#' @param rp Named list of package version requirements specified by package \code{DESCRIPTION} file.
#'
#' @return Character vector of any misaligned package versions between rplatform \code{dependencies.yaml} and package \code{DESCRIPTION}.
compare_versions <- function(rp, desc) {
  stopifnot(all(names(rp) == names(desc)))
  misaligned_ver_pkgs <- NULL
  for (pkg in names(rp)) {
    if (.tidy_versions(rp[[pkg]]) != .tidy_versions(desc[[pkg]])) {
      misaligned_ver_pkgs <- c(misaligned_ver_pkgs, pkg) 
    }
  }
  misaligned_ver_pkgs
}


#' Tidy version strings.
#'
#' Tidy version strings, often to make them comparable.
#'
#' @param ver String of a package version.
#'
#' @return Tidied string of package version.
#'
#' @keywords internal
#' @noRd
.tidy_versions <- function(ver) {
  gsub(" ", "", ver)
}
