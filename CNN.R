#CNN

#-l gpu_memory=16G

source(file= "Recreating_Plots.R")
library(keras)
#https://keras.rstudio.com/articles/sequential_model.html
#https://machinelearningmastery.com/cnn-models-for-human-activity-recognition-time-series-classification/


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
y_train <- train[,3:5]
x_train <- train[,1:2]

test <- CNN_DF[split1 == 1, ]
test <- as.matrix(test)
y_test <- test[,3:5]
x_test <- test[,1:2]

#define time step, feature, output size
n_timesteps <- nrow(x_train)
n_features <- ncol(x_train)
n_outputs <- nrow(y_train)

#define CNN model using Keras
#had to make filter size smaller in order to run on 10 cores with 4 GPU

#filters- Integer, the dimensionality of the output space (i.e. the number of output filters in the convolution)
#kernel_size- An integer or list of a single integer, specifying the length of the 1D convolution window.

#note to self: once on new server, try running not as matricies

model <- keras_model_sequential()
model %>% 
  layer_conv_1d(filters = 6, kernel_size = 3, activation = "relu", input_shape = c(n_timesteps, n_features)) %>%
  layer_conv_1d(filters = 6, kernel_size = 3, activation = "relu") %>%
  layer_dropout(0.50) %>%
  layer_max_pooling_1d(pool_size = 2) %>%
  layer_flatten() %>%
  layer_dense(units = 100, activation = "relu") %>%
  layer_dense(units = n_outputs, activation = "softmax") %>% 
  compile(
    loss = 'categorical_crossentropy',
    optimizer = 'adam',
    metrics = c('accuracy')
  ) 

#train model, breaks here now
model %>% fit(x_train, y_train, epochs = 10, batch_size = 105)
#105 is a multiple of n_outputs which is the number of rows in training data

#evaluate model
score <- model %>% evaluate(x_test, y_test, batch_size = 105)