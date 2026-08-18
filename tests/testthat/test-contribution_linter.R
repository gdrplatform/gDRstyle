# nolint start: ticket_ref_linter.
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

test_that(".check_file_ticket_refs flags references in a file", {
  f <- withr::local_tempfile(fileext = ".md")
  writeLines(c("## pkg 1.0.0 - 2026-01-01", "* fix bug from GDR-1234"), f)
  vs <- .check_file_ticket_refs(f)
  expect_length(vs, 1L)
})

test_that(".check_file_ticket_refs returns nothing for a missing file", {
  expect_length(.check_file_ticket_refs(withr::local_tempfile()), 0L)
})

test_that("lintTicketRefs passes a clean package", {
  dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
  expect_message(lintTicketRefs(dir), "OK")
})

test_that("lintTicketRefs stops on a ticket reference in NEWS.md", {
  dir <- withr::local_tempdir()
  writeLines("Version: 1.0.0", file.path(dir, "DESCRIPTION"))
  writeLines(c("## pkg 1.0.0 - 2026-01-01", "* add feature GDR-9"),
             file.path(dir, "NEWS.md"))
  expect_error(lintTicketRefs(dir), "violations")
})

test_that("lintBranchName passes a bare ticket branch", {
  expect_message(lintBranchName("GDR-3455"), "OK")
})

test_that("lintBranchName exempts protected branches", {
  expect_message(lintBranchName("main"), "OK")
  expect_message(lintBranchName("devel"), "OK")
})

test_that("lintBranchName stops on a ticket branch with a suffix", {
  expect_error(lintBranchName("GDR-3491-incucyte-report"), "violations")
})

test_that("lintBranchName stops on a branch with no ticket", {
  expect_error(lintBranchName("feature/new-linter"), "violations")
})

test_that("lintMergeRequest checks the branch when provided", {
  dir <- withr::local_tempdir()
  expect_error(lintMergeRequest("feat: add linter", "body", dir, "GDR-9-extra"),
               "violations")
})

test_that("lintMergeRequest stops on a ticket in the title", {
  expect_error(lintMergeRequest("feat: add linter GDR-9", "body", tempdir()),
               "violations")
})

test_that("lintMergeRequest skips template check when none is present", {
  dir <- withr::local_tempdir()
  expect_message(lintMergeRequest("feat: add linter", "body", dir), "skipped")
})

test_that("lintMergeRequest enforces the template when present", {
  dir <- withr::local_tempdir()
  gh <- file.path(dir, ".github")
  dir.create(gh)
  writeLines(c("# Description", "## What changed?"),
             file.path(gh, "PULL_REQUEST_TEMPLATE.md"))
  expect_error(lintMergeRequest("feat: add linter", "", dir), "violations")
})

test_that(".check_ticket_refs reports the matched fragment", {
  vs <- .check_ticket_refs("fix: bug (gdr-1234)", "(?i)\\(GDR-[0-9]+\\)",
                           "commit message")
  expect_true(any(grepl("(gdr-1234)", vapply(vs, `[[`, "", "msg"),
                        fixed = TRUE)))
})

test_that("lintPrTitle catches lowercase ticket references", {
  expect_error(lintPrTitle("feat: add linter gdr-9"), "violations")
})

test_that("lintCommitMessages catches lowercase parenthesized references", {
  expect_error(lintCommitMessages("fix: bug (gdr-9)"), "violations")
})

test_that(".extract_template_headers drops optional sections", {
  tmpl <- withr::local_tempfile()
  writeLines(c("# Description", "# Screenshots (optional)"), tmpl)
  hdrs <- .extract_template_headers(tmpl)
  expect_true("# Description" %in% hdrs)
  expect_false(any(grepl("Screenshots", hdrs)))
})

test_that("lintBranchName exempts Bioconductor release branches", {
  expect_message(lintBranchName("RELEASE_3_20"), "OK")
})

test_that("lintBranchName honours a custom pattern and exempt set", {
  expect_message(lintBranchName("legacy-shared", exempt = "^legacy-"), "OK")
  expect_message(lintBranchName("JIRA-1", pattern = "^JIRA-[0-9]+$"), "OK")
})
# nolint end

test_that("assertVersionBumped passes on a higher version", {
  expect_message(assertVersionBumped("1.0.0", "1.0.1"), "OK")
})

test_that("assertVersionBumped stops on an equal or lower version", {
  expect_error(assertVersionBumped("1.0.1", "1.0.1"), "bumped")
  expect_error(assertVersionBumped("1.0.1", "1.0.0"), "bumped")
})
