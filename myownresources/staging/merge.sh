#!/bin/bash

set -x

# Variables
GITHUB_TOKEN="${GITHUB_TOKEN}"

git branch -a
git checkout -b develop origin/develop
git checkout -b master origin/master
git merge --no-commit develop
git restore --source=HEAD --staged --worktree Jenkinsfile Jenkinsfile_agentes
git commit -m "Merge develop into master sin cambios en Jenkinsfile"
git remote set-url origin https://${GITHUB_TOKEN}@github.com/Taty94/todo-list-aws.git
git push origin master 