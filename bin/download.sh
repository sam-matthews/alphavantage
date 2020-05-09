#!/bin/bash
# download.sh
# Sam Matthews
# 22nd September 2019

# Description
# ============
# Script will download US Stock data based on CFG list.

# Modifications:
# Moved Sleep to 12
# Moved DAT to seperate directories for DAILY and WEEKLY
# New function for weekly data

# Setup

# API: curl https://www.alphavantage.co/query\?function\=TIME_SERIES_DAILY\&symbol\=AAPL\&apikey\=WHWGAETT94IZAL0B\&datatype\=csv --output AAPL.csv
# Parameters

DEV_HOME="${HOME}/dev/projects/alphavantage"
CFG=${DEV_HOME}/cfg
LOG=${DEV_HOME}/log
DAT=${DEV_HOME}/dat
BIN=${DEV_HOME}/bin
DAT_DAILY=${DAT}/daily
DAT_WEEKLY=${DAT}/weekly

BASEURL="https://www.alphavantage.co/query?function"
DAILY_FUNCTION="TIME_SERIES_DAILY"
WEEKLY_FUNCTION="TIME_SERIES_WEEKLY"
SMAFUNCTION="SMA"
SMAINTERVAL="daily"
SERIESTYPE="close"
TIMEPERIOD="300"
OUTPUTSIZE="full"
# APIKEY="WHWGAETT94IZAL0B"
APIKEY="CQ1QMHUNGM68QOWG"
DATATYPE="csv"

CURR_DATE=`date +%Y%m%d`
CURR_TIME=`date +%Y%m%d-%H:%M:%S`
SLEEP=0
SCRIPT_LOGFILE="${LOG}/download-${CURR_DATE}.log"

check_symbol() {
  if [ ! -f "${CFG}/symbol.cfg" ]; then
    echo "Error: No symbol.cfg has been created. Stopping script."
    exit 10
  fi
} #check_symbol

check_directories() {

  DIR_NAME=$1

  if [ ! -d "${DIR_NAME}" ]; then
    mkdir -p ${DIR_NAME}
    echo "Create directory: ${DIR_NAME}"
  fi
}


get_daily_price () {

  check_symbol
  check_directories ${DAT_DAILY}

  for SYMBOL in $(cat ${CFG}/symbol.cfg)
  do
    echo "${CURR_TIME}: downloading day data for ${SYMBOL}." >> ${SCRIPT_LOGFILE} 2>&1

    LOG_FILE="${LOG}/${SYMBOL}.log"
    OUTPUT_FILE="${DAT_DAILY}/${SYMBOL}.${DATATYPE}"
    URL="${BASEURL}=${DAILY_FUNCTION}&symbol=${SYMBOL}&outputsize=${OUTPUTSIZE}&apikey=${APIKEY}&datatype=${DATATYPE}"
    curl ${URL} --output ${OUTPUT_FILE} > ${LOG_FILE} 2>&1
    sleep ${SLEEP}
  done
}

get_weekly_price () {

  check_directories ${DAT_WEEKLY}

  for SYMBOL in $(cat ${CFG}/symbol.cfg)
  do
    echo "${CURR_TIME}: downloading week data for ${SYMBOL}." >> ${SCRIPT_LOGFILE} 2>&1

    LOG_FILE="${LOG}/${SYMBOL}-WEEKLY.log"
    OUTPUT_FILE="${DAT_WEEKLY}/${SYMBOL}.${DATATYPE}"
    URL="${BASEURL}=${WEEKLY_FUNCTION}&symbol=${SYMBOL}&outputsize=${OUTPUTSIZE}&apikey=${APIKEY}&datatype=${DATATYPE}"
    curl ${URL} --output ${OUTPUT_FILE} > ${LOG_FILE} 2>&1
    sleep ${SLEEP}
  done
}

get_sma_daily () {

  # set parameter
  SMATIMEPERIOD=$1

  check_directories ${DAT}/SMA${SMATIMEPERIOD}
  #check if DAT directory exists. Create it if it does not.
  if [ ! -d ${DAT}/SMA${SMATIMEPERIOD} ]; then
    mkdir -p ${DAT}/SMA${SMATIMEPERIOD}
  fi

  # LOOP, to download data
  for SYMBOL in $(cat ${CFG}/symbol.cfg)
  do
    echo "${CURR_TIME}: downloading SMA ${SMATIMEPERIOD} day data for ${SYMBOL}." \
      >> ${SCRIPT_LOGFILE} 2>&1

    LOG_FILE="${LOG}/${SYMBOL}-SMA-${SMATIMEPERIOD}.log"
    OUTPUT_FILE="${DAT}/SMA${SMATIMEPERIOD}/${SYMBOL}.${DATATYPE}"

    URL="${BASEURL}=${SMAFUNCTION}&symbol=${SYMBOL}&interval=${SMAINTERVAL}&time_period=${SMATIMEPERIOD}&series_type=${SERIESTYPE}&apikey=${APIKEY}&datatype=${DATATYPE}"

    curl ${URL} --output ${OUTPUT_FILE} > ${LOG_FILE} 2>&1
    sleep ${SLEEP}
  done
}

#
# MAIN
#

check_directories ${CFG}
check_directories ${BIN}
check_directories ${DAT}
check_directories ${LOG}

get_daily_price
get_weekly_price
# get_sma_daily 6
# get_sma_daily 12

# TAR Files

# tar xvf ${DAT} stock-data-${CURR_DATE}.tar
