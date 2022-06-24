
testthat::test_that('function correctly parses response', {
  
  load(testthat::test_path("test_data", "test_res_success.rda"))
  
  mockery::stub(resource_metadata, 'httr::GET', function(...) test_res_success)
  
  testthat::expect_equal(
  digest::digest(resource_metadata(resource="abcdef")),
  "4df5446e9c60b589f88528350c23e4bd"
  )
})

testthat::test_that('function correctly provides error response', {
  
  load(testthat::test_path("test_data", "test_res_fail.rda"))
  
  mockery::stub(resource_metadata, 'httr::GET', function(...) test_res_fail)
  
  testthat::expect_error(resource_metadata(resource="abcdef"))
  
  rm()
})

testthat::test_that('function returns a data.frame from live query', {
  
  testthat::skip_on_cran()
  
  testthat::expect_true(is.data.frame(
    resource_metadata(resource="8f7b64b1-eb53-43e9-b888-45af0bc25505")
    ))
})

testthat::test_that('function returns an error from live query with badly
                    formed resource id', {
  
  testthat::skip_on_cran()
  
  testthat::expect_error(resource_metadata(resource="abcd123"))
})
