#' Get selected resources or all resources within a package.
#'
#' @description Get data from one or more resources, or all resources within a 
#'  package, as a list, with each resource in tabular format. Where field
#'  selection and/or filtering of data is required the 
#'  \code{get_data} function can be used.
#'
#' @param package A character of length 1 specifying a package id or name which 
#'  identifies the package for which all resources should be returned or 
#'  containing the resource/s identified in the resource argument. Only one
#'  package may be specified.
#' @param resource Optionally, a character vector specifying resource id/s of
#'  the data set/s to be returned. Multiple resources within the same package
#'  can be specified.
#' @param limit A numeric value specifying the maximum number of rows to be
#' returned. Default value `Inf` returns all rows.
#' 
#' @return A list containing all the resources within a package, or those
#'  specified, as data.frames.
#'  
#' @examples
#' \dontrun{
#' get_resource(
#'   package = "4dd86111-7326-48c4-8763-8cc4aa190c3e",
#'   limit = 5L
#'   )
#'   
#' get_resource(
#'   package = "4dd86111-7326-48c4-8763-8cc4aa190c3e",
#'   resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
#'   limit = 5L
#'   )
#' 
#' get_resource(
#'   package = "standard-populations",
#'   resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
#'   limit = 5L
#'   )
#' }
#'  
#' @export
get_resource <- function(package, resource = NULL,  limit = Inf) {
  
  stopifnot("argument only accepts 1 package id." = length(package) == 1)
  
  stopifnot("resource contains id/s of incorrect length." = is.null(resource) || all(valid_id(resource)))
  
  urls <- package_metadata(package = package)$resources$url
  
  if (!is.null(resource)) {
    for (ii in seq_len(length(urls))) {
      
      found <- 0
      
      for (jj in seq_len(length(resource))) {
        
        if (grepl(resource[jj], urls[ii])) found <- found + 1
        
        if (found > 0) break
      }
      if (found == 0) urls[ii] <- NA
    }
    urls <- urls[!is.na(urls)]
  }
  
  out <- lapply(urls, data.table::fread, keepLeadingZeros = TRUE, 
                data.table = FALSE, nrows = limit, showProgress = FALSE)
  
  stopifnot("no datasets found using specified arguments" = length(out) > 0)
  
  return(out)
}
