# Constants used across Rmd linting helpers
.RMD_BASE_PKGS <- c("base", "utils", "stats", "graphics", "grDevices",
                    "methods", "datasets")
.RMD_IMPLICIT_PKGS <- c("knitr", "rmarkdown")
# data.table special tokens — not real function calls
.RMD_IGNORE_FUNCS <- c(".", ".N", ".SD", ".GRP", ".BY", ".I", ":=")


# ---- Internal helpers --------------------------------------------------------

#' Extract R code chunks from an Rmd file
#'
#' @param rmd_path character(1) path to an `.Rmd` file.
#' @return A list of named lists, each with \code{code} (character(1)) and
#'   \code{start_line} (integer(1)).
#' @keywords internal
.extractRChunks <- function(rmd_path) {
  checkmate::assert_file_exists(rmd_path)
  lines <- readLines(rmd_path, warn = FALSE)
  chunks <- list()
  in_chunk <- FALSE
  cur <- character(0)
  chunk_start <- 0L

  for (i in seq_along(lines)) {
    if (!in_chunk && grepl("^```\\{r", lines[i])) {
      in_chunk <- TRUE
      chunk_start <- i + 1L
      cur <- character(0)
    } else if (in_chunk && grepl("^```\\s*$", lines[i])) {
      in_chunk <- FALSE
      if (length(cur) > 0) {
        chunks[[length(chunks) + 1L]] <- list(
          code = paste(cur, collapse = "\n"),
          start_line = chunk_start
        )
      }
    } else if (in_chunk) {
      cur <- c(cur, lines[i])
    }
  }
  chunks
}

#' Collect package names from library()/require() calls in code
#'
#' @param code character(1) R code (may span multiple chunks).
#' @return character vector of package names.
#' @keywords internal
.getLoadedPackages <- function(code) {
  checkmate::assert_string(code)
  m <- gregexpr(
    '(?:library|require)\\s*\\(\\s*["\']?([a-zA-Z][a-zA-Z0-9.]*)["\']?',
    code, perl = TRUE
  )
  caps <- regmatches(code, m)[[1]]
  if (length(caps) == 0) return(character(0))
  pkgs <- vapply(caps, function(s) {
    r <- regexec(
      '(?:library|require)\\s*\\(\\s*["\']?([a-zA-Z][a-zA-Z0-9.]*)["\']?',
      s, perl = TRUE
    )
    regmatches(s, r)[[1]][2]
  }, character(1), USE.NAMES = FALSE)
  unique(pkgs)
}

#' Get exported symbols from an installed package
#'
#' Returns an empty character vector (with a message) when the package is not
#' installed, so the linter degrades gracefully in environments that lack
#' optional dependencies.
#'
#' @param pkg character(1) package name.
#' @return character vector of exported symbol names.
#' @keywords internal
.getPkgExports <- function(pkg) {
  checkmate::assert_string(pkg)
  tryCatch(getNamespaceExports(pkg), error = function(e) {
    message(sprintf("  [WARN] package '%s' not installed", pkg))
    character(0)
  })
}

#' Replace mustache template expressions with safe R literals
#'
#' Rmd report templates often contain \code{\{\{param\}\}} mustache syntax.
#' This function replaces those tokens so the R chunk can be parsed without
#' syntax errors.
#'
#' @param code character(1) R code possibly containing mustache tokens.
#' @return character(1) code with mustache tokens replaced.
#' @keywords internal
.stripMustache <- function(code) {
  checkmate::assert_string(code)
  # quoted "{{param}}" or "{{{param}}}" inside strings -> keep as string
  code <- gsub('"\\{\\{\\{?[^}]*\\}\\}\\}?"', '"__TMPL__"', code)
  # block tags {{#x}}, {{/x}}, {{^x}} -> remove entirely
  code <- gsub("\\{\\{[#/^][^}]*\\}\\}", "", code)
  # triple {{{x}}} -> string literal
  code <- gsub("\\{\\{\\{[^}]*\\}\\}\\}", '"__TMPL__"', code)
  # bare {{x}} -> TRUE (a safe R literal in any expression context)
  gsub("\\{\\{[^}]*\\}\\}", "TRUE", code)
}

#' Extract locally defined names from a single R chunk using the AST
#'
#' Uses \code{getParseData()} to find the left-hand side of \code{<-}
#' assignment expressions. The AST approach is preferred over regex because it
#' correctly handles indirect assignments such as
#' \code{x <- if (cond) a else b} without producing false positives from
#' function default arguments (\code{f = function(x = 1)}).
#' \code{EQ_ASSIGN} (\code{=}) is intentionally excluded to avoid matching
#' function formals.
#'
#' @param code character(1) R code for a single chunk.
#' @return character vector of locally defined names.
#' @keywords internal
.findDefinedNamesInChunk <- function(code) {
  checkmate::assert_string(code)
  code <- .stripMustache(code)
  tryCatch({
    pd <- getParseData(parse(text = code, keep.source = TRUE))
    if (is.null(pd) || NROW(pd) == 0L) return(character(0))
    assigns <- pd[pd$token == "LEFT_ASSIGN", , drop = FALSE]
    out <- character(0)
    for (i in seq_len(NROW(assigns))) {
      assign_parent <- assigns$parent[i]
      siblings <- pd[pd$parent == assign_parent, , drop = FALSE]
      siblings <- siblings[order(siblings$col1), , drop = FALSE]
      lhs_ids <- siblings$id[siblings$col1 < assigns$col1[i]]
      if (length(lhs_ids) == 0L) next
      lhs_id <- lhs_ids[length(lhs_ids)]
      lhs_sub <- pd[pd$parent == lhs_id | pd$id == lhs_id, , drop = FALSE]
      sym <- lhs_sub[lhs_sub$token == "SYMBOL", , drop = FALSE]
      if (NROW(sym) > 0L) out <- c(out, sym$text[1L])
    }
    unique(out)
  }, error = function(e) character(0))
}

#' Detect the R package that owns an Rmd file
#'
#' Walks up the directory tree (max 6 levels) looking for a
#' \code{DESCRIPTION} file. A \code{DESCRIPTION} found more than 4 levels
#' above the Rmd is considered unrelated (e.g. a workspace root or Docker
#' volume ancestor) and \code{NULL} is returned with a warning.
#'
#' @param rmd_path character(1) path to the Rmd file.
#' @return character(1) package name, or \code{NULL} if not found.
#' @keywords internal
.detectHostPackage <- function(rmd_path) {
  checkmate::assert_string(rmd_path)
  dir <- dirname(normalizePath(rmd_path, mustWork = FALSE))
  for (i in seq_len(6L)) {
    desc <- file.path(dir, "DESCRIPTION")
    if (file.exists(desc)) {
      if (i > 5L) {
        warning(sprintf(
          ".detectHostPackage: DESCRIPTION found %d levels above '%s' — skipping.",
          i - 1L, rmd_path
        ))
        return(NULL)
      }
      lines <- readLines(desc, warn = FALSE)
      pkg_line <- grep("^Package:", lines, value = TRUE)
      if (length(pkg_line) > 0L) {
        return(trimws(sub("^Package:\\s*", "", pkg_line[1L])))
      }
    }
    dir <- dirname(dir)
  }
  NULL
}

#' Find unqualified function calls in a single R chunk
#'
#' Parses the chunk and returns all \code{SYMBOL_FUNCTION_CALL} tokens that
#' are not immediately preceded by a namespace operator (\code{::} or
#' \code{:::}).
#'
#' @param code character(1) R code for a single chunk.
#' @return data.frame with columns \code{func} (character) and \code{line}
#'   (integer), or an empty data.frame on parse error.
#' @keywords internal
.findUnqualifiedCalls <- function(code) {
  checkmate::assert_string(code)
  code <- .stripMustache(code)
  tryCatch({
    pd <- getParseData(parse(text = code, keep.source = TRUE))
    if (is.null(pd) || NROW(pd) == 0L) {
      return(data.frame(func = character(0L), line = integer(0L),
                        stringsAsFactors = FALSE))
    }
    fc <- pd[pd$token == "SYMBOL_FUNCTION_CALL", , drop = FALSE]
    ns <- pd[pd$token %in% c("NS_GET", "NS_GET_INT"), , drop = FALSE]
    qual_parents <- unique(ns$parent)
    uq <- fc[!fc$parent %in% qual_parents, , drop = FALSE]
    data.frame(func = gsub("^`|`$", "", uq$text), line = uq$line1,
               stringsAsFactors = FALSE)
  }, error = function(e) {
    message(sprintf("  [WARN] parse error: %s", conditionMessage(e)))
    data.frame(func = character(0L), line = integer(0L),
               stringsAsFactors = FALSE)
  })
}


# ---- Public API --------------------------------------------------------------

#' Check an Rmd file for unresolved function calls
#'
#' Parses all R chunks in an Rmd file, collects packages loaded via
#' \code{library()} / \code{require()}, detects the host package from the
#' nearest \code{DESCRIPTION} file, identifies locally defined names, and
#' flags any unqualified function call that cannot be resolved to a known
#' symbol.
#'
#' Mustache template syntax (\code{\{\{param\}\}}) is stripped before parsing
#' so parametrised report templates can be checked without syntax errors.
#'
#' @param rmd_path character(1) path to an \code{.Rmd} file.
#' @param verbose logical(1) if \code{TRUE}, prints diagnostics (host package,
#'   loaded packages, local definitions, known symbol count). Default
#'   \code{FALSE}.
#'
#' @return A \code{data.frame} with columns \code{func} (character) and
#'   \code{line} (integer) — one row per unique unresolved call site.
#'   Returns \code{NULL} when the file contains no R chunks.
#'
#' @examples
#' \dontrun{
#' # Check a single template
#' lintRmdDeps("inst/report_templates/3-analysis.Rmd")
#'
#' # Check with verbose diagnostics
#' lintRmdDeps("inst/report_templates/3-analysis.Rmd", verbose = TRUE)
#' }
#'
#' @export
lintRmdDeps <- function(rmd_path, verbose = FALSE) {
  checkmate::assert_file_exists(rmd_path, extension = "Rmd")
  checkmate::assert_flag(verbose)

  chunks <- .extractRChunks(rmd_path)
  if (length(chunks) == 0L) return(NULL)

  all_code <- paste(vapply(chunks, `[[`, character(1L), "code"),
                    collapse = "\n")

  loaded <- .getLoadedPackages(all_code)
  host_pkg <- .detectHostPackage(rmd_path)
  if (!is.null(host_pkg)) loaded <- c(loaded, host_pkg)
  all_pkgs <- unique(c(.RMD_BASE_PKGS, .RMD_IMPLICIT_PKGS, loaded))

  if (verbose) {
    if (!is.null(host_pkg)) {
      cat(sprintf("  host package: %s\n", host_pkg))
    }
    user_pkgs <- setdiff(all_pkgs, c(.RMD_BASE_PKGS, .RMD_IMPLICIT_PKGS))
    if (length(user_pkgs) > 0L) {
      cat(sprintf("  loaded packages: %s\n", paste(user_pkgs, collapse = ", ")))
    }
  }

  defined <- unique(unlist(lapply(chunks, function(ch) {
    .findDefinedNamesInChunk(ch$code)
  })))

  if (verbose && length(defined) > 0L) {
    cat(sprintf("  local definitions: %s\n", paste(defined, collapse = ", ")))
  }

  known <- unique(c(
    unlist(lapply(all_pkgs, .getPkgExports)),
    defined,
    .RMD_IGNORE_FUNCS
  ))

  if (verbose) {
    cat(sprintf("  known symbols: %d\n", length(known)))
  }

  issues <- data.frame(func = character(0L), line = integer(0L),
                       stringsAsFactors = FALSE)
  for (ch in chunks) {
    calls <- .findUnqualifiedCalls(ch$code)
    if (NROW(calls) == 0L) next
    calls$line <- calls$line + ch$start_line - 1L
    issues <- rbind(issues,
                    calls[!calls$func %in% known, , drop = FALSE])
  }

  if (NROW(issues) > 0L) {
    issues <- issues[!duplicated(issues$func), , drop = FALSE]
  }
  issues
}
