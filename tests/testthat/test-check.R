testthat::test_that("package check works correct", {
  dir <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")

  # FAIL ON ERROR CHECK
  testthat::expect_no_error(checkPackage("fakePkg", dir, fail_on = "error"))
})

testthat::test_that("test_notes_check supports vector length in valid_notes_list", {
  make_check <- function(notes) {
    list(notes = notes)
  }

  valid_notes <- list(
    list(length = c(2L, 3L), index_to_check = 1L, text_to_check = "installed size")
  )

  note_2lines <- "checking installed size ... NOTE\ninstalled size is 5Mb"
  note_3lines <- "checking installed size ... NOTE\ninstalled size is 5Mb\nsub-directories with large sizes"
  note_invalid <- "checking installed size ... NOTE\nsome other text\nextra\nfourth line"

  testthat::expect_no_error(
    test_notes_check(make_check(note_2lines), NULL, valid_notes)
  )
  testthat::expect_no_error(
    test_notes_check(make_check(note_3lines), NULL, valid_notes)
  )
  testthat::expect_error(
    test_notes_check(make_check(note_invalid), NULL, valid_notes)
  )
})
