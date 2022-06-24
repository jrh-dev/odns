#' Get a table of available fields and their types for a specified resource.
#'
#' @param resource a valid resource id.
#'
#' @return a data.frame detailing the names and types of all fields available
#'  for the chosen resource.
#'
#' @examples
#' \dontrun{
#' resource_metadata(resource="8f7b64b1-eb53-43e9-b888-45af0bc25505")
#' }
#'
#' @export
resource_metadata <- function(resource) {

  query <- utils::URLencode(
    glue::glue(
      "https://www.opendata.nhs.scot/api/3/action/",
      "datastore_search?id={resource}&limit=0"
    ))
  
  cap_url(query)
  
  res = httr::GET(query)
  
  httr::stop_for_status(res)
  
  cont = httr::content(res)
  
  cont = lapply(cont$result$fields, as.data.frame, stringsAsFactors = FALSE)
  
  cont = as.data.frame(purrr::map_dfr(cont, ~.x), stringsAsFactors = FALSE)[c("id", "type")]
  
  return(cont)
}
