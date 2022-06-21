#' Get a full representation of a packages metadata.
#' 
#' @description Get a full representation of a specified packages metadata
#'  as a list.
#'  
#' @param package a valid package name or package id.
#'  
#' @return a list of the package metadata.
#' 
#' @examples
#' \dontrun{
#' package_metadata(package = "gp-practice-populations")
#' package_metadata(package = "e3300e98-cdd2-4f4e-a24e-06ee14fcc66c")
#' }
#' 
#' @export
package_metadata <- function(package) {
  
  res <- jsonlite::fromJSON(glue::glue(
    "https://www.opendata.nhs.scot/api/3/action/package_show?id=",
    "{utils::URLencode(package)}"
    ))
  
  stopifnot(as.logical(res$success))
  
  return(res$result)
  
}
