test_that(".check_ticket_refs flags parenthesized reference", {
  vs <- .check_ticket_refs("fix: bug (GDR-1234)", "\\(GDR-[0-9]+\\)", "commit message")
  expect_length(vs, 1L)
})

test_that(".check_ticket_refs ignores bare reference for parenthesized pattern", {
  vs <- .check_ticket_refs("fix: bug GDR-1234", "\\(GDR-[0-9]+\\)", "commit message")
  expect_length(vs, 0L)
})

test_that(".check_ticket_refs flags bare reference for broad pattern", {
  vs <- .check_ticket_refs("fix: bug GDR-1234", "GDR-[0-9]+", "PR title")
  expect_length(vs, 1L)
})

test_that(".check_pr_template flags missing headers", {
  vs <- .check_pr_template("# Description\nsome text", c("# Description", "## What changed?"))
  expect_length(vs, 1L)
  expect_true(any(grepl("What changed", vapply(vs, `[[`, "", "msg"))))
})

test_that(".check_pr_template accepts a body with all headers", {
  vs <- .check_pr_template("# Description\n## What changed?\ntext", c("# Description", "## What changed?"))
  expect_length(vs, 0L)
})

test_that("lintCommitMessages stops on parenthesized ticket", {
  expect_error(lintCommitMessages("fix: parser bug (GDR-3471)"), "violations")
})

test_that("lintCommitMessages passes clean messages", {
  expect_message(lintCommitMessages(c("fix: parser bug", "feat: add linter")), "OK")
})

test_that("lintPrTitle stops on any ticket reference", {
  expect_error(lintPrTitle("feat: add linter GDR-9"), "violations")
})

test_that("lintPrTitle passes a clean title", {
  expect_message(lintPrTitle("feat: add linter"), "OK")
})

test_that("checkPrTemplate stops on an empty body", {
  tmpl <- withr::local_tempfile()
  writeLines(c("# Description", "## What changed?"), tmpl)
  expect_error(checkPrTemplate("", tmpl), "violations")
})

test_that("checkPrTemplate passes a filled body", {
  tmpl <- withr::local_tempfile()
  writeLines(c("# Description", "## What changed?"), tmpl)
  expect_message(
    checkPrTemplate("# Description\n## What changed?\ndetails", tmpl), "OK"
  )
})
