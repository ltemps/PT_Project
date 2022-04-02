library(reshape2)
library(ggplot2)
library(tidyverse)
library(circlize)

## V ##
V_GRF_stance_N <- read.csv("V_GRF_stance_N.csv", header = FALSE)

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

ML_GRF_stance_N <- read.csv("ML_GRF_stance_N.csv", header = FALSE)

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

AP_GRF_stance_N <- read.csv("AP_GRF_stance_N.csv", header = FALSE)

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
