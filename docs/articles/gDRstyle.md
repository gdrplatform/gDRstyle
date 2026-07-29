# Using gDRstyle

## Overview

The `gDRstyle` package is intended to be used during development of
packages within the gDR platform. It has 3 primary uses: (1)to set a
style guide with functions that check that the style is upheld, (2)
during CI to ensure code passes `R CMD check` to maintain the state of
the code in high quality, and (3) for package dependency installation
during gDR platform image building.

## Use Cases

### Style guide

See the written [Style
guide](https://gdrplatform.github.io/gDRstyle/articles/style_guide.html).
The function `lintPkgDirs` can be used to ensure the package is
appropriately linted.

### CI/CD

The `checkPackage` function will check that the package abides by
gDRstyle stylistic requirements, passes `rcmdcheck`, and ensures that
the `dependencies.yml` file used to build gDR platform’s docker image is
kept up-to-date with the dependencies listed in the package’s
`DESCRIPTION` file. This is called in gDR platform packages’ CI/CD.

### Package installation

The function `installAllDeps` assists in installing package
dependencies. For example, it’s used in gdrplatform packages (see
e.g. [link](https://github.com/gdrplatform/gDR/blob/main/Dockerfile)).

## SessionInfo

``` r
sessionInfo()
```

    ## R version 4.6.1 (2026-06-24)
    ## Platform: x86_64-pc-linux-gnu
    ## Running under: Ubuntu 24.04.4 LTS
    ## 
    ## Matrix products: default
    ## BLAS:   /usr/lib/x86_64-linux-gnu/openblas-pthread/libblas.so.3 
    ## LAPACK: /usr/lib/x86_64-linux-gnu/openblas-pthread/libopenblasp-r0.3.26.so;  LAPACK version 3.12.0
    ## 
    ## locale:
    ##  [1] LC_CTYPE=C.UTF-8       LC_NUMERIC=C           LC_TIME=C.UTF-8       
    ##  [4] LC_COLLATE=C.UTF-8     LC_MONETARY=C.UTF-8    LC_MESSAGES=C.UTF-8   
    ##  [7] LC_PAPER=C.UTF-8       LC_NAME=C              LC_ADDRESS=C          
    ## [10] LC_TELEPHONE=C         LC_MEASUREMENT=C.UTF-8 LC_IDENTIFICATION=C   
    ## 
    ## time zone: UTC
    ## tzcode source: system (glibc)
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] gDRstyle_1.11.6  BiocStyle_2.40.0
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] cli_3.6.6           knitr_1.51          rlang_1.3.0        
    ##  [4] xfun_0.60           rex_1.2.2           otel_0.2.0         
    ##  [7] textshaping_1.0.5   data.table_1.18.4   jsonlite_2.0.0     
    ## [10] glue_1.8.1          htmltools_0.5.9     ragg_1.5.2         
    ## [13] sass_0.4.10         rmarkdown_2.31      evaluate_1.0.5     
    ## [16] jquerylib_0.1.4     fastmap_1.2.0       yaml_2.3.12        
    ## [19] lifecycle_1.0.5     bookdown_0.47       BiocManager_1.30.27
    ## [22] compiler_4.6.1      lintr_3.4.0         fs_2.1.0           
    ## [25] systemfonts_1.3.2   digest_0.6.39       R6_2.6.1           
    ## [28] bslib_0.11.0        tools_4.6.1         xml2_1.6.0         
    ## [31] pkgdown_2.2.1       cachem_1.1.0        desc_1.4.3
