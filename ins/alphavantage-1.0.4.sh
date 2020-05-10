#!/bin/bash

# alphavantage-1.0.4.sh
# Sam Matthews
# 10th May 2020

# Remove ability to download SMA from alphavantage.
#This install script will remove additional dat directories.

APPHOME=${ALPHAVANTAGE}

rm -rf ${APPHOME}/dat/SMA6
rm -rf ${APPHOME}/dat/SMA12

