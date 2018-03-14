#' Neural Collaborative Filtering with a single configuration
#' @param data Transaction dataset. Format must be order_id (could be dummy), user_id, and product_id
#' @param mf_output_dim Number of latent vectors to represent users and items
#' @param mlp_complexity Number of hidden layers in the MLP layer
#' @param top Number of top products and customers to include. Can be NULL (e.g. will include everything)
#' @return returns a list object with three values:
#' model: keras model contructed. A keras_model object
#' loss: a vector containing loss value in each epoch
#' @export


ncf_single=function(data,mf_output_dim,mlp_complexity,lr,epoch,top){
  library(keras)
  #Transform transaction data
  data_tranform=ncf_data_transform(data,top=top)
  #select data
  data_select=ncf_get_training_data(data_tranform,negative_ratio = 3)

  #take out individual columns
  user_id=data_select$user_id
  product_id=data_select$product_id
  label=data_select$label

  #Input
  user_input=layer_input(shape = c(1),batch_shape=list(NULL,1),dtype='int32', name = 'user_input')
  item_input=layer_input(shape = c(1),batch_shape=list(NULL,1),dtype='int32', name = 'item_input')

  # MF Layers

  mf_user_latent=user_input
  mf_user_latent=mf_user_latent%>%
    layer_embedding(input_dim=length(user_id),
                    output_dim = mf_output_dim,
                    embeddings_initializer = 'random_normal',
                    embeddings_regularizer = regularizer_l2(0),
                    input_length = 1,
                    name='mf__user_embedding')%>%
    layer_flatten()


  mf_item_latent=item_input
  mf_item_latent=mf_item_latent%>%
    layer_embedding(input_dim=length(product_id),
                    output_dim = mf_output_dim,
                    embeddings_initializer = 'random_normal',
                    embeddings_regularizer = regularizer_l2(0),
                    input_length = 1,
                    name='mf_item_em')%>%
    layer_flatten()

  mf_vector=layer_multiply(c(mf_user_latent,mf_item_latent),name='mf_vector')

  # ML Layers
  MLP_Embedding_User=user_input%>%
    layer_embedding(input_dim=length(user_id),
                    output_dim = mf_output_dim/2,
                    embeddings_initializer = 'random_normal',
                    embeddings_regularizer = regularizer_l2(0),
                    input_length = 1,
                    name='mlp_user')%>%
    layer_flatten()

  MLP_Embedding_Item=item_input%>%
    layer_embedding(input_dim=length(product_id),
                    output_dim = mf_output_dim/2,
                    embeddings_initializer = 'random_normal',
                    embeddings_regularizer = regularizer_l2(0),
                    input_length = 1,
                    name='mlp_item')%>%
    layer_flatten()

  mlp_vector=layer_concatenate(c(MLP_Embedding_User,MLP_Embedding_Item),name='mlp_vector')


  # Use complexity vector to construct mlp structure

  for (i in 1:length(mlp_complexity)){
    mlp_vector=mlp_vector%>%
      layer_dense(units=mlp_complexity[i],kernel_regularizer = regularizer_l2(0),activation = 'relu')
  }


  predictions=layer_concatenate(c(mf_vector,mlp_vector))%>%
    layer_dense(
      units = 1,
      activation = 'sigmoid',
      kernel_initializer='lecun_uniform'
    )

  model=keras_model(c(user_input,item_input),predictions)

  model%>%
    compile(optimizer = optimizer_adam(lr=lr),loss = 'binary_crossentropy')

  model_train=model%>%
    fit(x = list(as.factor(data_select$user_id),as.factor(data_select$product_id)),y=data_select$label,epochs = epoch,verbose = 0)

  cat(paste0('Best loss is ',round(min(model_train$metrics$loss),5),'. \n'))

  return(list(
    model=model,
    loss=model_train$metrics$loss
  ))

}
