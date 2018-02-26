######### Test Deep reocommender ###########
rm(list=ls())
library(tidyverse)
library(data.table)
devtools::install_github('tianwei-zhang/easyAI')
library(easyAI)

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


output2=deep_ncf(data = data,num_layer = c(1,2),max_units = 16,start_unit = 2,num_epoch = 1,top = 10)

summary(output2$best_model$model)
output2$train_performance        
