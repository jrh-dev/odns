
testthat::test_that(
  "created query is as expected",{
    
    testthat::expect_equal(
      prep_nosql_query(
        resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
        fields = c("Dose", "Product"),
        limit = 10),
      "https://www.opendata.nhs.scot/api/3/action/datastore_search?id=42f17a3c-a4db-4965-ba68-3dffe6bca13a&fields=Dose,Product&limit=10"
    )  
  })

testthat::test_that(
  "created query is as expected and works with API",{
    
    testthat::skip_on_cran()
    
    query <- prep_nosql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose", "Product"),
      limit = 1)
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_true(
      res$success & 
        length(res$result$records) == 1 &
        length(res$result$records[[1]]) == 2
    )
    
  })

testthat::test_that(
  "created query is as expected but fails because of
  'Doses' not being a valid field name",{
    
    testthat::skip_on_cran()
    
    query <- prep_nosql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Doses", "Product"),
      limit = 1)
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_false(res$success)
    
  })

testthat::test_that(
  "query runs successfully when fields is NULL",{
    
    testthat::skip_on_cran()
    
    query <- prep_nosql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = NULL,
      limit = 1)
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_true(res$success)
    
  })

testthat::test_that(
  "error when limit is NULL",{
    
    testthat::expect_error(query <- prep_nosql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = NULL,
      limit = NULL))
    
  })

testthat::test_that(
  "error when limit > 99,999",{
    
    testthat::expect_error(query <- prep_nosql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = NULL,
      limit = 100000))
    
  })

testthat::test_that(
  "error for non valid resource id",{
    
    testthat::skip_on_cran()
    
    query <- prep_nosql_query(
      resource = "abc123",
      fields = NULL,
      limit = 1)
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_false(res$success)
    
  })
