#' Lists 'packages' available from opendata.nhs.scot
#' 
#' @description Lists all 'packages' available from opendata.nhs.scot. With the
#'  option to limit results based on a regular expression.
#'  
#' @param contains character string treated as a regular expression to be 
#'  matched against the package names returned.
#' 
#' @return a character vector containing the names of all available packages,
#'  or those containing the string specified in the contains argument.
#'  
#' @examples
#' \dontrun{
#' all_packages()
#' all_packages(contains = "population")
#' }
#' 
#' @export
all_packages <- function(contains = NULL) {
  
  if (length(contains) > 1) stop ("length of contains argument > 1.")
  
  res <- jsonlite::fromJSON("https://www.opendata.nhs.scot/api/3/action/package_list")
  
  stopifnot(as.logical(res$success))
  
  pac <- res$result
  
  if (!is.null(contains)) {
    pac <- pac[grepl(as.character(contains), pac, ignore.case = TRUE)]
  }
  
  return(pac)
}
