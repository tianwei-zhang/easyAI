#' Deep Learning Classification with Known Network Structure
#' @param x training feature matrix
#' @param y target matrix
#' @param complexity a vector indicating numbers of hidden units in each layer, e.g. c(3,6,7) means 3 layers with 3, 6, 7 units in each layer
#' @param dropout a vector indicating the dropout rate in each layer, e.g c(0.1,0.2,0.3)
#' @param lr learning rate for the optimizer
#' @param num_epoch number of epoches to go through during training
#' @param num_patience number of patience in early stopping criteria
#' @param validation_split % of data used for validation
#' @return returns a list object with three values:
#' model: keras model contructed. A keras_model object
#' loss: a vector containing loss value in each epoch
#' accuracy: a vector containing accuracy value in each epoch
#' @export

dl_classification_single=function(x,y,complexity,dropout,lr,num_epoch,num_patience,validation_split){
  library(keras)
  model=keras_model_sequential()
  model=model%>%
    layer_dense(batch_input_shape =list(NULL,ncol(x)) ,
                units = ncol(x),
                activation = 'relu',
                kernel_initializer = 'normal')

  num_layer=length(complexity)
  for(i in 1:num_layer){
    model=model%>%
      layer_dense(units = complexity[i],activation = 'relu')%>%
      layer_dropout(rate =dropout[i] )
  }

  model=model%>%
    layer_dense(units=ncol(y),activation = 'softmax')

  model%>%
    compile(
      optimizer = optimizer_adam(lr=lr),
      loss = 'categorical_crossentropy',
      metrics = c('accuracy')
    )

  early_stopping <- callback_early_stopping(monitor = 'val_loss', patience = num_patience)

  model_train=model%>%
    fit(x = x,y=y,callbacks = c(early_stopping),epochs = num_epoch,verbose = 0,validation_split = validation_split)

  output_metric=model_train$metrics
  cat(paste0('Best validation loss is ',round(min(output_metric$val_loss),5),'. '))
  cat(paste0('Best validation accuracy is ',round(max(output_metric$val_acc),5),'\n'))
  return(list(model=model,
              loss=output_metric$val_loss,
              accuracy=output_metric$val_acc
  ))
}
