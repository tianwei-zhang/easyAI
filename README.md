# easyAI
easyAI aims to help data scientists apply Deep Learning models to traditional machine learning problems (e.g. non image/speech, tabular data). The primary benefits are:
* Easy to use. Some neural network model attributes are pre-configured to the best knowledge of the author to tackle the specific use case
* Automated neural network structure and parameter tuning. The learning functions will test various model configurations and select the best model based on performance

# Installation
```
devtools::install_github('tianwei-zhang/easyAI')
```
Auth_token can be generated from your enterprise GitHub setting menu. Click on your avatar/picture, and then setting. Go to Personal access tokens and generate new token.

# Usage

## Classification
```
library(easyAI)
output=deep_logistic(x_train,y_train,option='local')
```

## Regression

```
output=deep_lm(x_train,y_train,option='local')
```
### Hyper-parameter tuning with Google cloud
```
output=deep_lm(x_train,y_train,option='google')
google_collect(model_id='your_model_id',project_name='project_name')
```


## Recommender Systems

### Neural Collaborative Filtering
```
output=deep_ncf(data = data,max_units = 16,start_unit = 2)
```

### Collaborative Deep learning
TBD

# Details
## Why do I make this package?
When I started learning deep learning, I encountered three challenges:
* A lot of jargons in the field. Even to get started, beginners are hit with terms like learning rate, optimizer, dense network, and etc. It feels overwhelming
* Need to learn a different syntax to code models in R. Although it is much easier now with keras than tensorflow to build deep learning models in R, it is still quite different than what data scientists are used to (e.g. rpart(data), glm(data))
* Not sure if my model structure makes sense. With keras or tensorflow, you can construct the model anyway you want. However, is the model structure optimal to solve the problem? An experienced deep learning data scientist can rely on their expertise and experience to choose the right type of network and estimate the appropriate structure. For new comers, it is a challenging task

So how does the easyAI package alleviate these challenges?
1. The easiest form of the learning functions is extremely simple. In its minimalistic form, the user only needs to provide a feature matrix and target columns to build deep learning models. Users can also tweak the default setup through additional parameters in the learning function.
2. Model structure (e.g. number of layers, learning rate) is optimized to achieve the best performance. Users can choose either local or google cloud to tune the hyer-parameters such as learning rate and number of units in hidden layers. Users can be more confident about the final model and its performance (in case of comparison)

## Technical Explanation
### Overview



# Details
TBD
