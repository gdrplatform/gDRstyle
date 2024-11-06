## gDRstyle 1.5.1 - 2024-11-05
* synchronize Bioconductor and GitHub versioning

## gDRstyle 1.3.3 - 2024-08-29
* add GitLab credentials to pkgdown builds

## gDRstyle 1.3.2 - 2024-06-10
* add debug to the exceptions list

## gDRstyle 1.3.1 - 2024-05-27
* synchronize Bioconductor and GitHub versioning

## gDRstyle 1.1.8 - 2024-03-25
* add as_cran flag

## gDRstyle 1.1.7 - 2024-03-20
* replace `remotes:::version_satisfies_criteria` function

## gDRstyle 1.1.6 - 2024-03-18
* temporary skip verifying version test on Bioc 

## gDRstyle 1.1.5 - 2024-03-04
* remove `:::` from notes exceptions

## gDRstyle 1.1.4 - 2024-02-26
* improve pkgdown site
  * improved references
  * valid NEWS.md

## gDRstyle 1.1.3 - 2024-02-12
* update documentation - pkdown compatibility

## gDRstyle 1.1.2 - 2024-01-16
* adjust lintr configs

## gDRstyle 1.1.1 - 2023-11-22
* sync main with devel branch

## gDRstyle 1.1.0 - 2023-10-24
* release Bioc 3.18

## gDRstyle 1.0.0 - 2023-10-24
* prerelease Bioc 3.18

## gDRstyle 0.99.22 - 2023-10-17
* adjust NEWS to Bioc format

## gDRstyle 0.99.21 - 2023-10-02
* add options to skip tests/lintering in checkPackage

## gDRstyle 0.99.20 - 2023-08-08
* add deploy trigger to workflow template

## gDRstyle 0.99.19 - 2023-06-15
* fix pattern for finding *.R files
* lintr R files from 'inst/shiny' - if present

## gDRstyle 0.99.18 - 2023-06-09
* add reshape2 to lintr config

## gDRstyle 0.99.17 - 2023-05-10
* add check for data.frame-related functions
* update package versioning rules

## gDRstyle 0.99.16 - 2023-05-04
* ignore note for exported functions without examples
* handle properly BiocCheck notes with mulitple lines - notes to be ignored

## gDRstyle 0.99.15 - 2023-05-02
* ignore note for 50 lines per function in biocCheck

## gDRstyle 0.99.14 - 2023-04-27
* removed CRAN check from biocCheck

## gDRstyle 0.99.13 - 2023-04-21
* add check for BiocCheck's notes

## gDRstyle 0.99.12 - 2023-04-20
* switch to OSI license

## gDRstyle 0.99.11 - 2023-04-17
* avoid dependencies upgrade
* add examples check

## gDRstyle 0.99.10 - 2023-04-17
* update style guide - package doc

## gDRstyle 0.99.9 - 2023-04-17
* add R 4.2 as a dependency

## gDRstyle 0.99.8 - 2023-04-13
* fix format in NEWS.md

## gDRstyle 0.99.7 - 2023-04-07
* update maintainer

## gDRstyle 0.99.6 - 2023-04-07
* update the license

## gDRstyle 0.99.5 - 2023-04-06
* update maintainer

## gDRstyle 0.99.4 - 2023-04-05
* remove unstable test

## gDRstyle 0.99.3 - 2023-04-05
* update examples

## gDRstyle 0.99.2 - 2023-04-04
* update examples
* switch to lintr::linters_with_defaults
* add 'test_mode' parameter in installAllDeps

## gDRstyle 0.99.1 - 2023-04-04
* change location of NEW.md file

## gDRstyle 0.99.0 - 2023-03-24
* downgrade version to make it Bioconductor compatible
* fix unit tests

## gDRstyle 0.1.16.17 - 2023-03-23
* move R package from subdir to the maindir

## gDRstyle 0.1.16.16 - 2023-03-22
* fix examples

## gDRstyle 0.1.16.15 - 2023-03-21
* handle BiocCheck

## gDRstyle 0.1.16.14 - 2023-03-15
* appease BiocCheck requirements 

## gDRstyle 0.1.3.13 - 2023-02-10
* increase unit tests coverage

## gDRstyle 0.1.3.12 - 2023-02-01
* fix tests for dependencies check

## gDRstyle 0.1.3.11 - 2023-01-26
* improve dependencies check

## gDRstyle 0.1.3.10 - 2023-01-05
* fix WARNINGS and NOTES in check- 

## gDRstyle 0.1.3.9 - 2023-01-05
* the note test is stricter
