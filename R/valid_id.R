#' Basic check of whether the characters in a string is 36
#' 
#' @param x a string
#' 
#' @return logical value indicating whether the srting checked consists of 36
#'  characters.
valid_id <- function(x) {
  
  return(nchar(as.character(x)) == 36)
  
}
