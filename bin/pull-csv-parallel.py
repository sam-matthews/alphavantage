import requests
import alpha_vantage
import time
import multiprocessing

def multiprocessing_func(symbol):

  ALP_HOME = "/Users/sam/dev/projects/alphavantage"
  DAT_LOC = ALP_HOME + "/dat/daily"
  CFG_LOC = ALP_HOME + "/cfg"

  API_URL = "https://www.alphavantage.co/query"

  data = {
    "function": "TIME_SERIES_DAILY",
    "symbol": symbol,
    "interval" : "daily",
    "datatype": "csv",
    "apikey": "CQ1QMHUNGM68QOWG" }

  response = requests.get(API_URL, data)
  data = response.text
  file_name = DAT_LOC + '/' + symbol + '.csv'

  with open(file_name, 'w') as f:
    f.write(data)

  print('Completed ' + symbol + '.')


if __name__ == '__main__':

  ALP_HOME = "/Users/sam/dev/projects/alphavantage"
  DAT_LOC = ALP_HOME + "/dat/daily"
  CFG_LOC = ALP_HOME + "/cfg"

  starttime = time.time()
  processes=[]

  fileName=open("/Users/sam/dev/projects/alphavantage/cfg/stocks.csv")

  symbols_tmp = [i for i in fileName.readlines()]
  symbols = [x[:-1] for x in symbols_tmp]

  for symbol in symbols:
    p = multiprocessing.Process(target=multiprocessing_func, args=(symbol,))
    processes.append(p)
    p.start()

    # Add a pause of 1 second.
    time.sleep(0.5)

  for process in processes:
    process.join()

  # print('That took {} seconds'.format(time.time() - starttime))
