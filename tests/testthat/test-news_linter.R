test_that(".check_bullet flags entry that is too long", {
  long <- paste(rep("x", 101L), collapse = "")
  vs <- .check_bullet(long, 1L, 100L)
  expect_true(any(grepl("too long", vapply(vs, `[[`, "", "msg"))))
})

test_that(".check_bullet accepts entry within limit", {
  vs <- .check_bullet("Add support for new linter rule", 1L, 100L)
  expect_length(vs, 0L)
})

test_that(".check_bullet flags trailing period", {
  vs <- .check_bullet("Fix broken test.", 1L, 100L)
  expect_true(any(grepl("ends with a period", vapply(vs, `[[`, "", "msg"))))
})

test_that(".check_bullet flags unknown first word", {
  vs <- .check_bullet("New linter added", 1L, 100L)
  expect_true(any(grepl("imperative verb", vapply(vs, `[[`, "", "msg"))))
})

test_that(".check_bullet flags banned phrase", {
  vs <- .check_bullet("Add functionality for parsing", 1L, 100L)
  expect_true(any(grepl("banned phrase", vapply(vs, `[[`, "", "msg"))))
})

test_that(".check_bullet flags 'has been' passive voice", {
  vs <- .check_bullet("Fix issue that has been present since v1", 1L, 100L)
  expect_true(any(grepl("has been", vapply(vs, `[[`, "", "msg"))))
})

test_that(".check_header accepts valid version header", {
  expect_null(.check_header("## gDRstyle 1.2.3 - 2026-01-15", 1L))
})

test_that(".check_header flags malformed header", {
  v <- .check_header("## gDRstyle v1.2.3", 1L)
  expect_true(grepl("malformed", v$msg))
})

test_that("lintNewsEntries passes on valid NEWS.md", {
  pkg_dir <- withr::local_tempdir()
  writeLines(c(
    "## myPkg 1.0.0 - 2026-01-01",
    "* Add initial implementation",
    "* Fix edge case in parser"
  ), file.path(pkg_dir, "NEWS.md"))
  expect_message(lintNewsEntries(pkg_dir), "OK")
})

test_that("lintNewsEntries stops on violations", {
  pkg_dir <- withr::local_tempdir()
  writeLines(c(
    "## myPkg 1.0.0 - 2026-01-01",
    "* This functionality has been added."
  ), file.path(pkg_dir, "NEWS.md"))
  expect_error(lintNewsEntries(pkg_dir), "violations")
})

test_that("lintNewsEntries skips missing NEWS.md with message", {
  pkg_dir <- withr::local_tempdir()
  expect_message(lintNewsEntries(pkg_dir), "No NEWS.md")
})
