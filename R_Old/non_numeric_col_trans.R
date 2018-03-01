#' Transform Non-numeric Columns to Hot Encoding
#' @param data data frame
#' @param id.var name of the column to indicate unique row
#' @param target.var name of the target column. Default to NULL
#' @return a data frame with transformed columns
#' @export

non_numeric_col_trans=function(data,id.var,target.var=NULL){
  
  data=data[,-which(colnames(data)==id.var)]
  colclass=lapply(data,class)
  numeric_col_index=which(colclass %in% c('numeric','integer'))
  output=data[,numeric_col_index]
  non_numeric_col=data[,-numeric_col_index]
  non_numeric_cardinality=lapply(non_numeric_col,function(x) return(length(unique(x))))
  
  non_numeric_hot_encoding=model.matrix(~.+0,data=non_numeric_col[,non_numeric_cardinality<=5])
  
  output=cbind(output,non_numeric_hot_encoding,non_numeric_col[,non_numeric_cardinality>5])
  return(output)
}