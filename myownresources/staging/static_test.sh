#!/bin/bash

source todo-list-aws/bin/activate
set -x

flake8 --format=pylint src >flake8.out
if [[ $? -ne 0 ]]
then
    exit 1
fi
bandit -r src -f custom -o bandit.out --msg-template "{abspath}:{line}: [{test_id}] {msg}"
if [[ $? -ne 0 ]]
then
    exit 1
fi