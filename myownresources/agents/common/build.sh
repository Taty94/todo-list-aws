#!/bin/bash

#source todo-list-aws/bin/activate
set -x
sam validate --region $AWS_REGION
sam build