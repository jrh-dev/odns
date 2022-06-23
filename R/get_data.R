#' Get data from a resource.
#'
#' @description Get data from a resource in tabular format.
#'
#' @param resource A resource id identifying the data set to be returned.
#' @param fields Names of fields to be included in the returned table.
#' @param limit Specify the maximum number of records to be returned, default
#'  NULL value returns all records. Note that specifying a limit > 99,999 or no
#'  limit forces the use of SQL, which carries a small performance penalty.
#' @param where A string containing the 'WHERE' element of a simple SQL SELECT
#'  style query
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
get_data <- function(resource, fields = NULL, limit = NULL, where = NULL) {

  meta <- resource_metadata(resource)$id

  if (!is.null(limit)) limit <- as.integer(limit)

  stopifnot(all(fields %in% meta))

  if (!(is.null(limit) || limit > 99999) & is.null(where)) {

    f = glue::glue("&fields={paste0(fields, collapse = \",\")}")
    l = glue::glue("&limit={paste0(limit, collapse = \",\")}")

    query <- utils::URLencode(
      glue::glue(
        "https://www.opendata.nhs.scot/api/3/action/datastore_search?",
        "id={resource}",
        "{if (!is.null(fields)) f else \"\"}",
        "{if (!is.null(limit)) l else \"\"}"
      ))

    print("nosql") # for dev only, to rm

  } else {

    if (!is.null(where)) where <- parse_where(where, meta)

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

    print("sql") # for dev only, to rm
  }

  res <- httr::content(httr::POST(query))

  out = as.data.frame(purrr::map_dfr(res$result$records, ~.x), stringsAsFactors = FALSE)

  if (!is.null(where)) out = utils::type.convert(out, as.is = TRUE)

  rm_col <- -which(names(out) %in% c("_full_text", "_id"))

  if (length(rm_col) > 0) out <- out[ , rm_col]

  return(out)
}

t1 = get_data(resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a", limit = 10,
              fields = c("Date", "Product", "Dose", "CumulativeNumberVaccinated"),
              where = "Dose = 'Dose 1' AND Product = 'Pfizer BioNTech (Comirnaty)'")
