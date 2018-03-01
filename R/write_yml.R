#' Write config.yml file for cloudml_train
#' @param num_layer Number of hidden layer_dense
#' @param max_units the maximum number of hidden units in a layer. Default to an optimized value based on data
#' @param start_unit the minimum number of hiddent units in a layer. Default to 5
#' @param max_dropout A number between 0 and 1 indicating the maximum dropoff rate in a layer. Default to 0.2
#' @param min_dropout A number between 0 and 1 indicating the minimum dropoff rate in a layer. Default to 0
#' @param max_lr maximum learning rate in a run. Default to 0.2
#' @param min_lr minimum learning rate in a run. Default to 0.001
#' @export

write_yml=function(num_layer,
   max_units,
   start_unit,
   max_dropout,
   min_dropout,
   max_lr,
   min_lr){
     code='trainingInput:
       scaleTier: CUSTOM
       masterType: standard_gpu
       hyperparameters:
         goal: MINIMIZE
         hyperparameterMetricTag: val_loss
         maxTrials: 20
         maxParallelTrials: 5
         params:'

      for(i in 1:num_layer){
        code=paste0(code,'
          - parameterName: layer',i,'
            type: INTEGER
            minValue: ',start_unit,'
            maxValue: ',max_units,'
            scaleType: UNIT_LINEAR_SCALE
          - parameterName: dropout',i,'
            type: DOUBLE
            minValue: ',min_dropout,'
            maxValue: ',max_dropout,'
            scaleType: UNIT_LOG_SCALE
        ')
      }

          code=paste0(code,' - parameterName: lr
           type: DOUBLE
           minValue: ',min_lr,'
           maxValue: ',max_lr,'
           scaleType: UNIT_LOG_SCALE
          ')
     dir=getwd()
     cat(paste0('Saving config.yml to ',dir,'/config_layer_',num_layer,'.yml \n'))
     write(code,file.path(paste0(dir,'/config_layer_',num_layer,'.yml')))
}
