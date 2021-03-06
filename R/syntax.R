# syntax definitions


# special operator to create a data node in the parent environment,
# and assign it a likelihood

#' @name greta-likelihood
#' @title create an observed, stochastic node
#' @description The likelihood operator is used to link observed data with
#'   random variables. This can be used to define the likelhood term for a
#'   model.
#' @param data a data node, defined using \code{observed()}
#' @param distribution a stochastic node, created using a distribution
#' @export
#' @examples
#' # observed data
#' y = observed(rnorm(10))
#'
#' # random variable
#' theta = normal(0, 1)
#'
#' # link them (i.e. we observed theta to have the values in y)
#' y %~% theta
`%~%` <- function (data, distribution) {

  if (!inherits(data, 'data_node'))
    stop ('left hand side of likelihood must be a data node')

  if (!inherits(distribution, 'distribution'))
    stop ('left hand side of likelihood must be a data node')


  # provide the data to the likelihood and lock in the values in the
  # distribution
  distribution$value(data$value())
  distribution$.fixed_value <- TRUE

  # give the distribution to the data as a likelihood (this will register the
  # child distribution)
  data$set_likelihood(distribution)

  # register the data node, with it's own name
  data$register()

}
