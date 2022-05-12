pacman::p_load(readxl, tidyverse, Rfssa, plotly, fda,
               cranly, ggplot2, vtable, reshape2, circlize, refund)

discrete <- read_excel("Data/discrete.xls")
IDinfo <- read_excel("Data/IDinfo.xls")


#range(IDinfo$ID)
#range(IDinfo$TRIAL)
#range(IDinfo$tr_length)

#st(IDinfo)

#total_trails <- IDinfo %>% group_by(ID, KNEE) %>% summarise(TRIAL = max(TRIAL), .groups= 'keep')
#mean_tr <- IDinfo %>% group_by(ID, KNEE) %>% summarise(tr_length = mean(tr_length), .groups= 'keep')
#SUM_IDinfo <- full_join(total_trails, mean_tr)

V_GRF_stance_N <- read.csv("Data/V_GRF_stance_N.csv", header = FALSE)
AP_GRF_stance_N <- read.csv("Data/AP_GRF_stance_N.csv", header = FALSE)
ML_GRF_stance_N <- read.csv("Data/ML_GRF_stance_N.csv", header = FALSE)

#combine tables
ID_ML_GRF_sN <- bind_cols(IDinfo, ML_GRF_stance_N)
ID_AP_GRF_sN <- bind_cols(IDinfo, AP_GRF_stance_N)
ID_V_GRF_sN <- bind_cols(IDinfo, V_GRF_stance_N)

#GRAPH BY ID
ggplot(ID_ML_GRF_sN) + geom_line()

#################################

#Number of trials
nrow(IDinfo)

#Number of Left and Right
IDinfo%>%group_by(KNEE)%>%summarize(count=n())

#Number of Participants that have trials
IDinfo%>%group_by(KNEE)%>%summarize(count=n_distinct(ID))

#To get at the number of Participants that have a weird n of trials
IDinfo$ID_Knee<-paste(IDinfo$KNEE, IDinfo$ID)
test<-IDinfo%>%group_by(ID_Knee)%>%summarize(count=n())
IDinfo<-left_join(IDinfo, test, by="ID_Knee")
table(IDinfo$KNEE, IDinfo$count)

#Avg trial length per trial count
IDinfo%>%group_by(KNEE, count)%>%summarize(mean(tr_length))
#I want to make this look like table above but this is good enough for now 