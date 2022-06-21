#' Get a table of data items and their types for a given resource.
#' 
#' @param resource a valid resource id.
#' 
#' @return a table containing the names and types of all data items available
#'  for the chosen resource.
#'  
#' @examples
#' \dontrun{
#' data_items(resource="8f7b64b1-eb53-43e9-b888-45af0bc25505")
#' }
#' 
#' @export
data_items <- function(resource) {
  
  res <- jsonlite::fromJSON(
  utils::URLencode(
    glue::glue(
      "https://www.opendata.nhs.scot/api/3/action/",
      "datastore_search_sql?",
      "sql=",
      "SELECT * FROM ",
      "\"",
      "{resource}",
      "\"",
      " LIMIT 0"
    )))
  
  stopifnot(as.logical(res$success))
  
  return(res$result$fields)
}
