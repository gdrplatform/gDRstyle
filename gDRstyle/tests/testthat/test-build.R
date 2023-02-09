testthat::test_that("set repos properly", {
  testthat::expect_equal(getOption("repos"), c(CRAN = "@CRAN@"))
  setReposOpt(additionalRepos = c(DUMMY = "DUMMY_REPO"))
  testthat::expect_equal(
    getOption("repos"),
    c(
      CRAN = "https://cran.microsoft.com/snapshot/2023-01-20",
      DUMMY = "DUMMY_REPO"
    )
  )
})

testthat::test_that("set tokens properly", {
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
  testthat::expect_error(
    packageVersion("fakePkg"),
    regexp = "there is no package called"
  )
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg")
  installLocalPackage(pkg_path)
  testthat::expect_no_error(packageVersion("fakePkg"))
  remove.packages("fakePkg")
})

testthat::test_that("install deps properly", {
  pkg_path <- system.file(package = "gDRstyle", "tst_pkgs")
  testthat::expect_error(
    installAllDeps(base_dir = pkg_path),
    regexp = "Invalid or unsupported source attribute"
  )
})
