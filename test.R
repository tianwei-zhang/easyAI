# Test scripts
rm(list=ls())
source('prepare test cases.R')

deep_lm(x_train,y_train,option = 'google',num_layer = c(1))

google_logistic(x_train,y_train,num_layer = c(1,2))
# write_yml(num_layer = c(2),max_units = 10,start_unit = 1,max_dropout = 0.1,min_dropout = 0.01,max_lr = 0.5,min_lr = 0.1)
# write_train(num_layer = c(2),num_epoch = 10,num_patience = 3)

con <- file("cloudml_output1.txt")
sink(con, append=TRUE)
sink(con, append=TRUE)
google_logistic(x_train,y_train,num_layer = c(1))


### test collect
google_collect(model_id = 'cloudml_2018_03_05_162912787',project_name = 'easyai-196519',model_name = 'test',version = 1)

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
