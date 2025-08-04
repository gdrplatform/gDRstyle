args <- commandArgs(trailingOnly = TRUE)

PKG_NAME <- args[1]
REPO_DIR <- args[2]
PKG_SUBDIR <- args[3]
LIB_DIR <- args[4]
FAIL_ON <- args[5]
BIOC_CHECK <- args[6]
RUN_EXAMPLES <- as.logical(args[7])
CHECK_VIGNETTES <- as.logical(args[8])

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
  pkgName = PKG_NAME, 
  repoDir = REPO_DIR, 
  subdir = PKG_SUBDIR, 
  fail_on = FAIL_ON, 
  bioc_check = BIOC_CHECK, 
  run_examples = RUN_EXAMPLES,
  build_vignettes = CHECK_VIGNETTES,
  check_vignettes = CHECK_VIGNETTES
)
