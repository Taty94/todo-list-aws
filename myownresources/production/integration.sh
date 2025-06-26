#!/bin/bash

source todo-list-aws/bin/activate
set -x
export BASE_URL=$1
pytest -s -m selected test/integration/todoApiTest.py
