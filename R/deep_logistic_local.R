#' Deep Learning Classification with Automated Parameter Tuning by Random Search
#' @param x training feature matrix
#' @param y target matrix
#' @param num_layer a vector of integers indicating the number of hidden layers to test. Default to seq(1,5,1)
#' @param max_units the maximum number of hidden units in a layer. Default to an optimized value based on data
#' @param start_unit the minimum number of hiddent units in a layer. Default to 5
#' @param max_dropout A number between 0 and 1 indicating the maximum dropoff rate in a layer. Default to 0.2
#' @param min_dropout A number between 0 and 1 indicating the minimum dropoff rate in a layer. Default to 0
#' @param max_lr maximum learning rate in a run. Default to 0.2
#' @param min_lr minimum learning rate in a run. Default to 0.001
#' @param validation_split % of data used for validation
#' @param iteration_per_layer Number of parameter randomizations for a given number of hidden layers. More iterations will explore a larger parameter space
#' @param num_epoch number of epoches to go through during training
#' @param num_patience number of patience in early stopping criteria
#' @return returns a list object with two values: 
#' train_performance: A table with parameters and model performance metrics
#' best_model: a keras_model object with the optimal parameters
#' @export

deep_logistic_local=function(x,
                       y,
                       # optimizer parameters
                       num_layer,
                       max_units,
                       start_unit,
                       max_dropout,
                       min_dropout,
                       max_lr,
                       min_lr,
                       iteration_per_layer,
                       validation_split,
                       
                       # model parameters
                       num_epoch,
                       num_patience
){
  set.seed(0)
  
  if(min_dropout<=0){
    stop('Dropout bounds must be positive \n')
  }
  if(max_dropout<min_dropout){
    stop('Max dropout rate is set to be smaller than min dropout rate \n')
  }
  if(max_lr<min_lr){
    stop('Max learning rate is set to be smaller than min learning rate \n')
  }
  if(nrow(x)!=nrow(y)){
    stop('Length of input and target is not the same')
  }
  
  if(is.null(max_units)){
    max_units=round(nrow(x)/(2*(ncol(x)+ncol(y))))
  }
  start_unit=min(start_unit,max_units)
  
  output=NULL
  for(i in num_layer){
    for(j in 1:(i*iteration_per_layer)){
      complexity=round(runif(i,min=start_unit,max=max_units))
      dropout=round(runif(i,min=min_dropout,max=max_dropout),2)
      lr=runif(1,min_lr,max_lr)
      cat(paste0('############  Layer ',i,'. Run ',j,'  ############\n'))
      cat('Complexity: ')
      cat(paste0(complexity,collapse = ','))
      cat('\n')
      cat('Dropout: ')
      cat(paste0(dropout,collapse = ','))
      cat('\n')
      cat('lr: ',lr)
      cat('\n')
      model=dl_classification_single(x,y,complexity = complexity,dropout = dropout,lr=lr,num_epoch = num_epoch, num_patience = num_patience)
      
      output=rbind(output,
                   tibble(
                     num_layer=i,
                     iteration=j,
                     complexity=list(complexity),
                     dropout=list(dropout),
                     lr=lr,
                     loss=round(mean(model$loss),5),
                     accuracy=round(mean(model$accuracy),5)
                   )
      )
      
    }
  }
  
  # Find the best model
  best_model_param=output[which(output$accuracy==max(output$accuracy)),]
  cat('###########  The best model ####### \n')
  cat(paste0('Number of layers: ',best_model_param$num_layer,'\n'))
  cat('Complexity: ')
  cat(paste0(best_model_param$complexity[[1]],collapse = ','))
  cat('\n')
  cat('Dropout: ')
  cat(paste0(best_model_param$dropout[[1]],collapse = ','))
  cat('\n')
  cat('lr: ',lr)
  cat('\n')
  best_model=dl_classification_single(x,y,
                                      complexity = best_model_param$complexity[[1]],
                                      dropout = best_model_param$dropout[[1]],
                                      lr=best_model_param$lr,
                                      num_epoch = num_epoch, 
                                      num_patience = num_patience)
  
  
  return(list(train_performance=output,
              best_model=best_model
  )
  )
}
