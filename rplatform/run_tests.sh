#/bin/sh
repo_path="$1"

echo "Executing $0"
echo "Environment: ${rp_env}"
echo "Working directory: `pwd`"
echo "Working directory contains: `ls | tr '\n' ' '`"

# exit when any command fails
set -e

echo ">>>>>>>> Running linter"
Rscript -e "gDRstyle::lintPkgDirs('$repo_path')"

echo ">>>>> RUNNING UNIT TESTS"
Rscript -e "testthat::test_local(path = '$repo_path', stop_on_failure = TRUE)"

echo ">>>>> RUNNING DEVTOOLS::CHECK()"
sudo R CMD check --no-build-vignettes --no-manual --no-tests "$repo_path"

