pacman::p_load(readxl, tidyverse, Rfssa, plotly, fda,
               cranly, ggplot2, vtable, reshape2, circlize)

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


###################Recreating Plots
## V ##
V_GRF_stance_N <- read.csv("Data/V_GRF_stance_N.csv", header = FALSE)

# Transpose data & Add time %
V_GRF_stance_N <- t(V_GRF_stance_N)
V_GRF_stance_N <- data.frame(V_GRF_stance_N)
V_GRF_stance_N$Time <- seq(1, 100, 1)

# Plotting all obs
mycolors <- rand_color(15696)
plot_V_GRF <- melt(V_GRF_stance_N,  id.vars = 'Time', variable.name = 'V_GRF_stance')
ggplot(plot_V_GRF, aes(Time, value, group = V_GRF_stance, color = V_GRF_stance)) + 
  geom_line() +
  scale_colour_manual(values = mycolors) +
  theme(legend.position = "none")



# Plotting avg per time point
avg_plot_V_GRF <- plot_V_GRF %>%
  group_by(Time) %>%
  summarise(avg_value = mean(value))
ggplot(avg_plot_V_GRF, aes(Time, avg_value)) + geom_line()

#-----------------------------------------------

## ML ##

ML_GRF_stance_N <- read.csv("Data/ML_GRF_stance_N.csv", header = FALSE)

# Transpose data & Add time %
ML_GRF_stance_N <- t(ML_GRF_stance_N)
ML_GRF_stance_N <- data.frame(ML_GRF_stance_N)
ML_GRF_stance_N$Time <- seq(1, 100, 1)

# Plotting all obs
mycolors <- rand_color(15696)
plot_ML_GRF <- melt(ML_GRF_stance_N,  id.vars = 'Time', variable.name = 'ML_GRF_stance')
ggplot(plot_ML_GRF, aes(Time, value, group = ML_GRF_stance, color = ML_GRF_stance)) + 
  geom_line() +
  scale_colour_manual(values = mycolors) +
  theme(legend.position = "none")



# Plotting avg per time point
avg_plot_ML_GRF <- plot_ML_GRF %>%
  group_by(Time) %>%
  summarise(avg_value = mean(value))
ggplot(avg_plot_ML_GRF, aes(Time, avg_value)) + geom_line()

#-----------------------------------------------

## AP ##

AP_GRF_stance_N <- read.csv("Data/AP_GRF_stance_N.csv", header = FALSE)

# Transpose data & Add time %
AP_GRF_stance_N <- t(AP_GRF_stance_N)
AP_GRF_stance_N <- data.frame(AP_GRF_stance_N)
AP_GRF_stance_N$Time <- seq(1, 100, 1)

# Plotting all obs
mycolors <- rand_color(15696)
plot_AP_GRF <- melt(AP_GRF_stance_N,  id.vars = 'Time', variable.name = 'AP_GRF_stance')
ggplot(plot_AP_GRF, aes(Time, value, group = AP_GRF_stance, color = AP_GRF_stance)) + 
  geom_line() +
  scale_colour_manual(values = mycolors) +
  theme(legend.position = "none")



# Plotting avg per time point
avg_plot_AP_GRF <- plot_AP_GRF %>%
  group_by(Time) %>%
  summarise(avg_value = mean(value))
ggplot(avg_plot_AP_GRF, aes(Time, avg_value)) + geom_line()

