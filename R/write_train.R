#' Write train.R file for cloudml_train
#' @param num_layer Number of hidden layer_dense
#' @param num_epoch number of epoches to go through during training
#' @param num_patience number of patience in early stopping criteria
#' @export

write_train=function(num_layer,
  # model parameters
 num_epoch,
 num_patience){
  setup_code='
  x_train=read.csv("x_train.csv")
  y_train=read.csv("y_train.csv")
  x_test=read.csv("x_test.csv")
  y_test=read.csv("y_test.csv")
  x_train=as.matrix(x_train)
  y_train=as.matrix(y_train)
  x_test=as.matrix(x_test)
  y_test=as.matrix(y_test)
  library(keras)
  '

  #Set Flag

  flag_code='
    FLAGS <- flags(\n'
  for (i in 1:num_layer){
    flag_code=paste0(flag_code,
      'flag_integer("layer',i,'", 10),
      flag_numeric("dropout',i,'",0.1),'
    )
  }
flag_code=paste0(
  flag_code,'flag_numeric("lr",0.001)
)'
)

  model_code='
  model=keras_model_sequential()
  model=model%>%
    layer_dense(batch_input_shape =list(NULL,ncol(x_train)) ,
                units = ncol(x_train),
                activation = "relu",
                kernel_initializer = "normal")
  '
  # add layers
  for(i in 1:num_layer){
    model_code=paste0(model_code,
      '%>%layer_dense(units = layer',i,',activation = "relu")\n',
      '%>%layer_dropout(rate =dropout',i,')\n')
  }
model_code=paste0(model_code,'%>%layer_dense(units=ncol(y_train),activation = "softmax")
# compile model
model%>%
  compile(
    optimizer = optimizer_adam(lr=FLAGS$lr),
    loss = "categorical_crossentropy",
    metrics = c("accuracy")
  )

  # Fit models
  early_stopping <- callback_early_stopping(monitor = "val_loss", patience = ',num_patience,')
  model%>%
    fit(
      x=x_train,
      y=y_train,
      validation_data=list(x_test,y_test),
      callbacks = c(early_stopping),epochs = ',num_epoch,'
    )

')

  output=paste0(
    setup_code,flag_code,model_code
  )
  dir=getwd()
  cat(paste0('Saving train.R to ',dir,'/train_layer_',num_layer,'.R \n'))
  write(output,file.path(paste0(dir,'/train_layer_',num_layer,'.R')))
}