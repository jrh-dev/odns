#' Get a table of available fields and their field_metadata for a given
#'  resource.
#'
#' @param resource a valid resource id.
#'
#' @return a table containing the names and types of all data items available
#'  for the chosen resource.
#'
#' @examples
#' \dontrun{
#' resource_metadata(resource="8f7b64b1-eb53-43e9-b888-45af0bc25505")
#' }
#'
#' @export
resource_metadata <- function(resource) {

  res <- jsonlite::fromJSON(
  utils::URLencode(
    glue::glue(
      "https://www.opendata.nhs.scot/api/3/action/",
      "datastore_search?id={resource}&limit=0"
    )))

  stopifnot(as.logical(res$success))

  return(res$result$fields)
}
