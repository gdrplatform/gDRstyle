args <- commandArgs(trailingOnly = TRUE)

PKG_NAME <- args[1]
REPO_DIR <- args[2]
PKG_SUBDIR <- args[3]
LIB_DIR <- args[4]
FAIL_ON <- args[5]
BIOC_CHECK <- args[6]
RUN_EXAMPLES <- as.logical(args[7])

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
gDRstyle::checkPackage(
  PKG_NAME, 
  REPO_DIR, 
  PKG_SUBDIR, 
  FAIL_ON, 
  BIOC_CHECK, 
  RUN_EXAMPLES
)
