## scripts to create test cases
library(titanic)
#devtools::install_github('tianwei-zhang/easyAI')
library(easyAI)
library(dplyr)
library(keras)
#is_keras_available()
#devtools::install_github("rstudio/cloudml")
library(cloudml)
#gcloud_install()
titanic_train=na.omit(titanic_train)

titanic_trans_train=non_numeric_col_trans(titanic_train,id.var = 'PassengerId')
titanic_trans_test=non_numeric_col_trans(titanic_test,id.var = 'PassengerId')

#head(titanic_trans_train)
titanic_trans_train=titanic_trans_train%>%select(-Name,-Ticket,-Cabin)
titanic_trans_test=titanic_trans_test%>%select(-Name,-Ticket,-Cabin)


y_train=to_categorical(titanic_trans_train$Survived,num_classes = 2)
x_train=as.matrix(titanic_trans_train%>%select(-Survived))

x_train=normalize(x_train)
rm(titanic_train,titanic_trans_test,titanic_trans_train)
