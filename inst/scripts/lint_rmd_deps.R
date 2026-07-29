#!/usr/bin/env Rscript
# lint_rmd_deps.R — CLI wrapper for gDRstyle::lintRmdDeps()
#
# Checks one or more Rmd files (or all .Rmd files in a directory) for
# unqualified function calls that cannot be resolved to any package loaded
# via library()/require() or to the host package detected from DESCRIPTION.
#
# Usage:
#   Rscript lint_rmd_deps.R [--verbose] <file.Rmd|directory> [...]
#
# Options:
#   --verbose  Print diagnostics per file (host package, loaded packages,
#              local definitions, known symbol count).
#
# Exit codes:
#   0  No unresolved calls found (or no .Rmd files found).
#   1  Unresolved calls detected, or called with no arguments.

if (!requireNamespace("gDRstyle", quietly = TRUE)) {
  stop("Package 'gDRstyle' is required. Install it with:\n",
       "  BiocManager::install('gdrplatform/gDRstyle')", call. = FALSE)
}

all_args <- commandArgs(trailingOnly = TRUE)
verbose <- "--verbose" %in% all_args
args <- setdiff(all_args, "--verbose")

if (length(args) == 0L) {
  cat("Usage: Rscript lint_rmd_deps.R [--verbose] <file.Rmd|directory> [...]\n")
  cat("\nOptions:\n")
  cat("  --verbose  Print diagnostics per file.\n")
  cat("\nExit codes:\n")
  cat("  0  No unresolved calls found.\n")
  cat("  1  Unresolved calls detected, or no input provided.\n")
  quit(status = 1L)
}

rmd_files <- character(0L)
for (a in args) {
  if (dir.exists(a)) {
    rmd_files <- c(rmd_files,
                   list.files(a, "\\.Rmd$", recursive = TRUE, full.names = TRUE))
  } else if (file.exists(a)) {
    rmd_files <- c(rmd_files, a)
  } else {
    message(sprintf("WARNING: '%s' not found", a))
  }
}

if (length(rmd_files) == 0L) {
  cat("No .Rmd files found.\n")
  quit(status = 0L)
}

total <- 0L
for (f in rmd_files) {
  cat(sprintf("\n=== %s ===\n", f))
  res <- gDRstyle::lintRmdDeps(f, verbose = verbose)
  if (is.null(res) || NROW(res) == 0L) {
    cat("  OK\n")
  } else {
    total <- total + NROW(res)
    for (i in seq_len(NROW(res))) {
      cat(sprintf("  L%d: %s() -- not found in loaded packages\n",
                  res$line[i], res$func[i]))
    }
  }
}

cat(sprintf("\n--- %d file(s), %d unresolved call(s) ---\n",
            length(rmd_files), total))
quit(status = if (total > 0L) 1L else 0L)
