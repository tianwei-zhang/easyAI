#' Deep Learning Classification with Automated Parameter Tuning
#' @param option either local or google for hyper-parameter tuning
#' @param x training feature matrix
#' @param y target matrix
#' @param num_layer a vector of integers indicating the number of hidden layers to test. Default to seq(1,3,1)
#' @param max_units the maximum number of hidden units in a layer. Default to an optimized value based on data
#' @param start_unit the minimum number of hiddent units in a layer. Default to 5
#' @param max_dropout A number between 0 and 1 indicating the maximum dropoff rate in a layer. Default to 0.2
#' @param min_dropout A number between 0 and 1 indicating the minimum dropoff rate in a layer. Default to 0
#' @param max_lr maximum learning rate in a run. Default to 0.2
#' @param min_lr minimum learning rate in a run. Default to 0.001
#' @param validation_split Percent of data used for validation. Default to 20 percent
#' @param iteration_per_layer Number of parameter randomizations for a given number of hidden layers. More iterations will explore a larger parameter space
#' @param num_epoch number of epoches to go through during training. Default to 10
#' @param num_patience number of patience in early stopping criteria. Default to 3
#' @return returns a list object with two values: 
#' \itemize{
#'   \item{train_performance: A table with parameters and model performance metrics}
#'   \item{best_model: a keras_model object with the optimal structure}
#' }
#' @export

deep_logistic=function(
                       x,
                       y,
                       option,
                       # optimizer parameters
                       num_layer=seq(1,3,1),
                       max_units=NULL,
                       start_unit=5,
                       max_dropout=0.2,
                       min_dropout=0,
                       max_lr=0.2,
                       min_lr=0.001,
                       iteration_per_layer=10,
                       validation_split=0.2,
                       
                       # model parameters
                       num_epoch=10,
                       num_patience=3)
{
  if(option!='local' & option!='google'){
    stop('option must be either local or google \n')
  }
  ########## Local option ############
  if(option=='local'){
    deep_logistic_local(x=x,
                        y=y,
                        # optimizer parameters
                        num_layer=num_layer,
                        max_units=max_units,
                        start_unit=start_unit,
                        max_dropout=max_dropout,
                        min_dropout=min_dropout,
                        max_lr=max_lr,
                        min_lr=min_lr,
                        iteration_per_layer=iteration_per_layer,
                        validation_split=validation_split,
                        
                        # model parameters
                        num_epoch=num_epoch,
                        num_patience=num_patience)
    ##### Google cloud option #####
  }else if(option=='google'){
    google_logistic(x=x,
                             y=y,
                             # optimizer parameters
                             num_layer=num_layer,
                             max_units=max_units,
                             start_unit=start_unit,
                             max_dropout=max_dropout,
                             min_dropout=min_dropout,
                             max_lr=max_lr,
                             min_lr=min_lr,
                             # model parameters
                             validation_split = validation_split,
                             num_epoch=num_epoch,
                             num_patience=num_patience)
    
  }
}
