#' Get data from a resource.
#' 
#' @description Get data from a resource in tabular format.
#' 
#' @param resource A resource id identifying the data set to be returned.
#' @param data_items Names of data items to be included in the returned table.
#' @param limit Specify the maximum number of records to be returned, default NULL
#'  value returns all records.
#' @param default_ord When selecting columns with the `data_items` arg, `FALSE`
#'  returns the columns in the order specified.
#'  
#' @return A data.frame containing the selected columns from the specified data
#'  set.
#'  
#' @examples
#' \dontrun{
#' get_data(
#'   resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
#'   data_items = c("Dose", "CumulativeNumberVaccinated"),
#'   limit = 10
#'   )
#' }
#' 
#' @export
get_data <- function(resource, data_items = NULL, limit = NULL, default_ord = FALSE) {
  
  if (!is.null(data_items)) {
    parse_data_items <- paste0("\"", data_items, "\"", collapse = ",")
  } else {
    parse_data_items <- "*"
  }
  
  stopifnot(length(resource) == 1)
  
  res <- jsonlite::fromJSON(
    utils::URLencode(
      glue::glue(
        "https://www.opendata.nhs.scot/api/3/action/",
        "datastore_search_sql?",
        "sql=",
        "SELECT {parse_data_items} FROM ",
        "\"",
        "{resource}",
        "\"",
        "{if (is.null(limit)) \"\" else paste0(\" LIMIT \", limit)}"
      )))
  
  stopifnot(as.logical(res$success))
  
  if (!default_ord) res$result$records <- res$result$records[data_items]
  
  return(res$result$records)
}
