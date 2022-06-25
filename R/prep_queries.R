#' Prepare an API query without SQL.
#'
#' @param resource A character string specifying resource id of the data set
#'  to be returned.
#' @param fields A character vector specifying the names of fields to be
#'  included in the returned data.
#' @param limit A numeric value specifying the maximum number of rows to be
#' returned.
#'  
#' @return A character string containing the prepared query.
prep_nosql_query <- function(resource, fields, limit) {
  
  stopifnot("resource should be a character string on length 1" = length(resource) == 1)
  stopifnot("limit should be defined and <= 99,999" = !(is.null(limit) || limit > 99999))
  
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
#' @param resource a character string specifying resource id of the data set
#'  to be returned.
#' @param fields a character vector specifying the names of fields to be
#'  included in the returned data.
#' @param limit A numeric value specifying the maximum number of rows to be
#' returned.
#' @param where A character string containing the 'WHERE' element of a simple
#'  SQL SELECT style query. Field names must be double quoted (\code{"}), non 
#'  numeric values must be single quoted (\code{"}), and both single and double
#'  quotes must be delimited. Example; \code{where = "\"AgeGroup\" = 
#'  \'45-49 years\\'"}.
#'
#' @return A character string containing the prepared query.
prep_sql_query <- function(resource, fields, limit, where) {
  
  stopifnot("resource should be a character string on length 1" = length(resource) == 1)
  
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
