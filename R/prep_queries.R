#' Prepare an API query without SQL.
#'
#' @param resource A resource id identifying the data set to be returned.
#' @param fields Names of fields to be included in the returned table.
#' @param limit Specify the maximum number of records to be returned.
#'  
#' @return A string containing the prepared query.
prep_nosql_query <- function(resource, fields, limit) {
  
  if (is.null(limit) || limit > 99999) stop("Limit should be defined and <= 99,999")
  
  f = glue::glue("&fields={paste0(fields, collapse = \",\")}")
  l = glue::glue("&limit={paste0(limit, collapse = \",\")}")
  
  query <- utils::URLencode(
    glue::glue(
      "https://www.opendata.nhs.scot/api/3/action/datastore_search?",
      "id={resource}",
      "{if (!is.null(fields)) f else \"\"}",
      "{if (!is.null(limit)) l else \"\"}"
    ))
  
  cap_url(query)
  
  return(query)
}

#' Prepare an API query with SQL.
#'
#' @param resource A resource id identifying the data set to be returned.
#' @param fields Names of fields to be included in the returned table.
#' @param limit Specify the maximum number of records to be returned.
#' @param where A string containing the 'WHERE' element of a simple SQL SELECT
#'  style query. Field names must be double quoted, non numeric values must be
#'  single quoted, and single and double quotes must be delimited.
#'
#' @return A string containing the prepared query.
prep_sql_query <- function(resource, fields, limit, where) {
  
  if (!is.null(fields)) fields <- paste0("\"", fields, "\"", collapse = ",")
  
  query <- utils::URLencode(
    glue::glue(
      "https://www.opendata.nhs.scot/api/3/action/datastore_search_sql?",
      "sql=",
      "SELECT {if (is.null(fields)) \"*\" else fields} FROM ",
      "\"",
      "{resource}",
      "\"",
      "{if (is.null(where)) \"\" else glue::glue(\"WHERE {where}\")}",
      "{if (is.null(limit)) \"\" else paste0(\" LIMIT \", limit)}"
    ))
  
  cap_url(query)
  
  return(query)
}
