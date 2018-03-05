# Test scripts
rm(list=ls())
library(titanic)
#devtools::install_github('tianwei-zhang/easyAI')
library(easyAI)
library(dplyr)
library(keras)
#is_keras_available()
#devtools::install_github("rstudio/cloudml")
library(cloudml)
#gcloud_install()
titanic_train=na.omit(titanic_train)

titanic_trans_train=non_numeric_col_trans(titanic_train,id.var = 'PassengerId')
titanic_trans_test=non_numeric_col_trans(titanic_test,id.var = 'PassengerId')

head(titanic_trans_train)
titanic_trans_train=titanic_trans_train%>%select(-Name,-Ticket,-Cabin)
titanic_trans_test=titanic_trans_test%>%select(-Name,-Ticket,-Cabin)


y_train=to_categorical(titanic_trans_train$Survived,num_classes = 2)
x_train=as.matrix(titanic_trans_train%>%select(-Survived))

x_train=normalize(x_train)


deep_logistic(x_train,y_train,option = 'google',num_layer = c(1,2))

google_logistic(x_train,y_train,num_layer = c(1,2))
# write_yml(num_layer = c(2),max_units = 10,start_unit = 1,max_dropout = 0.1,min_dropout = 0.01,max_lr = 0.5,min_lr = 0.1)
# write_train(num_layer = c(2),num_epoch = 10,num_patience = 3)

con <- file("cloudml_output1.txt")
sink(con, append=TRUE)
sink(con, append=TRUE)
google_logistic(x_train,y_train,num_layer = c(1))


######## testing yaml ######

############ Old testing script ################
output=deep_logistic(x_train,y_train)

output=deep_lm(x_train,y_train)


##########################
model=keras_model_sequential()

model%>%
  layer_dense(batch_input_shape =list(NULL,ncol(x_train)) ,units = ncol(x_train),activation = 'relu',kernel_initializer = 'normal')%>%
  layer_dense(units = 10,activation = 'relu',kernel_initializer = 'normal')%>%
  layer_dense(units = 10,activation = 'relu',kernel_initializer = 'normal')%>%
  layer_dense(units = 2,activation = 'linear',kernel_initializer = 'normal')

model%>%
  compile(
    optimizer = optimizer_rmsprop(lr=0.01),
    loss = 'categorical_crossentropy',
    metrics = c('mse')
  )

early_stopping <- callback_early_stopping(monitor = 'val_loss', patience = 2)

summary(model)

model%>%
  fit(x = x_train,y=y_train,callbacks = c(early_stopping),epochs = 5)
