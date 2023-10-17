## 0.99.22 (2023-10-17)
- adjust NEWS to Bioc format

## 0.99.21 (2023-10-02)
- add options to skip tests/lintering in checkPackage

## 0.99.20 (2023-08-08)
- add deploy trigger to workflow template

## 0.99.19 (2023-06-15)
- fix pattern for finding *.R files
- lintr R files from 'inst/shiny' (if present)

## 0.99.18 (2023-06-09)
- add reshape2 to lintr config

## 0.99.17 (2023-05-10)
- add check for data.frame-related functions
- update package versioning rules

## 0.99.16 (2023-05-04)
- ignore note for exported functions without examples
- handle properly BiocCheck notes with mulitple lines (notes to be ignored)

## 0.99.15 (2023-05-02)
- ignore note for 50 lines per function in biocCheck

## 0.99.14 (2023-04-27)
- removed CRAN check from biocCheck

## 0.99.13 (2023-04-21)
- add check for BiocCheck's notes

## 0.99.12 (2023-04-20
- switch to OSI license

## 0.99.11 (2023-04-17)
- avoid dependencies upgrade
- add examples check

## 0.99.10 (2023-04-17)
- update style guide (package doc)

## 0.99.9 (2023-04-17)
- add R 4.2 as a dependency

## 0.99.8 (2023-04-13)
- fix format in NEWS.md

## 0.99.7 (2023-04-07)
- update maintainer

## 0.99.6 (2023-04-07)
- update the license

## 0.99.5 (2023-04-06)
- update maintainer

## 0.99.4 (2023-04-05)
- remove unstable test

## 0.99.3 (2023-04-05)
- update examples

## 0.99.2 (2023-04-04)
- update examples
- switch to lintr::linters_with_defaults
- add 'test_mode' parameter in installAllDeps

## 0.99.1 (2023-04-04)
- change location of NEW.md file

## 0.99.0 (2023-03-24)
- downgrade version to make it Bioconductor compatible
- fix unit tests

## 0.1.16.17 (2023-03-23)
- move R package from subdir to the maindir

## 0.1.16.16 (2023-03-22)
- fix examples

## 0.1.16.15 (2023-03-21)
- handle BiocCheck

## 0.1.16.14 (2023-03-15)
- appease BiocCheck requirements 

## 0.1.3.13 (2023-02-10)
- increase unit tests coverage

## 0.1.3.12 (2023-02-01)
- fix tests for dependencies check

## 0.1.3.11 (2023-01-26)
- improve dependencies check

## 0.1.3.10 (2023-01-05)
- fixed WARNINGS and NOTES in check()

## 0.1.3.9 (2023-01-05)
- the note test is stricter
