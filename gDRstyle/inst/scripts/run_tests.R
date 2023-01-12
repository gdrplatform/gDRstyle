PKG_NAME <- commandArgs(trailingOnly = TRUE)[1]
REPO_DIR <- commandArgs(trailingOnly = TRUE)[2]
PKG_SUBDIR <- commandArgs(trailingOnly = TRUE)[3]
LIB_DIR <- commandArgs(trailingOnly = TRUE)[4]
FAIL_ON <- commandArgs(trailingOnly = TRUE)[5]

# Load libraries
stopifnot(dir.exists(LIB_DIR))
invisible(
  sapply(
    list.files(LIB_DIR, , pattern = "*.R$", full.names = TRUE), 
    source, 
    .GlobalEnv
  )
)

# Check package
gDRstyle::checkPackage(PKG_NAME, REPO_DIR, PKG_SUBDIR, FAIL_ON)
