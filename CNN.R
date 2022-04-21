#CNN
source(file= "Recreating_Plots.R")
pacman::p_load(keras)

#load data and rename columns for join
cnn_vdf <- plot_V_GRF
cnn_vdf$V_GRF_stance <- as.integer(cnn_vdf$V_GRF_stance)
cnn_vdf <- rename(cnn_vdf, V.Value = value)
cnn_vdf <- rename(cnn_vdf, ID = V_GRF_stance)

cnn_mldf <- plot_ML_GRF
cnn_mldf$ML_GRF_stance <- as.integer(cnn_mldf$ML_GRF_stance)
cnn_mldf <- rename(cnn_mldf, ML.Value = value)
cnn_mldf <- rename(cnn_mldf, ID = ML_GRF_stance)

cnn_apdf <- plot_AP_GRF
cnn_apdf$AP_GRF_stance <- as.integer(cnn_apdf$AP_GRF_stance)
cnn_apdf <- rename(cnn_apdf, AP.Value = value)
cnn_apdf <- rename(cnn_apdf, ID = AP_GRF_stance)

#Join data sets
CNN_DF <- full_join(cnn_apdf, cnn_mldf)
CNN_DF <- full_join(CNN_DF, cnn_vdf)

#train test split
split1<- sample(c(rep(0, 0.7 * nrow(CNN_DF)), 
                  rep(1, 0.3 * nrow(CNN_DF))))
#head(split1)
train <- CNN_DF[split1 == 0, ]
train <- as.matrix(train)
y_train <- train[,3]
x_train <- train[,1:2]

test <- CNN_DF[split1 == 1, ]
test <- as.matrix(test)
y_test <- test[,3]
x_test <- test[,1:2]

#then define n_outputs and others

#define CNN model using Keras
#one sample is one window of the time series data
#output will be a x-element vector containing the probability of a given window
  #belonging to each of the x activity types

model <- keras_model_sequential()
model %>% 
  layer_Conv1D(filters = 64, kernel_size = 3, activation = "relu", input_shape = ncol(x_train)) %>%
  layer_Conv1D(filters = 64, kernel_size = 3, activation = "relu") %>%
  layer_dropout(0.5) %>%
  layer_MaxPooling1D(pool_size = 2) %>%
  layer_flatten() %>%
  layer_dense(units = 100, activation = "relu") %>%
  #layer_dense(units = n_outputs, activation = "softmax")
  
#view layers
summary(model)

#compile model
model %>%compile(
  loss = "categorical_crossentropy",
  optimizer = "adam",
  metrics= "accuracy"
) 

model %>% evaluate(x_train, y_train, x_test, y_test)