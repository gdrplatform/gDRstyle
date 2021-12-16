#!/bin/bash
# Get all directories within gDR.
GDR_PARENT_DIR=~/code/gDR
GDR_GITHUB_REPOS=`find ${GDR_PARENT_DIR}/gDR*/.github -maxdepth 0 -type d`
NEW_BRANCH="add_pr_template"

for REPO in ${GDR_GITHUB_REPOS}
do
  cd ${REPO}
  git checkout master
  git checkout -b ${NEW_BRANCH}
  cp ~/code/gDR/gDRstyle/.github/PULL_REQUEST_TEMPLATE.md ${REPO}/PULL_REQUEST_TEMPLATE.md
  git add ${REPO}/PULL_REQUEST_TEMPLATE.md
  git commit -m "chore: add pull request template"
  git push -u origin ${NEW_BRANCH}
done
