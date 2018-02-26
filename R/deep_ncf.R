#' Deep Learning Recommendation: Neural Collaborative Filtering
#' @param data Transaction dataset. Format must be order_id (could be dummy), user_id, and product_id
#' @param num_layer a vector of integers indicating the number of hidden layers to test. Default to seq(1,5,1)
#' @param max_units the maximum number of hidden units in a layer. Default to 10
#' @param start_unit the minimum number of hiddent units in a layer. Default to 3
#' @param max_lr maximum learning rate in a run. Default to 0.2
#' @param min_lr minimum learning rate in a run. Default to 0.001
#' @param iteration_per_layer Number of parameter randomizations for a given number of hidden layers. More iterations will explore a larger parameter space
#' @param min_mf_output_dim Min number of latent factors to represent users and items
#' @param max_mf_output_dim Max number of latent factors to represent users and items
#' @param num_epoch number of epoches to go through during training
#' @return returns a list object with two values: 
#' train_performance: A table with parameters and model performance metrics
#' best_model: a keras_model object with the optimal parameters
#' @export

deep_ncf=function(data,
                       # optimizer parameters
                       num_layer=seq(1,5,1),
                       max_units=10,
                       start_unit=3,
                       max_lr=0.2,
                       min_lr=0.001,
                       iteration_per_layer=5,
                       min_mf_output_dim=2,
                       max_mf_output_dim=10,
                  # model parameters
                       num_epoch=2
){
  set.seed(0)

  start_unit=min(start_unit,max_units)
  
  output=NULL
  for(i in num_layer){
    for(j in 1:(i*iteration_per_layer)){
      complexity=round(runif(i,min=start_unit,max=max_units))
      lr=runif(1,min_lr,max_lr)
      mf_output_dim=round(runif(1,min_mf_output_dim,max_mf_output_dim)/2)*2
      
      cat(paste0('############  Layer ',i,'. Run ',j,'  ############\n'))
      cat('Complexity: ')
      cat(paste0(complexity,collapse = ','))
      cat('\n')
      cat('MF layer output nodes: ',mf_output_dim)
      cat('\n')
      cat('lr: ',lr)
      cat('\n')
      model=ncf_single(data,mf_output_dim,mlp_complexity,lr=lr,epoch=num_epoch)
      
      output=rbind(output,
                   tibble(
                     num_layer=i,
                     iteration=j,
                     complexity=list(complexity),
                     mf_output_dim=mf_output_dim,
                     lr=lr,
                     loss=min(min(model$loss),5)
                    
                   )
      )
      
    }
  }
  
  # Find the best model
  best_model_param=output[which(output$loss==max(output$loss)),]
  cat('###########  The best model ####### \n')
  cat(paste0('Number of layers: ',best_model_param$num_layer,'\n'))
  cat('Complexity: ')
  cat(paste0(best_model_param$complexity[[1]],collapse = ','))
  cat('\n')
  cat('MF layer output nodes: ',best_model_param$mf_output_dim)
  cat('\n')
  cat('lr: ',best_model_param$lr)
  cat('\n')
  best_model=ncf_single(data,best_model_param$mf_output_dim,best_model_param$complexity,lr=best_model_param$lr,epoch=num_epoch)
  
  return(list(train_performance=output,
              best_model=best_model
  )
  )
}
