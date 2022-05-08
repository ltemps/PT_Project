library(keras)
library(tensorflow)
install_keras()


testdf <- V_GRF_stance_N
testdf <- sapply(testdf, function(x) (x - min(x, na.rm = T)) / (max(x, na.rm = T) - min(x, na.rm=T)))
summary(testdf)


split1<- sample(c(rep(0, 0.7 * nrow(testdf)), 
                  rep(1, 0.3 * nrow(testdf))))
head(split1)
x_train <- testdf[split1 == 0, ]
x_train <- as.matrix(x_train)

ncol(x_train)

model <- keras_model_sequential()
model %>% 
  layer_dense(units = 81, activation = "tanh", input_shape = ncol(x_train)) %>%
  layer_dense(units = 9, activation = "tanh", name = "bottleneck") %>%
  layer_dense(units = 81, activation = "tanh") %>%
  layer_dense(units = ncol(x_train))

summary(model)

model %>%compile(
  loss = "mean_squared_error",
  optimizer = "adam"
)

model %>% fit(
  x = x_train, 
  y = x_train,
  epochs = 50,
  verbose = 0,
  batch_size = 5
)

mse.ae2 <- evaluate(model, x_train, x_train)
mse.ae2
