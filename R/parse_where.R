#' Attempt to parse the 'WHERE' element of a simple SQL SELECT style query to a
#'  format compatible with the CKAN API.
#'  
#' @param x a string containing the 'WHERE' element of a SQL SELECT query.
#' @param fields character vector of fields confirmed to be present in the
#'  target resource. Typically obtained with `field_metadata()`.
#'  
#' @return a string.
parse_where <- function(x, fields) {
  
  x <- scan(text = x, what = "character", allowEscapes = TRUE, quiet = TRUE)
  
  x[grepl(" ", x)] <- paste0("\'", x[grepl(" ", x)], "\'")
  
  if (!is.null(fields)) x[x %in% fields] <- paste0("\"", x[x %in% fields], "\"")
  
  x <- paste0(x, collapse = "")
  
  return(x)
}

