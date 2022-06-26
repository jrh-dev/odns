
testthat::test_that('function correctly return list of data sets', {
  
  testthat::skip_on_cran()
  
  testthat::expect_true(is.list(
    get_resource(package = "standard-populations", limit = 1L)
  ))
})

testthat::test_that('function correctly return list of data sets', {
  
  testthat::skip_on_cran()
  
  testthat::expect_true(is.list(
    get_resource(package = "standard-populations",
                resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
                limit = 1L
    )
  ))
})

testthat::test_that('check all returns have had row limit applied', {
  
  testthat::skip_on_cran()
  
  res <- get_resource(package = "standard-populations",
                     limit = 5L
  )
  
  testthat::expect_true(all(unlist(lapply(res, nrow)) == 5))
})



testthat::test_that("error when resource not found", {
  
  load(testthat::test_path("test_data", "pck_meta_full.rda"))
  
  mockery::stub(get_resource, 'package_metadata', 
                function(...) pck_meta_full)
  
  testthat::expect_error(
    get_resource(package = "a_package_name",
                resource = "000000000000000000000000000000000000",
                limit = 1L
    ))
})
