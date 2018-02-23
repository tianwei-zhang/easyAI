# Test scripts
rm(list=ls())
library(titanic)
library(easyAI)

titanic_train=na.omit(titanic_train)

titanic_trans_train=non_numeric_col_trans(titanic_train,id.var = 'PassengerId')
titanic_trans_test=non_numeric_col_trans(titanic_test,id.var = 'PassengerId')

head(titanic_trans_train)
titanic_trans_train=titanic_trans_train%>%select(-Name,-Ticket,-Cabin)
titanic_trans_test=titanic_trans_test%>%select(-Name,-Ticket,-Cabin)


y_train=to_categorical(titanic_trans_train$Survived,num_classes = 2)
x_train=as.matrix(titanic_trans_train%>%select(-Survived))

x_train=normalize(x_train)

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


