#CNN Attempt with smaller subset of data
#CNN
source(file= "Recreating_Plots.R")
library(keras)
library(caTools)

#library(caret)
#https://keras.rstudio.com/articles/sequential_model.html
#https://machinelearningmastery.com/cnn-models-for-human-activity-recognition-time-series-classification/

#github key
#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

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

#decrease number of observations in CNN_DF to try and use less memory
CNN_DF <- CNN_DF[1:392400, ] #1/4 of the original data

#tm <- CNN_DF[,3:5] #used for caret creatTimeSlices (incomplete)

#train test split
set.seed(42)
#split1 <- sample.split(CNN_DF, SplitRatio= .75) #caTool split, 75% to ensure even number of observations
#folds <- createTimeSlices(y = tm, 11772, horizon = 3924, fixedWindow = FALSE, 0) #caret split for time series (incomplete)
train <- CNN_DF[1:294300,]# 75/25 split while maintaining groups
test <- CNN_DF[294301:392400 ,] # 75/25 split while maintaining groups


#train <- subset(CNN_DF, split1 == TRUE) #caTool split
rownames(train) = seq(length = nrow(train))
#train <- as.matrix(train)
y_train <- train[,3:5]
x_train <- train[,1:2]
#x_train <- train[,1] #x as just time rather than time and ID

#test <- subset(CNN_DF, split1 == FALSE) #caTool split
rownames(test) = seq(length = nrow(test))
#test <- as.matrix(test)
y_test <- test[,3:5]
x_test <- test[,1:2]


#define time step, feature, output size
n_timesteps <- nrow(x_train) %>% as.numeric()
n_features <- ncol(x_train) %>% as.numeric()
n_outputs <- nrow(y_train) %>% as.numeric()


y_train <- to_categorical(y_train) #trying to fix data dictionary error 5_2
x_train <- to_categorical(x_train) #trying to fix data dictionary error 5_2
y_test <- to_categorical(y_test) #trying to fix data dictionary error 5_2
x_test <- to_categorical(x_test) #trying to fix data dictionary error 5_2
#x_test <- test[,1] #x as just time rather than time and ID


#define CNN model using Keras
#had to make filter size smaller in order to run on 10 cores with 4 GPU

#filters- Integer, the dimensionality of the output space (i.e. the number of output filters in the convolution)
#kernel_size- An integer or list of a single integer, specifying the length of the 1D convolution window.


,