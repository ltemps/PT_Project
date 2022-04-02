pacman::p_load(readxl, tidyverse, Rfssa, plotly, fda,
               cranly, ggplot2, vtable)


discrete <- read_excel("Data/discrete.xls")
IDinfo <- read_excel("Data/IDinfo.xls")

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