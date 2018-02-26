#' NCF Utility Function: Subset negative cases in a dataset
#' @param data a data frame with positive and negative label, must have a column named label
#' @param negative_ratio ratio of desired number of negative cases vs positive cases
#' @return returns a dataset with the desired negative-to-positive ratio
#' @export


ncf_get_training_data=function(data,negative_ratio){
  
  if(length(unique(data$label))!=2 |
     length(which(unique(data$label)==1))==0 |
     length(which(unique(data$label)==0))==0){
    stop('Target variable needs to be a 0-1 binary variable')
  }else{
    data_positive=data%>%filter(label==1)
    data_negative=data%>%filter(label==0)
    num_negative=min(round(nrow(data_positive)*negative_ratio),nrow(data_negative))
    data_negative_sample=data_negative[sample(1:nrow(data_negative),num_negative),]
    data_training=rbind(
      data_positive,
      data_negative
    )
    #cat(paste0('Training data includes ',nrow(data_positive),' positive cases and ',nrow(data_negative),' negative cases. \n'))
    return(data_training)
    
  }
  
}
