pacman::p_load(readxl, tidyverse, Rfssa, plotly, fda,
               cranly, ggplot2, vtable)

discrete <- read_excel("Data/discrete.xls")
IDinfo <- read_excel("Data/IDinfo.xls")

range(IDinfo$ID)
range(IDinfo$TRIAL)
range(IDinfo$tr_length)

st(IDinfo)
#ID 1-2291
#Trials 1-7
#tr_length 472-1299, mean= 750.613
#some of the info in this table is not meaningful

total_trails <- IDinfo %>% group_by(ID, KNEE) %>% summarise(TRIAL = max(TRIAL), .groups= 'keep')
mean_tr <- IDinfo %>% group_by(ID, KNEE) %>% summarise(tr_length = mean(tr_length), .groups= 'keep')
SUM_IDinfo <- full_join(total_trails, mean_tr)


