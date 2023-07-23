#!/bin/bash

ulimit -n 10000
source ${HOME}/dev/python/my-python/bin/activate
python /Users/sam/dev/gh/alphavantage/bin/pull-csv-parallel.py



