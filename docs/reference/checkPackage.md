# Check R package

Used in gDR platform pacakges' CI/CD pipelines to check that the package
abides by gDRstyle stylistic requirements, passes `rcmdcheck`, and
ensures that the `dependencies.yml` file used to build gDR platform's
docker image is kept up-to-date with the dependencies listed in the
package's `DESCRIPTION` file.

## Usage

``` r
checkPackage(
  pkgName,
  repoDir,
  subdir = NULL,
  fail_on = "warning",
  bioc_check = FALSE,
  run_examples = TRUE,
  skip_lint = FALSE,
  skip_tests = FALSE,
  skip_pkgdown = FALSE,
  build_vignettes = TRUE,
  check_vignettes = TRUE,
  as_cran = FALSE
)
```

## Arguments

- pkgName:

  String of package name.

- repoDir:

  String of path to repository directory.

- subdir:

  String of relative path to the R package root directory from the
  `repoDir`.

- fail_on:

  String specifying the level at which check fail. Supported values:
  `"note"`, `"warning"` (default) and `"error"`.

- bioc_check:

  Logical whether bioc check should be performed

- run_examples:

  Logical whether examples check should be performed

- skip_lint:

  skip lint checks

- skip_tests:

  skip tests

- skip_pkgdown:

  skip pkgdown build

- build_vignettes:

  build vignettes

- check_vignettes:

  check vignettes

- as_cran:

  run with as_cran flag

## Value

`NULL` invisibly.

## Examples

``` r
checkPackage(
  pkgName = "fakePkg",
  repoDir = system.file(package = "gDRstyle", "tst_pkgs", "dummy_pkg"),
  fail_on = "error"
)
#> Lint
#> ##------ Wed Jul 29 09:12:07 2026 ------##
#> Linting file: /tmp/RtmpVW76rT/temp_libpath1cd539c07085/gDRstyle/tst_pkgs/dummy_pkg/R/test.R
#> Linting file: /tmp/RtmpVW76rT/temp_libpath1cd539c07085/gDRstyle/tst_pkgs/dummy_pkg/tests/testthat.R
#> Linting file: /tmp/RtmpVW76rT/temp_libpath1cd539c07085/gDRstyle/tst_pkgs/dummy_pkg/tests/testthat/test-pkg.R
#> All files OK!
#> NEWS.md OK!
#> Tests
#> ##------ Wed Jul 29 09:12:07 2026 ------##
#> ✔ | F W  S  OK | Context
#> 
#> ⠏ |          0 | pkg                                                            
#> ✔ |          1 | pkg
#> 
#> ══ Results ═════════════════════════════════════════════════════════════════════
#> [ FAIL 0 | WARN 0 | SKIP 0 | PASS 1 ]
#> 
#> Way to go!
#> Pkgdown
#> ── Initialising site ───────────────────────────────────────────────────────────
#> Copying <pkgdown>/BS3/assets/bootstrap-toc.css to bootstrap-toc.css
#> Copying <pkgdown>/BS3/assets/bootstrap-toc.js to bootstrap-toc.js
#> Copying <pkgdown>/BS3/assets/docsearch.css to docsearch.css
#> Copying <pkgdown>/BS3/assets/docsearch.js to docsearch.js
#> Copying <pkgdown>/BS3/assets/link.svg to link.svg
#> Copying <pkgdown>/BS3/assets/pkgdown.css to pkgdown.css
#> Copying <pkgdown>/BS3/assets/pkgdown.js to pkgdown.js
#> ── Building function reference ─────────────────────────────────────────────────
#> Writing `reference/index.html`
#> Reading man/tstCharLimitLintr.Rd
#> Writing `reference/tstCharLimitLintr.html`
#> Check
#> ##------ Wed Jul 29 09:12:08 2026 ------##
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#> pdflatex not found! Not building PDF manual.
#> * checking for file ‘.../DESCRIPTION’ ... OK
#> * preparing ‘fakePkg’:
#> * checking DESCRIPTION meta-information ... OK
#> * checking for LF line-endings in source and make files and shell scripts
#> * checking for empty or unneeded directories
#> Removed empty directory ‘fakePkg/tests/testthat/_snaps’
#> * building ‘fakePkg_1.0.tar.gz’
#> 
#> ── R CMD check ─────────────────────────────────────────────────────────────────
#> * using log directory ‘/tmp/RtmpVW76rT/file1cd526a74e42/fakePkg.Rcheck’
#> * using R version 4.6.1 (2026-06-24)
#> * using platform: x86_64-pc-linux-gnu
#> * R was compiled by
#>     gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
#>     GNU Fortran (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
#> * running under: Ubuntu 24.04.4 LTS
#> * using session charset: UTF-8
#> * current time: 2026-07-29 09:12:09 UTC
#> * using options ‘--no-tests --no-manual’
#> * checking for file ‘fakePkg/DESCRIPTION’ ... OK
#> * checking extension type ... Package
#> * this is package ‘fakePkg’ version ‘1.0’
#> * checking package namespace information ... OK
#> * checking package dependencies ... OK
#> * checking if this is a source package ... OK
#> * checking if there is a namespace ... OK
#> * checking for executable files ... OK
#> * checking for hidden files and directories ... OK
#> * checking for portable file names ... OK
#> * checking for sufficient/correct file permissions ... OK
#> * checking whether package ‘fakePkg’ can be installed ... OK
#> * checking installed package size ... OK
#> * checking package directory ... OK
#> * checking DESCRIPTION meta-information ... NOTE
#> Malformed Description field: should contain one or more complete sentences.
#> Non-standard license specification:
#>   What license is it under?
#> Standardizable: FALSE
#> * checking top-level files ... OK
#> * checking for left-over files ... OK
#> * checking index information ... OK
#> * checking package subdirectories ... OK
#> * checking code files for non-ASCII characters ... OK
#> * checking R files for syntax errors ... OK
#> * checking whether the package can be loaded ... OK
#> * checking whether the package can be loaded with stated dependencies ... OK
#> * checking whether the package can be unloaded cleanly ... OK
#> * checking whether the namespace can be loaded with stated dependencies ... OK
#> * checking whether the namespace can be unloaded cleanly ... OK
#> * checking loading without being on the library search path ... OK
#> * checking dependencies in R code ... OK
#> * checking S3 generic/method consistency ... OK
#> * checking replacement functions ... OK
#> * checking foreign function calls ... OK
#> * checking R code for possible problems ... OK
#> * checking Rd files ... OK
#> * checking Rd metadata ... OK
#> * checking Rd cross-references ... OK
#> * checking for missing documentation entries ... OK
#> * checking for code/documentation mismatches ... OK
#> * checking Rd \usage sections ... OK
#> * checking Rd contents ... OK
#> * checking for unstated dependencies in examples ... OK
#> * checking examples ... NONE
#> * checking for unstated dependencies in ‘tests’ ... OK
#> * checking tests ... SKIPPED
#> * DONE
#> 
#> Status: 1 NOTE
#> See
#>   ‘/tmp/RtmpVW76rT/file1cd526a74e42/fakePkg.Rcheck/00check.log’
#> for details.
#> Finished
#> ##------ Wed Jul 29 09:12:17 2026 ------##
```
