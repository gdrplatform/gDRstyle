#/bin/sh
repo_path="$1"

echo "Executing $0"
echo "Environment: ${rp_env}"
echo "Working directory: `pwd`"
echo "Working directory contains: `ls | tr '\n' ' '`"

# exit when any command fails
set -e

echo ">>>>>>>> RUNNING CHECK"
Rscript -e "gDRstyle::checkPackage('gDRutils' , '$repo_path', FALSE)"

