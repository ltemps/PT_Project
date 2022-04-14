source("Recreating_Plots.R")
library(fda)
library(tidyverse)
library(plotly)

fda_V_tibble <- as_tibble(plot_V_GRF)

n_points <- 100
n_curves <- 15697
max_time <- 100

# setting knots & plotting basis
knots = c(seq(0, max_time, 5)) #Location of knots
n_knots = length(knots) #Number of knots
n_order = 4 # order of basis functions: for cubic b-splines: order = 3 + 1
n_basis   = length(knots) + n_order - 2;
basis = create.bspline.basis(rangeval = c(0, max_time), n_basis)

plot(basis)
# creating matrix for Time & value
argvals <- matrix(fda_V_tibble$Time, nrow = n_points, ncol = n_curves)
y_mat <- matrix(fda_V_tibble$value, nrow = n_points, ncol = n_curves)

# creating object
W.obj <- Data2fd(argvals = argvals, y = y_mat, basisobj = basis, lambda = 0.5)

# finding mean & sd
W_mean <- mean.fd(W.obj)
W_sd <- std.fd(W.obj)

# finding upper and lower SE
SE_u <- fd(basisobj = basis)
SE_l <- fd(basisobj = basis)

# inputting SE's
SE_u$coefs <- W_mean$coefs +  1.96 * W_sd$coefs/sqrt(n_curves) 
SE_l$coefs <- W_mean$coefs -  1.96 * W_sd$coefs/sqrt(n_curves)

# plot 1
plot(W.obj, xlab="Time", ylab="", lty = 1)

title(main = "Smoothed Curves")
lines(SE_u, lwd = 3, lty = 3)
lines(SE_l, lwd = 3, lty = 3)
lines(W_mean,  lwd = 3)

# plot 2
days <- seq(0,100, by=2)
cov_W <- var.fd(W.obj)
var_mat <-  eval.bifd(days,days,cov_W)

fig <- plot_ly(x = days, y = days, z = ~var_mat) %>% 
  add_surface(contours = list(
    z = list(show=TRUE,usecolormap=TRUE, highlightcolor="#ff0000", project=list(z=TRUE))))
fig <- fig %>% 
  layout(scene = list(camera=list(eye = list(x=1.87, y=0.88, z=-0.64))))
fig

# fPCA
fun_pca <- pca.fd(W.obj, nharm = 5)
plot(fun_pca$harmonics, lwd = 3)
fun_pca$values #the complete set of eigenvalues
fun_pca$varprop #a vector giving the proportion of variance explained by each eigenfunction
#fun_pca$scores #a matrix of scores on the principal components, there are 15967 values, one for each curve

