library(reshape2)
library(ggplot2)
library(tidyverse)

#ML_GRF_stance_N <- read.csv("ML_GRF_stance_N.csv", header = FALSE)
#AP_GRF_tn <- read.csv("AP_GRF_stance_N.csv", header = FALSE)


V_GRF_stance_N <- read.csv("V_GRF_stance_N.csv", header = FALSE)

# Transpose data & Add time %
V_GRF_stance_N <- t(V_GRF_stance_N)
V_GRF_stance_N <- data.frame(V_GRF_stance_N)
V_GRF_stance_N$Time <- seq(1, 100, 1)

# Plotting all obs
plot_V_GRF <- melt(V_GRF_stance_N,  id.vars = 'Time', variable.name = 'V_GRF_stance')
ggplot(plot_V_GRF, aes(Time, value)) + geom_line()



# Plotting avg per time point
avg_plot_V_GRF <- plot_V_GRF %>%
                      group_by(Time) %>%
                      summarise(avg_value = mean(value))
ggplot(avg_plot_V_GRF, aes(Time, avg_value)) + geom_line()




