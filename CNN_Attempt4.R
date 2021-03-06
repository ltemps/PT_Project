#CNN with just one output column

source(file= "Recreating_Plots.R")
library(keras)
library(caTools)

#library(caret)
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

#tm <- CNN_DF[,3:5] #used for caret creatTimeSlices (incomplete)

#train test split
set.seed(42)
#split1 <- sample.split(CNN_DF, SplitRatio= .75) #caTool split, 75% to ensure even number of observations
#folds <- createTimeSlices(y = tm, 11772, horizon = 3924, fixedWindow = FALSE, 0) #caret split for time series (incomplete)
train <- CNN_DF[1:1177200,]# 75/25 split while maintaining groups
test <- CNN_DF[1177201:1569600,] # 75/25 split while maintaining groups


#train <- subset(CNN_DF, split1 == TRUE) #caTool split
rownames(train) = seq(length = nrow(train))
#train <- as.matrix(train)
y_train <- train[,3] #just one output
x_train <- train[,1:2]

#test <- subset(CNN_DF, split1 == FALSE) #caTool split
rownames(test) = seq(length = nrow(test))
#test <- as.matrix(test)
y_test <- test[,3] #just one output
x_test <- test[,1:2]

#define time step, feature, output size
n_timesteps <- nrow(x_train)
n_features <- ncol(x_train)
n_outputs <- length(y_train)

#define CNN model using Keras
#had to make filter size smaller in order to run on 10 cores with 4 GPU

#filters- Integer, the dimensionality of the output space (i.e. the number of output filters in the convolution)
#kernel_size- An integer or list of a single integer, specifying the length of the 1D convolution window.


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
#model %>% fit(x_train, y_train, epochs = 10, batch_size = 105)
#105 is a multiple of n_outputs which is the number of rows in training data
model %>% fit(x_train, y_train, epochs = 10, batch_size = 108) #use for caTools split and manual split

#evaluate model
#score <- model %>% evaluate(x_test, y_test, batch_size = 105)
score <- model %>% evaluate(x_test, y_test, batch_size = 109) #use for caTools split and manual split