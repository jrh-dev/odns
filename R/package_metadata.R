#' Get metadata for a package.
#' 
#' @description Get a specified packages metadata as a list.
#'  
#' @param package A character vector of length 1 specifying a package id or name
#'  which identifies the package for which metadata should be returned.
#'  
#' @return a list containing the package metadata.
#' 
#' @examples
#' \dontrun{
#' package_metadata(package = "standard-populations")
#' package_metadata(package = "edee9731-daf7-4e0d-b525-e4c1469b8f69")
#' }
#' 
#' @export
package_metadata <- function(package) {
  
  query <- utils::URLencode(glue::glue(
    "https://www.opendata.nhs.scot/api/3/action/package_show?id={package}"
  ))
  
  cap_url(query)
  
  res <- httr::GET(query)
  
  httr::stop_for_status(res)
  
  con <- httr::content(res)
  
  con <- jsonlite::fromJSON(jsonlite::toJSON(con$result))
  
  return(con)
}
