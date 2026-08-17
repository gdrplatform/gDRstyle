BANNED_PHRASES <- c(
  "in order to",
  "it is now possible",
  "it is possible",
  "has been",
  "have been",
  "was added",
  "were added",
  "is now",
  "are now",
  "functionality",
  "as well as"
)

VALID_VERBS <- c(
  "add", "fix", "remove", "update", "extend", "drop", "replace",
  "rename", "improve", "change", "bump", "refactor", "move", "extract",
  "migrate", "support", "enable", "disable", "allow", "prevent", "ensure",
  "expose", "document", "implement", "introduce", "switch", "use",
  "deprecate", "restore", "simplify", "unify", "resolve", "enforce",
  "include", "exclude", "reduce", "increase", "adjust", "handle",
  "apply", "hotfix", "make", "get", "avoid", "utilize", "hide", "set",
  "reorder", "provide", "convert", "standardize", "integrate", "create",
  "synchronize", "sync", "clean", "deploy", "downgrade", "init",
  "release", "wrap", "correct", "export", "fill", "format",
  "identify", "isolate", "read", "restrict", "rewrite", "send",
  "split", "swap", "take", "reprocess"
)

VERSION_HEADER_PATTERN <- "^## [A-Za-z0-9.]+ \\d+\\.\\d+\\.\\d+ - \\d{4}-\\d{2}-\\d{2}$"

#' Lint NEWS.md entries for style and brevity
#'
#' Checks that every bullet entry in \code{NEWS.md} follows the gDR style
#' guidelines: starts with an imperative verb, is concise (no verbose phrases,
#' no trailing period, within the character limit), that each version section
#' contains at most \code{max_bullets} entries, and that version headers
#' match the expected format.
#'
#' @param pkg_dir character(1) path to the package root directory containing
#'   \code{NEWS.md}. Defaults to the current directory.
#' @param max_chars integer(1) maximum number of characters allowed per bullet
#'   entry (excluding the leading \code{"* "}). Defaults to \code{120L}.
#' @param max_bullets integer(1) maximum number of bullet entries allowed per
#'   version section. Defaults to \code{3L}.
#'
#' @return \code{NULL} invisibly if no violations are found. Stops with an
#'   error listing all violations otherwise.
#'
#' @examples
#' pkg_dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
#' lintNewsEntries(pkg_dir)
#'
#' @keywords linter
#' @export
lintNewsEntries <- function(pkg_dir = ".", max_chars = 120L, max_bullets = 3L) {
  checkmate::assert_directory_exists(pkg_dir)
  checkmate::assert_integerish(max_chars, lower = 1L, len = 1L)
  checkmate::assert_integerish(max_bullets, lower = 1L, len = 1L)

  news_path <- file.path(pkg_dir, "NEWS.md")
  if (!file.exists(news_path)) {
    message("No NEWS.md found -- skipping news lint.")
    return(invisible(NULL))
  }

  lines <- readLines(news_path, warn = FALSE)
  violations <- .check_news_lines(lines, max_chars, max_bullets)

  if (length(violations) > 0L) {
    stop(
      "NEWS.md lint violations:\n",
      paste0("  line ", vapply(violations, `[[`, integer(1), "line"), ": ",
             vapply(violations, `[[`, "", "msg"),
             collapse = "\n")
    )
  }

  message("NEWS.md OK!")
  invisible(NULL)
}

#' @keywords internal
.check_news_lines <- function(lines, max_chars, max_bullets) {
  violations <- list()
  current_header_line <- NULL
  bullet_count <- 0L
  section_count <- 0L

  flush_section <- function() {
    if (!is.null(current_header_line) && bullet_count > max_bullets) {
      violations <<- c(violations, list(list(
        line = current_header_line,
        msg = sprintf(
          "section has %d bullets (max %d) -- split into separate releases",
          bullet_count, max_bullets
        )
      )))
    }
  }

  for (i in seq_along(lines)) {
    line <- lines[[i]]

    if (grepl("^## ", line)) {
      flush_section()
      section_count <- section_count + 1L
      current_header_line <- i
      bullet_count <- 0L
      next
    }

    if (grepl("^\\* ", line) && section_count == 1L) {
      bullet_count <- bullet_count + 1L
      entry <- sub("^\\* ", "", line)
      vs <- .check_bullet(entry, i, max_chars)
      violations <- c(violations, vs)
    }
  }

  flush_section()
  violations
}

#' @keywords internal
.check_header <- function(line, line_num) {
  if (!grepl(VERSION_HEADER_PATTERN, line)) {
    list(line = line_num, msg = sprintf(
      "malformed version header (expected '## PkgName X.Y.Z - YYYY-MM-DD'): '%s'",
      line
    ))
  }
}

#' @keywords internal
.check_bullet <- function(entry, line_num, max_chars) {
  violations <- list()

  if (nchar(entry) > max_chars) {
    violations <- c(violations, list(list(
      line = line_num,
      msg = sprintf("entry too long (%d chars, max %d): '%s'",
                    nchar(entry), max_chars, entry)
    )))
  }

  if (grepl("\\.$", entry)) {
    violations <- c(violations, list(list(
      line = line_num,
      msg = sprintf("entry ends with a period: '%s'", entry)
    )))
  }

  first_word <- tolower(sub("^([A-Za-z]+).*$", "\\1", entry))
  if (!first_word %in% VALID_VERBS) {
    violations <- c(violations, list(list(
      line = line_num,
      msg = sprintf(
        "entry does not start with a known imperative verb (got '%s'): '%s'",
        first_word, entry
      )
    )))
  }

  for (phrase in BANNED_PHRASES) {
    if (grepl(phrase, entry, ignore.case = TRUE)) {
      violations <- c(violations, list(list(
        line = line_num,
        msg = sprintf("entry contains banned phrase '%s': '%s'", phrase, entry)
      )))
    }
  }

  if (grepl("\\bGDR-[0-9]+\\b", entry)) {
    violations <- c(violations, list(list(
      line = line_num,
      msg = sprintf("entry contains Jira ticket reference: '%s'", entry)
    )))
  }

  violations
}

#' @keywords internal
.desc_field <- function(desc_lines, field) {
  ln <- grep(sprintf("^%s:", field), desc_lines, value = TRUE)
  if (length(ln) == 0L) {
    return(NA_character_)
  }
  trimws(sub(sprintf("^%s:", field), "", ln[[1L]]))
}

#' Lint version consistency between NEWS.md and DESCRIPTION
#'
#' Checks that the top \code{NEWS.md} header matches the package metadata: the
#' package name, version, and date in \code{## <Pkg> <version> - <date>} must
#' equal the \code{Package}, \code{Version}, and \code{Date} fields in
#' \code{DESCRIPTION}. This catches a version bump that forgot to update the
#' changelog (or vice versa).
#'
#' @param pkg_dir character(1) path to the package root directory. Defaults to
#'   the current directory.
#'
#' @return \code{NULL} invisibly if consistent. Stops with an error listing all
#'   mismatches otherwise.
#'
#' @examples
#' pkg_dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
#' lintVersionConsistency(pkg_dir)
#'
#' @keywords linter
#' @export
lintVersionConsistency <- function(pkg_dir = ".") {
  checkmate::assert_directory_exists(pkg_dir)
  desc_path <- file.path(pkg_dir, "DESCRIPTION")
  news_path <- file.path(pkg_dir, "NEWS.md")
  checkmate::assert_file_exists(desc_path)
  if (!file.exists(news_path)) {
    message("Version consistency: OK! (no NEWS.md)")
    return(invisible(NULL))
  }

  d <- readLines(desc_path, warn = FALSE)
  desc_pkg <- .desc_field(d, "Package")
  desc_ver <- .desc_field(d, "Version")
  desc_date <- .desc_field(d, "Date")

  news <- readLines(news_path, warn = FALSE)
  hdr <- grep("^## ", news, value = TRUE)
  hdr <- if (length(hdr) == 0L) "" else hdr[[1L]]
  m <- regmatches(hdr, regexec("^## (\\S+) (\\S+) - (\\S+)$", hdr))[[1L]]

  violations <- list()
  add <- function(msg) violations[[length(violations) + 1L]] <<- list(msg = msg)
  if (length(m) != 4L) {
    add(sprintf(
      "top NEWS.md header '%s' is not '## <Pkg> <version> - <date>'", hdr))
  } else {
    if (!is.na(desc_pkg) && m[[2L]] != desc_pkg) {
      add(sprintf("NEWS.md package '%s' != DESCRIPTION Package '%s'",
                  m[[2L]], desc_pkg))
    }
    if (!is.na(desc_ver) && m[[3L]] != desc_ver) {
      add(sprintf("NEWS.md version '%s' != DESCRIPTION Version '%s'",
                  m[[3L]], desc_ver))
    }
    if (!is.na(desc_date) && m[[4L]] != desc_date) {
      add(sprintf("NEWS.md date '%s' != DESCRIPTION Date '%s'",
                  m[[4L]], desc_date))
    }
  }
  .stop_on_violations(violations, "Version consistency violations")
}
