#!/bin/bash

set -x
python -m venv todo-list-aws
source todo-list-aws/bin/activate
python -m pip install --upgrade pip
#For static testing
python -m pip install flake8
#python -m pip install flake8-polyfill
python -m pip install bandit
#For integration testing
python -m pip install pytest
python -m pip install requests


pwd
