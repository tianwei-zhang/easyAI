#' Collect model output from Google Cloud
#' @param model_id a string output from the previous function indicating the model_id
#' @export

google_collect=function(model_id){

  job_collect(model_id)
  trials=job_trials(model_id)
  cat('The best parameters are:\n')
  for(i in 3:(ncol(trials)-1)){
    cat(colnames(trials)[i],': ',trials[1,i],'\n')
  }
  # model_dir=paste0('gs://',project_name,'/r-cloudml/runs/',model_id,'/savemodel/')
  # cloudml_deploy(model_dir,name=model_name,version = as.character(version))
  # cat('Your model is deployed. You can predict new data by running:\n')
  # cat('cloudml_predict(X_test,name=',model_name,',version=',version,')\n')

}
