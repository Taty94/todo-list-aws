#!/bin/bash

set -x

git branch -a
git checkout -b develop origin/develop
git checkout -b master origin/master
git merge develop
git push origin master 
