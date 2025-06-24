#!/bin/bash

source todo-list-aws/bin/activate
set -x

flake8 --format=pylint src >flake8.out
if [[ $? -ne 0 ]]
then
   # exit 1
   echo "\033[1;33mFlake8 encontró problemas, pero la ejecución continuará.\033[0m"
fi
bandit -r src -f custom -o bandit.out --msg-template "{abspath}:{line}: [{test_id}] {msg}"
if [[ $? -ne 0 ]]
then
    echo "\033[1;33mBandit encontró problemas, pero la ejecución continuará.\033[0m"
fi