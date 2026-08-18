#' roxygen_tag_linter
#'
#' Check that function has documented specific tag in Roxygen
#' skeleton (default \code{@author}).
#'
#' @param tag character (default \code{@author})
#'
#' @author Kamil Foltynski <kamil.foltynski@contractors.roche.com>
#'
#' @examples
#' linters_config <- lintr::linters_with_defaults(
#'   line_length_linter = lintr::line_length_linter(120),
#'   roxygen_tag_linter = roxygen_tag_linter()
#' )
#'
#' @return linter class function
#' @keywords linter
#' @export
roxygen_tag_linter <- function(tag = "@author") {

  stopifnot(length(tag) == 1, nzchar(tag))

  fun <- function(source_file) {
    lapply(
      lintr::ids_with_token(source_file, "FUNCTION"),
      function(id) {

        parsed <- lintr::with_id(source_file, id)
        flines <- rev(
          readLines(source_file$filename)[seq_len(parsed$line1 - 1L)]
        )

        idx <- skip_lines_withou_prefix(flines = flines)
        # if idx is NA it means function has no documentation - skip check
        # because it may be some internal function or part of apply,
        # e.g. sapply(vector, function(x) ..
        if (is.na(idx))
          return()
        # drop lines after one without prefix `#'`
        flines_strip <- flines[seq_len(idx)]

        # check if tag exists
        is_tag_found <- any(vapply(
          flines_strip,
          function(x) grepl(pattern = tag, x),
          USE.NAMES = FALSE,
          FUN.VALUE = logical(1)
        ))

        if (!is_tag_found) {
          lintr::Lint(
            filename = source_file$filename,
            line_number = parsed$line1,
            column_number = parsed$col1,
            type = "style",
            message = sprintf("Tag \"%s\" not found in Roxygen skeleton.", tag),
            line = source_file$lines[as.character(parsed$line1)]
          )
        }

      })
  }
  # to ensure backward compatibility, temporarily change the class by hand,
  # it future we should switch to `lintr::Linter(function(source_file) {...}`
  class(fun) <- "linter"
  fun
}

#' consecutive_spaces_linter
#'
#' Flag runs of two or more internal spaces, e.g. alignment padding before
#' \code{<-}/\code{=} (\code{x   <- 1}) or extra spaces after a comma
#' (\code{f(a,  b)}). Leading indentation, trailing whitespace, and spaces
#' inside string literals or comments (including alignment before an
#' end-of-line comment) are ignored.
#'
#' @author Bartosz Czech <bartosz.czech@contractors.roche.com>
#'
#' @examples
#' linters_config <- lintr::linters_with_defaults(
#'   consecutive_spaces_linter = consecutive_spaces_linter()
#' )
#'
#' @return linter class function
#' @keywords linter
#' @export
consecutive_spaces_linter <- function() {
  lintr::Linter(linter_level = "file", function(source_expression) {
    lines <- source_expression$file_lines
    pc <- source_expression$full_parsed_content
    prot <- pc[pc$token %in% c("STR_CONST", "COMMENT"), , drop = FALSE]

    lints <- lapply(seq_along(lines), function(i) {
      ln <- suppressWarnings(as.integer(names(lines)[i]))
      if (is.na(ln)) {
        ln <- i
      }
      line <- lines[[i]]

      m <- gregexpr("(?<=\\S) {2,}(?=\\S)", line, perl = TRUE)[[1]]
      if (m[[1]] == -1L) {
        return(list())
      }
      starts <- as.integer(m)
      ends <- starts + attr(m, "match.length") - 1L

      tok <- prot[prot$line1 <= ln & prot$line2 >= ln, , drop = FALSE]
      ivl <- lapply(seq_len(NROW(tok)), function(k) {
        s <- if (tok$line1[k] == ln) tok$col1[k] else 1L
        e <- if (tok$line2[k] == ln) tok$col2[k] else nchar(line)
        if (tok$token[k] == "COMMENT") {
          # extend protection leftward over spaces aligning a trailing comment
          j <- s - 1L
          while (j >= 1L && substr(line, j, j) == " ") {
            j <- j - 1L
          }
          s <- j + 1L
        }
        c(s, e)
      })

      keep <- vapply(seq_along(starts), function(j) {
        !any(vapply(ivl, function(v) starts[j] <= v[2] && ends[j] >= v[1],
                    logical(1)))
      }, logical(1))

      lapply(which(keep), function(j) {
        lintr::Lint(
          filename = source_expression$filename,
          line_number = ln,
          column_number = starts[j],
          type = "style",
          message = "Remove consecutive spaces; use a single space.",
          line = line,
          ranges = list(c(starts[j], ends[j]))
        )
      })
    })
    unlist(lints, recursive = FALSE)
  })
}

#' ticket_ref_linter
#'
#' Flag Jira ticket references such as \code{GDR-<id>} left in the source
#' (in code, comments, or strings). The ticket ID belongs in the branch name
#' only, never in the committed source. A reference inside a \code{TODO} or
#' \code{FIXME} comment is allowed, since it legitimately links deferred work
#' to the ticket that tracks it.
#'
#' @author Bartosz Czech <bartosz.czech@contractors.roche.com>
#'
#' @examples
#' linters_config <- lintr::linters_with_defaults(
#'   ticket_ref_linter = ticket_ref_linter()
#' )
#'
#' @return linter class function
#' @keywords linter
#' @export
ticket_ref_linter <- function() {
  lintr::Linter(linter_level = "file", function(source_expression) {
    lines <- source_expression$file_lines
    pc <- source_expression$full_parsed_content
    todo <- pc[pc$token == "COMMENT" &
                 grepl("\\b(TODO|FIXME)\\b", pc$text, ignore.case = TRUE), ,
               drop = FALSE]

    # a TODO/FIXME can wrap onto the comment lines directly below it; exempt
    # that whole contiguous run, not just the line carrying the keyword
    comment_lines <- pc$line1[pc$token == "COMMENT"]
    cont_lines <- integer(0)
    for (tl in todo$line1) {
      nl <- tl + 1L
      while (nl %in% comment_lines) {
        cont_lines <- c(cont_lines, nl)
        nl <- nl + 1L
      }
    }

    lints <- lapply(seq_along(lines), function(i) {
      ln <- suppressWarnings(as.integer(names(lines)[i]))
      if (is.na(ln)) {
        ln <- i
      }
      line <- lines[[i]]

      if (ln %in% cont_lines) {
        return(list())
      }

      m <- gregexpr("GDR-[0-9]+", line, perl = TRUE)[[1]]
      if (m[[1]] == -1L) {
        return(list())
      }
      starts <- as.integer(m)
      ends <- starts + attr(m, "match.length") - 1L

      # allow refs that sit inside a TODO/FIXME comment on this line
      tok <- todo[todo$line1 <= ln & todo$line2 >= ln, , drop = FALSE]
      allowed <- vapply(seq_along(starts), function(j) {
        any(vapply(seq_len(NROW(tok)), function(k) {
          starts[j] >= tok$col1[k] && ends[j] <= tok$col2[k]
        }, logical(1)))
      }, logical(1))
      starts <- starts[!allowed]
      ends <- ends[!allowed]
      if (length(starts) == 0L) {
        return(list())
      }

      lapply(seq_along(starts), function(j) {
        lintr::Lint(
          filename = source_expression$filename,
          line_number = ln,
          column_number = starts[j],
          type = "style",
          message = sprintf(
            "Remove Jira ticket reference '%s'; keep the ticket ID in the branch name only.",
            substr(line, starts[j], ends[j])
          ),
          line = line,
          ranges = list(c(starts[j], ends[j]))
        )
      })
    })
    unlist(lints, recursive = FALSE)
  })
}

#' internal_docs_linter
#'
#' Flag a documented function whose Roxygen block does not declare its
#' visibility. Every function with a \code{#'} block must carry \code{@export},
#' \code{@noRd}, or \code{@keywords internal}, so internal helpers do not leak
#' into \code{NAMESPACE} or the pkgdown reference. Undocumented functions
#' (including inline/anonymous ones) are ignored.
#'
#' @author Bartosz Czech <bartosz.czech@contractors.roche.com>
#'
#' @examples
#' linters_config <- lintr::linters_with_defaults(
#'   internal_docs_linter = internal_docs_linter()
#' )
#'
#' @return linter class function
#' @keywords linter
#' @export
internal_docs_linter <- function() {
  lintr::Linter(function(source_file) {
    file_lines <- readLines(source_file$filename, warn = FALSE)
    lapply(
      lintr::ids_with_token(source_file, "FUNCTION"),
      function(id) {
        parsed <- lintr::with_id(source_file, id)
        above <- rev(
          file_lines[seq_len(parsed$line1 - 1L)]
        )
        block <- character(0L)
        for (l in above) {
          if (grepl("^\\s*#'", l)) {
            block <- c(block, l)
          } else {
            break
          }
        }
        # no Roxygen block -> inline/undocumented function, skip
        if (length(block) == 0L) {
          return()
        }
        doc <- paste(block, collapse = "\n")
        has_marker <- grepl("@export", doc) ||
          grepl("@noRd", doc) ||
          grepl("@keywords[[:space:]]+internal", doc)
        if (!has_marker) {
          lintr::Lint(
            filename = source_file$filename,
            line_number = parsed$line1,
            column_number = parsed$col1,
            type = "style",
            message = paste(
              "Documented function must declare @export, @noRd,",
              "or @keywords internal."
            ),
            line = source_file$lines[as.character(parsed$line1)]
          )
        }
      })
  })
}

#' @keywords internal
#' @noRd
skip_lines_withou_prefix <- function(flines) {
  idx <- NA
  for (i in seq_along(flines)) {
    if (grepl(pattern = "@noRd", flines[i]))
      # skip check if @noRd tag is present
      return(NA)
    else if (grepl(pattern = "^#'", flines[i]))
      idx <- i
    else
      break
  }

  idx
}
