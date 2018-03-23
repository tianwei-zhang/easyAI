#Test
rm(list=ls())
setwd('GitHub/easyAI/')
source('prepare test cases.R')

################### Deep logistic with local search ###################
library(easyAI)
library(tidyverse)
library(cloudml)
deep_lm(x_train,y_train,option = 'local')
#google cloud
deep_lm(x_train,y_train,option='google',num_layer = c(5))
google_collect(model_id = 'cloudml_2018_03_05_162912787')
               