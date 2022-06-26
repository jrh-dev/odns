#' Get data from a resource.
#'
#' @description Get data from a resource in tabular format with the option to
#'  select fields and perform basic filtering. Where multiple data sets are
#'  required from a package and/or no field selection and filtering is required
#'  the \code{get_resource} function can be used.
#'
#' @param resource A character string containing the resource id of the data set
#'  to be returned.
#' @param fields A character vector containing the names of fields to be 
#'  included in the returned table. The input is checked to ensure the specified
#'  fields exist in the chosen resource.
#' @param limit An integer specifying the maximum number of records to be
#'  returned, the default NULL value returns all records.
#' @param where A character string containing the 'WHERE' element of a simple
#'  SQL SELECT style query. Field names must be double quoted ",
#'  non-numeric values must be single quoted ', and both single and
#'  double quotes must be delimited. Example; \code{where = "\"AgeGroup\" = 
#'  \'45-49 years\'"}.
#'
#' @return A data.frame.
#'
#' @examples
#' \dontrun{
#' get_data(
#'   resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
#'   fields = c("AgeGroup", "EuropeanStandardPopulation"),
#'   limit = 5L,
#'   where = "\"AgeGroup\" = \'45-49 years\'"
#' )
#' }
#'
#' @export
get_data <- function(resource, fields = NULL, limit = NULL, where = NULL) {

  stopifnot("resource id not recognised, a valid id should be 36 characters" = valid_id(resource))
  
  meta <- resource_metadata(resource)$id

  if (!is.null(limit)) limit <- as.integer(limit)

  stopifnot(all(fields %in% meta))

  use_nosql <- !(is.null(limit) || limit > 99999) & is.null(where)
  
  if (use_nosql) {

    query <- prep_nosql_query(resource, fields, limit)

  } else {

    query <- prep_sql_query(resource, fields, limit, where)
    
  }

  res <- httr::GET(query)
  
  httr::stop_for_status(res)
  
  res <- httr::content(res)

  out = data.table::setDF(
    data.table::rbindlist(res$result$records, use.names = TRUE, fill = TRUE)
  )

  if (!use_nosql) out = utils::type.convert(out, as.is = TRUE)

  rm_col <- -which(names(out) %in% c("_full_text", "_id"))

  if (length(rm_col) > 0) out <- out[ , rm_col]

  return(out)
}
