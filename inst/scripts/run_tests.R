PKG_NAME <- commandArgs(trailingOnly = TRUE)[1]
REPO_DIR <- commandArgs(trailingOnly = TRUE)[2]
PKG_SUBDIR <- commandArgs(trailingOnly = TRUE)[3]
LIB_DIR <- commandArgs(trailingOnly = TRUE)[4]

print(paste("Name:", PKG_NAME))
print(paste("Repo:", REPO_DIR))
print(paste("Subdir:", PKG_SUBDIR))
print(paste("Lib:", LIB_DIR))

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
gDRstyle::checkPackage(PKG_NAME, REPO_DIR, as.logical(PKG_SUBDIR))
