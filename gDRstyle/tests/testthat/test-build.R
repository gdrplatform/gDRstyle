testthat::test_that("set repos properly", {
  repos <- getOption("repos")
  testthat::expect_false("DUMMY" %in% names(repos))

  setReposOpt(additionalRepos = c(DUMMY = "DUMMY_REPO"))
  new_repos <- getOption("repos")
  testthat::expect_true(all(c("CRAN", "DUMMY") %in% names(new_repos)))
})

testthat::test_that("set tokens properly", {
  on.exit({
    Sys.unsetenv("DUMMY_TOKEN")
    Sys.unsetenv("DUMMY_ENV")
    Sys.unsetenv("DUMMY_ENV_2")
  })
  
  base_dir <- system.file(package = "gDRstyle", "tst_tokens")
  # SINGLE TOKEN
  setTokenVar(base_dir, "dummy_single_token.txt")
  testthat::expect_equal(
    Sys.getenv("GITHUB_PAT"),
    "DUMMY_TOKEN"
  )
  testthat::expect_equal(
    Sys.getenv("DUMMY_ENV"), ""
  )
  # MULTIPLE TOKENS
  setTokenVar(base_dir, "dummy_multi_token.txt")
  testthat::expect_equal(
    Sys.getenv("DUMMY_ENV"),
    "DUMMY_TOKEN"
  )
  testthat::expect_equal(
    Sys.getenv("DUMMY_ENV_2"),
    "DUMMY_TOKEN_2"
  )
})

testthat::test_that("verify version properly", {
  testthat::expect_no_error(verify_version("base", ">=1.0.0"))
  testthat::expect_error(
    verify_version("base", ">= 5.0.0"),
    regexp = "Invalid version of base"
  )
  testthat::expect_error(
    verify_version("base", "dummy"),
    regexp = "Invalid comparison operator"
  )
})

testthat::test_that("install local properly", {
  on.exit(remove.packages("fakePkg"))
  testthat::expect_error(
    utils::packageVersion("fakePkg"),
    regexp = "there is no package called"
  )
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
  installLocalPackage(pkg_path)
  testthat::expect_no_error(utils::packageVersion("fakePkg"))
})

testthat::test_that("install deps properly", {
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs")
  testthat::expect_error(
    installAllDeps(base_dir = pkg_path),
    regexp = "Invalid or unsupported source attribute"
  )
})
