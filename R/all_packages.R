#' Lists 'packages' available from opendata.nhs.scot.
#' 
#' @description Lists all 'packages' available from opendata.nhs.scot as a
#'  character vector, with the option to limit results based on a regular
#'  expression.
#'  
#' @param contains a character string containing a regular expression to be 
#'  matched against a vector of available package names. If a character vector >
#'  length 1 is supplied, the first element is used.
#' 
#' @return a character vector containing the names of all available packages,
#'  or those containing the string specified in the \code{contains} argument.
#'  
#' @examples
#' \dontrun{
#' all_packages()
#' all_packages(contains = "standard-populations")
#' }
#' 
#' @export
all_packages <- function(contains = NULL) {
  
  res <- httr::GET("https://www.opendata.nhs.scot/api/3/action/package_list")
  
  httr::stop_for_status(res)
  
  pac <- unlist(httr::content(res)$result)
  
  if (!is.null(contains)) {
    pac <- pac[grepl(as.character(contains), pac, ignore.case = TRUE)]
  }
  
  return(pac)
}
