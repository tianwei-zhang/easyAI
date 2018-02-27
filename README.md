# easyAI
easyAI aims to help data scientists apply Deep Learning models to traditional machine learning problems (e.g. non image/speech). The primary benefits are:
* Easy to use. Some neural network model attributes are pre-configured to the best knowledge of the author to tackle the specific use case
* Automated neural network structure and parameter tuning. The learning functions will test various model configurations and select the best model based on performance

# Installation
```
options(unzip='internal')  
install_github("tzhang/Mck_EasyAI", host="https://git.mckinsey-solutions.com/api/v3",
               auth_token='YOUR_AUTH_TOKEN')
```
Auth_token can be generated from your enterprise GitHub setting menu. Click on your avatar/picture, and then setting. Go to Personal access tokens and generate new token.

# Usage

## Classification
```
library(easyAI)
output=deep_logistic(x_train,y_train)
```

## Regression

```
output=deep_lm(x_train,y_train)

```

## Recommender Systems

### Neural Collaborative Filtering
```
output=deep_ncf(data = data,max_units = 16,start_unit = 2)
```

### Collaborative Deep learning
TBD

# Technical Explanation
TBD
# Details
TBD
