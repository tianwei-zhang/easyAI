#' Collaborative Deep Learning with a single network configuration
#' @param items item matrix with numeric item attributes
#' @param rating user-item rating matrix
#' return return a user-item ratings with scores for previously unseen items for each user
#' @export

cdl_single=function(items,rating){
  items=as.matrix(items)

  model <- keras_model_sequential()
  model %>%
    layer_dense(units = 15, activation = "tanh", input_shape = ncol(x),name = 'input') %>%
    layer_dense(units = 10, activation = "tanh",,name = 'intermediate') %>%
    layer_dense(units = 15, activation = "tanh") %>%
    layer_dense(units = ncol(x),name = 'last')

  model %>% compile(
    loss = "mean_squared_error",
    optimizer = "adam"
  )

  summary(model)

  early_stopping <- callback_early_stopping(patience = 5)

  model %>%fit(x = x,
               y = x,
               epochs = 10,
               batch_size = 32,
               callbacks = list(early_stopping)
  )

  ## get latent variable representations
  intermediate_layer_model = keras_model(inputs=model$input,
                                         outputs=get_layer(model,'intermediate')$output)
  latent_vectors = predict(intermediate_layer_model, x)

  ## Compute cosine similarity matrix

  cos.sim=function(ma, mb){
    mat=tcrossprod(ma, mb)
    t1=sqrt(apply(ma, 1, crossprod))
    t2=sqrt(apply(mb, 1, crossprod))
    mat / outer(t1,t2)
  }

  similarity_matrix=cos.sim(latent_vectors,latent_vectors)


}
