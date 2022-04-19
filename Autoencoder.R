#Autoencoder
source(file= "Recreating_Plots.R")
pacman::p_load(keras)
#https://www.r-bloggers.com/2018/07/pca-vs-autoencoders-for-dimensionality-reduction/

#do we feed the principal components into the autoencoder?


testdf <- plot_V_GRF
testdf$V_GRF_stance <- as.integer(testdf$V_GRF_stance)

#train test split
split1<- sample(c(rep(0, 0.7 * nrow(testdf)), 
                  rep(1, 0.3 * nrow(testdf))))
head(split1)
x_train <- testdf[split1 == 0, ]
x_train <- as.matrix(x_train)

#set model
#units, activation currently chosen at random
model <- keras_model_sequential()
model %>% 
  layer_dense(units = 100, activation = "relu", input_shape = ncol(x_train)) %>%
  layer_dense(units = 50, activation = "relu", name = "bottleneck") %>%
  layer_dense(units = 100, activation = "relu") %>%
  layer_dense(units = ncol(x_train))
#view layers
summary(model)

#compile model
model %>%compile(
  loss = "mean_squared_error",
  optimizer = "adam"
)

#fit model (something here breaks)
model %>% fit(
  x = x_train, 
  y = x_train,
  epochs = 10000,
  verbose = 0
)

#evaluate the performance of the model
mse.ae2 <- evaluate(model, x_train, x_train)
mse.ae2