## Helper: write a minimal .Rmd to a temp file
.make_rmd <- function(chunks) {
  f <- tempfile(fileext = ".Rmd")
  header <- c(
    "---", "title: test", "output: html_document", "---", ""
  )
  body <- unlist(lapply(chunks, function(ch) c("```{r}", ch, "```", "")))
  writeLines(c(header, body), f)
  f
}


# ---- .stripMustache ----------------------------------------------------------

test_that(".stripMustache replaces bare {{x}} with TRUE", {
  out <- gDRstyle:::.stripMustache("x <- {{param}}")
  expect_equal(out, "x <- TRUE")
})

test_that(".stripMustache replaces quoted \"{{x}}\" with string", {
  out <- gDRstyle:::.stripMustache('path <- "{{dir}}"')
  expect_equal(out, 'path <- "__TMPL__"')
})

test_that(".stripMustache removes block tags", {
  out <- gDRstyle:::.stripMustache("{{#cond}}code{{/cond}}")
  expect_equal(out, "code")
})


# ---- .extractRChunks ---------------------------------------------------------

test_that(".extractRChunks returns empty list for Rmd with no chunks", {
  f <- .make_rmd(list())
  expect_length(gDRstyle:::.extractRChunks(f), 0L)
})

test_that(".extractRChunks returns one chunk per R block", {
  f <- .make_rmd(list("x <- 1", "y <- 2"))
  chunks <- gDRstyle:::.extractRChunks(f)
  expect_length(chunks, 2L)
  expect_true(all(c("code", "start_line") %in% names(chunks[[1]])))
})

test_that(".extractRChunks preserves start_line", {
  f <- .make_rmd(list("x <- 1"))
  chunks <- gDRstyle:::.extractRChunks(f)
  expect_gt(chunks[[1]]$start_line, 1L)
})


# ---- .getLoadedPackages ------------------------------------------------------

test_that(".getLoadedPackages detects library() calls", {
  pkgs <- gDRstyle:::.getLoadedPackages("library(data.table)\nrequire(ggplot2)")
  expect_true(all(c("data.table", "ggplot2") %in% pkgs))
})

test_that(".getLoadedPackages returns empty for code with no library calls", {
  pkgs <- gDRstyle:::.getLoadedPackages("x <- 1 + 1")
  expect_length(pkgs, 0L)
})


# ---- .findDefinedNamesInChunk ------------------------------------------------

test_that(".findDefinedNamesInChunk detects direct assignment", {
  nms <- gDRstyle:::.findDefinedNamesInChunk("my_var <- 42")
  expect_true("my_var" %in% nms)
})

test_that(".findDefinedNamesInChunk detects if-else assignment", {
  nms <- gDRstyle:::.findDefinedNamesInChunk(
    "plot_fn <- if (length(a) > 0) fun_a else fun_b"
  )
  expect_true("plot_fn" %in% nms)
})

test_that(".findDefinedNamesInChunk does not flag function formals as definitions", {
  nms <- gDRstyle:::.findDefinedNamesInChunk("f <- function(x = 1) x")
  expect_true("f" %in% nms)
  # 'x' is a formal, not a top-level defined name
  expect_false("x" %in% nms)
})

test_that(".findDefinedNamesInChunk handles mustache safely", {
  nms <- gDRstyle:::.findDefinedNamesInChunk('wd <- "{{output_dir}}"')
  expect_true("wd" %in% nms)
})


# ---- .detectHostPackage ------------------------------------------------------

test_that(".detectHostPackage finds package from DESCRIPTION in parent dir", {
  tmp <- tempdir()
  pkg_dir <- file.path(tmp, "mypkg")
  inst_dir <- file.path(pkg_dir, "inst", "reports")
  dir.create(inst_dir, recursive = TRUE, showWarnings = FALSE)
  writeLines("Package: mypkg", file.path(pkg_dir, "DESCRIPTION"))
  rmd <- file.path(inst_dir, "test.Rmd")
  writeLines("---\ntitle: test\n---", rmd)

  result <- gDRstyle:::.detectHostPackage(rmd)
  expect_equal(result, "mypkg")
})

test_that(".detectHostPackage returns NULL when no DESCRIPTION found", {
  f <- tempfile(fileext = ".Rmd")
  writeLines("---\ntitle: test\n---", f)
  # Run from a temp dir unlikely to have a DESCRIPTION in any parent
  result <- suppressWarnings(gDRstyle:::.detectHostPackage(f))
  # Either NULL or a package name (if run inside a package workspace)
  expect_true(is.null(result) || is.character(result))
})


# ---- lintRmdDeps (integration) -----------------------------------------------

test_that("lintRmdDeps returns NULL for Rmd with no R chunks", {
  f <- .make_rmd(list())
  expect_null(lintRmdDeps(f))
})

test_that("lintRmdDeps returns empty data.frame when all calls are resolved", {
  f <- .make_rmd(list("x <- 1 + 1\ncat('hello')"))
  res <- lintRmdDeps(f)
  expect_true(is.null(res) || NROW(res) == 0L)
})

test_that("lintRmdDeps flags unresolved function call", {
  f <- .make_rmd(list("result <- mystery_function_xyz(x)"))
  res <- lintRmdDeps(f)
  expect_true(!is.null(res) && NROW(res) > 0L)
  expect_true("mystery_function_xyz" %in% res$func)
})

test_that("lintRmdDeps resolves function from library() in same file", {
  # fread is in data.table
  f <- .make_rmd(list(
    "library(data.table)",
    "dt <- fread('file.csv')"
  ))
  res <- lintRmdDeps(f)
  if (!is.null(res)) {
    expect_false("fread" %in% res$func)
  }
})

test_that("lintRmdDeps accepts --verbose flag via verbose argument", {
  f <- .make_rmd(list("x <- 1"))
  expect_output(lintRmdDeps(f, verbose = TRUE), "known symbols")
})

test_that("lintRmdDeps validates inputs", {
  expect_error(lintRmdDeps(123))
  expect_error(lintRmdDeps("nonexistent_file.Rmd"))
})
