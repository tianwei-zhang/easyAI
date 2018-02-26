#' Deep Learning Regression with Automated Parameter Tuning
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
#' \itemize{
#'   \item{train_performance: A table with parameters and model performance metrics}
#'   \item{best_model: a keras_model object with the optimal structure}
#' }
#' @export

deep_lm=function(x,
                 y,
                 # optimizer parameters
                 num_layer=seq(1,5,1),
                 max_units=NULL,
                 start_unit=5,
                 max_dropout=0.2,
                 min_dropout=0,
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
      model=dl_regression_single(x,y,complexity = complexity,dropout = dropout,lr=lr,num_epoch = num_epoch, num_patience = num_patience)
      
      output=rbind(output,
                   tibble(
                     num_layer=i,
                     iteration=j,
                     complexity=list(complexity),
                     dropout=list(dropout),
                     lr=lr,
                     loss=round(min(model$loss),5),
                     accuracy=round(min(model$mean_squared_error),5)
                   )
      )
      
    }
  }
  
  # Find the best model
  best_model_param=output[which(output$accuracy==min(output$accuracy)),]
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
  best_model=dl_regression_single(x,y,
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
