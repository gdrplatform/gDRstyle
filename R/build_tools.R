#' Add additional repo to global option
#'
#' @param additionalRepos list of additional repos
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
setReposOpt <- function(additionalRepos = NULL) {
  repos <- append(options("repos")$repos, additionalRepos)
  options(repos = repos)
}

#' Set environment variable GITHUB_PAT
#'
#' @param base_dir String, path to dir with token file
#' @param filename String, name of file with token
#'
#' @return \code{NULL} or info about error
#' @keywords internal
#' @noRd
setTokenVar <- function(base_dir, 
                        filename = ".github_access_token.txt") {
  # Use GitHub access_token if available
  gh_access_token_file <- file.path(base_dir, filename)
  if (file.exists(gh_access_token_file)) {
    secrets <- readLines(gh_access_token_file)
    stopifnot(length(secrets) > 0)

    if (length(secrets) == 1) {
      args <- list(secrets)
      names(args) <- "GITHUB_PAT"
      do.call(Sys.setenv, args)
    } else {
      tokens <- strsplit(secrets, "=")
      lapply(tokens, function(x) {
        args <- list(x[2])
        names(args) <- x[1]

        do.call(Sys.setenv, args)
      })
    }
  }
}

# Auxiliary functions
#' Check if the given package version is valid and exists
#'
#' @param name String, name of the package to install
#' @param required_version String, version of the package to install
#'
#' @return \code{NULL} or info about error
#' @keywords internal
#' @noRd
verify_version <- function(name, 
                           required_version) {
  pkg_version <- utils::packageVersion(name)
  ## '>=1.2.3' => '>= 1.2.3'
  required_version <-
    gsub("^([><=]+)([0-9.]+)$", "\\1 \\2", required_version, perl = TRUE)
  if (!remotes:::version_satisfies_criteria(pkg_version, required_version)) {
    stop(sprintf(
      "Invalid version of %s. Installed: %s, required %s.",
      name,
      pkg_version,
      required_version
    ))
  }
}


#' Create a new ssh key credential object
#' 
#' @param use_ssh logical, if use ssh keys 
#'
#' @return A list of class cred_ssh_key
#' @keywords internal
#' @noRd
getSshKeys <- function(use_ssh) {
  if (isTRUE(use_ssh)) {
    git2r::cred_ssh_key(
      publickey = ssh_key_pub,
      privatekey = ssh_key_priv
    )
  }
}

#' Install locally cloned repo for builiding image purposes
#'
#' @param repo_path String of repository directory.
#' @param additionalRepos List of additional Repos
#' @param base_dir String of base working directory.
#'
#' @examples
#' installLocalPackage(system.file(
#' package = "gDRstyle", "tst_pkgs", "dummy_pkg"
#' ))
#' 
#' @return \code{NULL}
#' @export
installLocalPackage <- function(repo_path,
                                additionalRepos = NULL,
                                base_dir = "/mnt/vol") {
  setReposOpt(additionalRepos)
  setTokenVar(base_dir)
  remotes::install_local(path = repo_path)
}

#' Install all package dependencies from yaml file for
#' building image purposes
#'
#' @param additionalRepos List of additional Repos
#' @param base_dir String of base working directory.
#' @param use_ssh logical, if use ssh keys
#' @param test_mode logical, whether to run the function in the test mode
#'        (if TRUE the dependencies are not installed but only listed)
#'
#' @examples
#' installAllDeps(
#'   base_dir = system.file(package = "gDRstyle", "testdata"),
#'   test_mode = TRUE
#' )
#'
#' @return \code{NULL}
#' @export
installAllDeps <- function(additionalRepos = NULL,
                           base_dir = "/mnt/vol",
                           use_ssh = FALSE,
                           test_mode = FALSE) {
  setReposOpt(additionalRepos)
  setTokenVar(base_dir)
  keys <- getSshKeys(use_ssh)

  deps_yaml <- file.path(base_dir, "/dependencies.yaml")
  deps <- yaml::read_yaml(deps_yaml)$pkgs

  if (test_mode) {
    return(deps)
  }

  for (name in names(deps)) {
    pkg <- deps[[name]]
    if (is.null(pkg$source)) {
      pkg$source <- "Git"
    }

    switch(
      EXPR = toupper(pkg$source),

      # nocov start
      "CRAN" = install_cran(name = name, pkg = pkg),

      "BIOC" = install_bioc(name = name, pkg = pkg),

      "GITHUB" = install_github(name = name, pkg = pkg),

      "GIT" = install_git(name = name, pkg = pkg, keys = keys),

      "GITLAB" = install_gitlab(name = name, pkg = pkg),
      # nocov end

      stop("Invalid or unsupported source attribute")
    )
  }
}

# nocov start
#' Install specific version of a package
#'
#' @param name String, name of the package to install
#' @param pkg List with package version and URL repo
#' @seealso \code{\link[remotes::install_version]{remotes::install_version()}}
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
install_cran <- function(name, 
                         pkg) {
  if (is.null(pkg$repos)) {
    pkg$repos <- getOption("repos")
  }
  remotes::install_version(
    package = name,
    version = pkg$ver,
    repos = pkg$repos,
    upgrade = "never"
  )
}

#' Install package from Bioconductor
#'
#' @param name String, name of the package to install
#' @param pkg List with package version and URL repo
#' @seealso \code{\link[remotes::install_bioc]{remotes::install_bioc()}}
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
install_bioc <- function(name, 
                         pkg) {
  if (is.null(pkg$ver)) {
    pkg$ver <- BiocManager::version()
  }
  remotes::install_bioc(
    repo = name,
    upgrade = "never"
  )
  verify_version(name, pkg$ver)
}

#' Install package from github
#'
#' @param name String, name of the package to install
#' @param pkg List with package version and URL repo
#' @seealso \code{\link[remotes::install_github]{remotes::install_github()}}
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
install_github <- function(name, 
                           pkg) {
  if (is.null(pkg$ref)) {
    pkg$ref <- "HEAD"
  }
  remotes::install_github(
    repo = pkg$url,
    ref = pkg$ref,
    subdir = pkg$subdir,
    host = ifelse(!is.null(pkg$host), pkg$host, "api.github.com"),
    upgrade = "never"
  )
  verify_version(name, pkg$ver)
}

#' Install package from git repository
#'
#' @param name String, name of the package to install
#' @param pkg List with package version, URL repo and name of branch
#' @param keys String of credential
#' @seealso \code{\link[remotes::install_git]{remotes::install_version()}}
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
install_git <- function(name, 
                        pkg, 
                        keys) {
  remotes::install_git(
    url = pkg$url,
    subdir = pkg$subdir,
    ref = pkg$ref,
    credentials = keys,
    upgrade = "never"
  )
  verify_version(name, pkg$ver)
}

#' Install package from gitlab
#'
#' @param name String, name of the package to install
#' @param pkg List with package version and URL repo
#' @seealso \code{\link[remotes::install_version]{remotes::install_version()}}
#'
#' @return \code{NULL}
#' @keywords internal
#' @noRd
install_gitlab <- function(name, 
                           pkg) {
  repo <- paste(tempdir(), "install_pkg_git", name, sep = .Platform$file.sep)
  url <- if (!is.null(pkg$url) && grepl("code.roche.com", pkg$url)) {
    sprintf("https://%s@%s", Sys.getenv("GITLAB_PAT"), pkg$url)
  } else {
    pkg$url
  }

  git_args <- c(
    "clone", url, "--branch", pkg$ref, "--single-branch", "--depth", "1", repo
  )
  system2("git", git_args)
  remotes::install_local(
    paste(repo, pkg$subdir, sep = .Platform$file.sep),
    dependencies = TRUE,
    upgrade = "never",
    quiet = FALSE
  )
  verify_version(name, pkg$ver)
}
# nocov end
