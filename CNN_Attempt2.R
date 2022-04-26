library(caret)
library(keras)

library(reticulate)
virtualenv_create("myenv")
use_virtualenv("myenv")
install_keras(method="virtualenv", envname="myenv")
use_virtualenv("myenv")

set.seed(22)

str(CNN_DF)
dim(CNN_DF)

split1<- sample(c(rep(0, 0.7 * nrow(CNN_DF)), 
                  rep(1, 0.3 * nrow(CNN_DF))))
train <- CNN_DF[split1 == 0, ]
test <- CNN_DF[split1 == 1, ]

y_train <- train[,3]
x_train <- train[,1:2]

y_train <- as.matrix(y_train)
x_train <- as.matrix(x_train)

y_test <- test[,3]
x_test <- test[,1:2]

y_test <- as.matrix(y_test)
x_test <- as.matrix(x_test)

dim(x_train)
dim(y_train)

x_train <- array(x_train, dim = c(nrow(x_train), 2, 1))
x_test <- array(x_test, dim = c(nrow(x_test), 2, 1))
## y_train <- to_categorical(y_train)

dim(x_train)
dim(y_train)

model <- keras_model_sequential()
model %>% 
  layer_conv_1d(filters = 6, kernel_size = 1, activation = "relu", input_shape = c(2, 1)) %>%
  layer_conv_1d(filters = 6, kernel_size = 1, activation = "relu") %>%
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

model
