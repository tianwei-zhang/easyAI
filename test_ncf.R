######### Test Deep reocommender ###########
rm(list=ls())
library(tidyverse)
library(data.table)

# Load Data
data_order_products=fread('C:/Users/Tianwei Zhang/Box Sync/2. Knowledge Development/Next product to buy/data/instacart_2017_05_01/order_products__prior.csv')
data_order=fread('C:/Users/Tianwei Zhang/Box Sync/2. Knowledge Development/Next product to buy/data/instacart_2017_05_01/orders.csv')
data_product=fread('C:/Users/Tianwei Zhang/Box Sync/2. Knowledge Development/Next product to buy/data/instacart_2017_05_01/products.csv')
#data_order_product_test=fread('C:/Users/Tianwei Zhang/Box Sync/2. Knowledge Development/Next product to buy/data/instacart_2017_05_01/order_products__train.csv')

data_transactions=data_order_products%>%
  left_join(data_order,by='order_id')%>%
  left_join(data_product,by='product_id')%>%
  select(order_id,user_id,product_id)

head(data_transactions)

data=data_transactions

output=ncf_single(data,mf_output_dim = 9,mlp_complexity = c(5),epoch = 2,lr = 0.005363087)


output2=deep_ncf(data = data,num_layer = c(1))


## Select top products and customers
top_products=data_order_products%>%
  group_by(product_id)%>%
  summarise(n=length(unique(order_id)))%>%
  mutate(rank=rank(-n,ties.method = 'first'))%>%
  mutate(rank_percent=rank/n())%>%
  arrange(rank)

top_customer=data_order%>%
  group_by(user_id)%>%
  summarise(
    n=length(unique(order_id))
  )%>%
  mutate(rank=rank(-n,ties.method='first'))%>%
  mutate(rank_percent=rank/n())%>%
  arrange(rank)



## Massage data to wide format

data_transactions=data_order_products%>%
  left_join(data_order,by='order_id')%>%
  left_join(data_product,by='product_id')%>%
  select(user_id,product_name,product_id)
data_transactions$value=1
data_transactions_top=data_transactions%>%
  filter(
    user_id %in% (top_customer%>%filter(rank<10000))$user_id &
      product_id %in% (top_products%>%filter(rank<1000))$product_id
  )%>%
  group_by(user_id,product_id,product_name)%>%
  summarise(value=sum(value))%>%
  ungroup()%>%
  select(-product_id)

data_wide=data_transactions_top%>%
  spread(product_name,value)

### Transform wide to long againm
data_ncf=data_wide
data_ncf[is.na(data_ncf)]=0
data_ncf_long=data_ncf%>%
  reshape2::melt(
    id.vars='user_id',
    variable.name='product',
    value.name='label'
  )

table(data_ncf_long$label)
data_ncf_long$label=ifelse(data_ncf_long$label>0,1,0)



######## Testing the function ###############

ncf_single(data_ncf_long$user_id,data_ncf_long$product,data_ncf_long$label,mf_output_dim = 10,mlp_complexity = c(1))
