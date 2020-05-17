#!/bin/bash

cd "$(dirname "$0")";
CWD="$(pwd)"
echo $CWD

export PYTHON_PATH=/Library/Frameworks/Python.framework/Versions/3.8/lib/python3.8/site-packages
echo ${PYTHON_PATH}

python3 /Users/sam/dev/projects/alphavantage/bin/pull-csv-parallel.py


