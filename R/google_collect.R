#' Collect model output from Google Cloud
#' @param model_id a string output from the previous function indicating the model_id
#' @param project_name a stinrg indicating the name of your google ML project. It is the name when you created the project in Google Cloud console
#' @param model_name an user input indicating the name of the current model. Can be anything
#' @param version version ID for the model_name
#' @export

google_collect=function(model_id,project_name,model_name,version){
  model_id='cloudml_2018_03_01_194237031'
  project_name='easyai-196519'
  
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