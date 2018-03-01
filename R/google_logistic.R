#' Deep Learning Classification with Automated Parameter Tuning
#' @param x training feature matrix
#' @param y target matrix
#' @param num_layer a vector of integers indicating the number of hidden layers to test. Default to seq(1,5,1)
#' @param max_units the maximum number of hidden units in a layer. Default to an optimized value based on data
#' @param start_unit the minimum number of hiddent units in a layer. Default to 5
#' @param max_dropout A number between 0 and 1 indicating the maximum dropoff rate in a layer. Default to 0.2
#' @param min_dropout A number between 0 and 1 indicating the minimum dropoff rate in a layer. Default to 0
#' @param max_lr maximum learning rate in a run. Default to 0.2
#' @param min_lr minimum learning rate in a run. Default to 0.001
#' @param iteration_per_layer Number of parameter randomizations for a given number of hidden layers. More iterations will explore a larger parameter space
#' @param num_epoch number of epoches to go through during training
#' @param num_patience number of patience in early stopping criteria
#' @return returns a list object with two values:
#' train_performance: A table with parameters and model performance metrics
#' best_model: a keras_model object with the optimal parameters
#' @export

google_logistic=function(x,
                       y,
                       # optimizer parameters
                       num_layer=seq(1,5,1),
                       max_units=NULL,
                       start_unit=5,
                       max_dropout=0.2,
                       min_dropout=0.0001,
                       max_lr=0.2,
                       min_lr=0.001,
                       iteration_per_layer=5,

                       # model parameters
                       num_epoch=5,
                       num_patience=3
){
  set.seed(0)
  if(is.null(max_units)){
    max_units=round(nrow(x)/(2*(ncol(x)+ncol(y))))
  }
  ## Create training and test set
  if(nrow(x)!=nrow(y)){
    stop('Length of input and target is not the same')
  }
  dir=getwd()
  n=nrow(x)
  train_size=round(0.8*n)
  train_index=sample(size=train_size,x=1:n)
  x_train=x[train_index,]
  x_test=x[-train_index,]

  y_train=y[train_index,]
  y_test=y[-train_index,]
  cat('Split data into train and test by 80:20\n')
  cat(nrow(x_train),'rows in training and ',nrow(x_test),'rows in test \n')
  cat('# of fetures in X:',ncol(x),'\n')
  cat('# of classes in Y:',ncol(y),'\n')
  cat('Saving data to ',dir, '\n')
  write.csv(x_train,'x_train.csv',row.names=F)
  write.csv(y_train,'y_train.csv',row.names=F)
  write.csv(x_test,'x_test.csv',row.names=F)
  write.csv(y_test,'y_test.csv',row.names=F)

 for(i in 1:length(num_layer)){
   write_train(num_layer=num_layer[i],num_epoch=num_epoch,num_patience=num_patience)
   write_yml(num_layer=num_layer[i], max_units,
    start_unit,
    max_dropout,
    min_dropout,
    max_lr,
    min_lr)
 }

  train_name=paste0('train_layer_',num_layer,'.R')
  config_name=paste0('config_layer_',num_layer,'.yml')
  for(i in 1:length(num_layer)){
    cloudml_train(file = train_name[i],config =config_name[i])
  }


}