### Package building
#devtools::setup(path = 'C:/Users/Tianwei Zhang/Documents/GitHub/easyAI',description = 'An R package to democratize AI',rstudio = F,check = T)
devtools::load_all(pkg='C://Users/Tianwei Zhang/Documents/GitHub/easyAI')
devtools::document(pkg='C://Users/Tianwei Zhang/Documents/GitHub/easyAI')
library(easyAI)
devtools::install_github('tianwei-zhang/easyAI')
