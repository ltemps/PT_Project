source("Recreating_Plots.R")
library(fda)
library(tidyverse)
library(plotly)

##--------------------------------V_GRF Data
fda_V_tibble <- as_tibble(plot_V_GRF)

n_points <- 100
n_curves <- 15697 #number of observations
max_time <- 100

# setting knots & plotting basis
knots = c(seq(0, max_time, 5)) #Location of knots
n_knots = length(knots) #Number of knots
n_order = 4 # order of basis functions: for cubic b-splines: order = 3 + 1
n_basis   = length(knots) + n_order - 2;
basis = create.bspline.basis(rangeval = c(0, max_time), n_basis)

plot(basis) #currently using 20 knots, could try another number of knots to see if we obtain better variance

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
fig #shows how covariance varies at different points in time


# fPCA
fun_pca_v <- pca.fd(W.obj, nharm = 2)
plot(fun_pca_v$harmonics, lwd = 3)
fun_pca_v$values #the complete set of eigenvalues
fun_pca_v$varprop #a vector giving the proportion of variance explained by each eigenfunction
sum(fun_pca_v$varprop) #explains 91% of the variance
fun_pca_v$scores[1:2,] #a matrix of scores on the principal components or harmonics, there are 15967 values, one for each curve

#VARIMAX Rotation

#VARIMAX rotation method often used to improve interpretability 
#maximizes the sum of the variance of the squared loadings, 
#where ‘loadings’ means correlations between variables and factors. 
#in simple terms, the result is a small number of important variables are highlighted,
#which makes it easier to interpret your results.

#https://personal.utdallas.edu/~herve/Abdi-rotations-pretty.pdf
# loadings are, in general, correlations between the original variables and the components extracted by the
#analysis)
#varimax searches for a rotation (i.e., a linear combination) of
#the original factors such that the variance of the loadings is maximized
varmax_v <- varmx.pca.fd(fun_pca_vgrf, nharm= 2, nx= 51)

varmax_v$rotmat
#varmax_v$coefs
varmax_v$varprop
varmax_v$values
#I think we then use these rather than the fun_pca$____ ones
sum(varmax_v$varprop)
varmax_v$scores[1:2,]

##--------------------------------ML_GRF_Data
fda_ML_tibble <- as_tibble(plot_ML_GRF)

n_points <- 100
n_curves <- 15697 #number of observations
max_time <- 100

# setting knots & plotting basis
knots = c(seq(0, max_time, 5)) #Location of knots
n_knots = length(knots) #Number of knots
n_order = 4 # order of basis functions: for cubic b-splines: order = 3 + 1
n_basis   = length(knots) + n_order - 2;
basis = create.bspline.basis(rangeval = c(0, max_time), n_basis)

plot(basis) #currently using 20 knots, could try another number of knots to see if we obtain better variance

# creating matrix for Time & value
argvals <- matrix(fda_ML_tibble$Time, nrow = n_points, ncol = n_curves)
y_mat <- matrix(fda_ML_tibble$value, nrow = n_points, ncol = n_curves)

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
fig #shows how covariance varies at different points in time


# fPCA
fun_pca_ml <- pca.fd(W.obj, nharm = 5) #First five principal components
plot(fun_pca_ml$harmonics, lwd = 3)
fun_pca_ml$values #the complete set of eigenvalues
fun_pca_ml$varprop #a vector giving the proportion of variance explained by each eigenfunction
sum(fun_pca_ml$varprop) #explains 92% of the variance
fun_pca_ml$scores[1:5,] #a matrix of scores on the principal components or harmonics, there are 15967 values, one for each curve

#VARIMAX Rotation
varmax_ml <- varmx.pca.fd(fun_pca_ml, nharm= 5, nx= 51)

varmax_ml$rotmat
#varmax_ml$coefs
varmax_ml$varprop
varmax_ml$values
sum(varmax_ml$varprop)
varmax_ml$scores[1:5,]

##------------------------------ AP_GRF_Data
fda_AP_tibble <- as_tibble(plot_AP_GRF)

n_points <- 100
n_curves <- 15697 #number of observations
max_time <- 100

# setting knots & plotting basis
knots = c(seq(0, max_time, 5)) #Location of knots
n_knots = length(knots) #Number of knots
n_order = 4 # order of basis functions: for cubic b-splines: order = 3 + 1
n_basis   = length(knots) + n_order - 2;
basis = create.bspline.basis(rangeval = c(0, max_time), n_basis)

plot(basis) #currently using 20 knots, could try another number of knots to see if we obtain better variance

# creating matrix for Time & value
argvals <- matrix(fda_AP_tibble$Time, nrow = n_points, ncol = n_curves)
y_mat <- matrix(fda_AP_tibble$value, nrow = n_points, ncol = n_curves)

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
fig #shows how covariance varies at different points in time


# fPCA
fun_pca_ap <- pca.fd(W.obj, nharm = 5) #First five principal components
plot(fun_pca_ap$harmonics, lwd = 3)
fun_pca_ap$values #the complete set of eigenvalues
fun_pca_ap$varprop #a vector giving the proportion of variance explained by each eigenfunction
sum(fun_pca_ap$varprop) #explains 93% of the variance
fun_pca_ap$scores[1:5,] #a matrix of scores on the principal components or harmonics, there are 15967 values, one for each curve

#VARIMAX Rotation
varmax_ap <- varmx.pca.fd(fun_pca_ap, nharm= 5, nx= 51)

varmax_ap$rotmat
#varmax_ap$coefs
varmax_ap$varprop
varmax_ap$values
sum(varmax_ap$varprop)
varmax_ap$scores[1:5,]
