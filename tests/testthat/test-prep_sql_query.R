
testthat::test_that(
  "created query is as expected",{
    
    testthat::expect_equal(
      prep_sql_query(
        resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
        fields = c("Dose", "Product"),
        limit = 10,
        where = "\"Product\" = \'Total\' AND \"DOSE\" = \'Dose 1\'"),
      "https://www.opendata.nhs.scot/api/3/action/datastore_search_sql?sql=SELECT%20%22Dose%22,%22Product%22%20FROM%20%2242f17a3c-a4db-4965-ba68-3dffe6bca13a%22WHERE%20%22Product%22%20=%20'Total'%20AND%20%22DOSE%22%20=%20'Dose%201'%20LIMIT%2010"
    )  
  })

testthat::test_that(
  "created query is as expected and works with API",{
    
    testthat::skip_on_cran()
    
    query <- prep_sql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose", "Product"),
      limit = 1,
      where = "\"Product\" = \'Total\' AND \"Dose\" = \'Dose 1\'"
    )
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_true(
      res$success & 
        length(res$result$records) == 1 &
        length(res$result$records[[1]]) == 2 &
        res$result$records[[1]]$Dose == "Dose 1"
    )
  })

testthat::test_that(
  "created query is as expected but fails because of
  'Doses' in 'where' not being a valid field name",{
    
    testthat::skip_on_cran()
    
    query <- prep_sql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose", "Product"),
      limit = 1,
      where = "\"Product\" = \'Total\' AND \"Doses\" = \'Dose 1\'")
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_false(res$success)
    
  })

testthat::test_that(
  "query runs successfully when fields is NULL",{
    
    testthat::skip_on_cran()
    
    query <- prep_sql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = NULL,
      limit = 1,
      where = "\"Product\" = \'Total\' AND \"Dose\" = \'Dose 1\'")
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_true(res$success)
    
  })

testthat::test_that(
  "query runs successfully when where is NULL",{
    
    testthat::skip_on_cran()
    
    query <- prep_sql_query(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose", "Product"),
      limit = 1,
      where = NULL)
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_true(res$success)
    
  })

testthat::test_that(
  "error for non valid resource id",{
    
    testthat::skip_on_cran()
    
    query <- prep_sql_query(
      resource = "abc123",
      fields = NULL,
      limit = 1,
      where = "\"Product\" = \'Total\' AND \"Dose\" = \'Dose 1\'")
    
    res <- httr::content(httr::GET(query))
    
    testthat::expect_false(res$success)
    
  })
