#' NCF Utility Function: Transform transaction data to a data with 0-1 labels
#' @param data Transaction dataset. Format must be order_id (could be dummy), user_id, and product_id
#' @param top Number of top products and customers to include. Can be NULL (e.g. will include everything)
#' @return returns a dataset with user_id, product_id, label (0,1 indicating if past purchase exists)
#' @export

ncf_data_transform=function(data,top=1000){
  #cat('Parsing data columns as order_id,user_id, product_id \n')
  colnames(data)=c('order_id','user_id','product_id')
  if (!is.null(top)){
    top_products=data%>%
      group_by(product_id)%>%
      summarise(n=length(unique(order_id)))%>%
      mutate(rank=rank(-n,ties.method = 'first'))%>%
      mutate(rank_percent=rank/n())%>%
      arrange(rank)
    
    top_customer=data%>%
      group_by(user_id)%>%
      summarise(
        n=length(unique(order_id))
      )%>%
      mutate(rank=rank(-n,ties.method='first'))%>%
      mutate(rank_percent=rank/n())%>%
      arrange(rank)
    
    data$value=1
    
    data_top=data%>%
      filter(
        user_id %in% (top_customer%>%filter(rank<top))$user_id &
          product_id %in% (top_products%>%filter(rank<top))$product_id
      )%>%
      group_by(user_id,product_id)%>%
      summarise(value=sum(value))%>%
      ungroup()
  }else{
    data_top=data%>%select(user_id,product_id)
    data_top$value=1
  }
  
  data_wide=data_top%>%
    spread(product_id,value)
  
  ### Transform wide to long againm
  data_wide[is.na(data_wide)]=0
  data_long=data_wide%>%
    reshape2::melt(
      id.vars='user_id',
      variable.name='product_id',
      value.name='label'
    )
  
  data_long$label=ifelse(data_long$label>0,1,0)
  
  return(data_long)
}