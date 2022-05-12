library(keras)
library(tensorflow)
library(plotly)
library(factoextra)
install_keras()

V_GRF_stance_N <- read.csv("Data/V_GRF_stance_N.csv", header = FALSE)

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
  layer_dense(units = 49, activation = "tanh", input_shape = ncol(x_train)) %>%
  layer_dense(units = 7, activation = "tanh", name = "bottleneck") %>%
  layer_dense(units = 49, activation = "tanh") %>%
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
  verbose = 0
)

mse.ae2 <- evaluate(model, x_train, x_train)
mse.ae2

intermediate_layer_model <- keras_model(inputs = model$input, outputs = get_layer(model, "bottleneck")$output)
intermediate_output <- predict(intermediate_layer_model, x_train)

aedf3 <- data.frame(node1 = intermediate_output[,1], node2 = intermediate_output[,2], node3 = intermediate_output[,3])
ae_plotly <- plot_ly(aedf3, x = ~node1, y = ~node2, z = ~node3) %>% add_markers()
ae_plotly



## PCA COMP

pca <- prcomp(x_train)

fviz_screeplot(pca)


pca.recon <- function(pca, x, k) {
  mu <- matrix(rep(pca$center, nrow(pca$x)), nrow = nrow(pca$x), byrow = TRUE)
  recon <- pca$x[, 1:k] %*% t(pca$rotation[,1:k]) + mu
  mse <- mean((recon - x)^2)
  return(list(x = recon, mse = mse))
}
xhat <- rep(NA, 7)
for (k in 1:7) {
  xhat[k] <- pca.recon(pca, x_train, k)$mse
}

ae.mse <- rep(NA, 7)
for(k in 1:7){
  modelk <- keras_model_sequential()
  modelk %>% 
    layer_dense(units = 49, activation = "tanh", input_shape = ncol(x_train)) %>%
    layer_dense(units = k, activation = "tanh", name = "bottleneck") %>%
    layer_dense(units = 49, activation = "tanh") %>%
    layer_dense(units = ncol(x_train))
  modelk %>%compile(
    loss = "mean_squared_error",
    optimizer = "adam"
  )
  modelk %>% fit(
    x = x_train, 
    y = x_train,
    epochs = 100,
    verbose = 0
  )
  ae.mse[k] <- unname(evaluate(model, x_train, x_train))
}
df <- data.frame(k = c(1:7), mse = c(xhat), method = c(rep("pca", 7)))
ggplot(df, aes(x = k, y = mse, col = method)) +
  geom_line()





