
testthat::test_that('no errors and successful run', {
  
  load(testthat::test_path("test_data", "res_get_data.rda"))
  
  mockery::stub(get_data, 'resource_metadata', 
                function(...) list(id=c("Product", "Dose", "CumulativeNumberVaccinated")))
  
  mockery::stub(get_data, 'httr::POST', 
                function(...) res_get_data)
  
  testthat::expect_equal(
  digest::digest(get_data(
    resource = "abc123",
    fields = c("Product", "Dose", "CumulativeNumberVaccinated"),
    limit = 10,
    where = "\"Product\" = \'Total\'"
  )),
  "0ad490a212ccae03861803683ef3b221")
})



testthat::test_that("error when non-valid field value supplied to 'fields'", {
  
  load(testthat::test_path("test_data", "res_get_data.rda"))
  
  mockery::stub(get_data, 'resource_metadata', 
                function(...) list(id=c("Product", "Dose", "CumulativeNumberVaccinated")))
  
  mockery::stub(get_data, 'httr::POST', 
                function(...) res_get_data)
  
  testthat::expect_error(
    get_data(
      resource = "abc123",
      fields = c("Product", "Doses", "CumulativeNumberVaccinated"),
      limit = 10,
      where = "\"Product\" = \'Total\'"
    ))
})


testthat::test_that("use no sql method then limit within 1:99999 and 'where' is NULL", {
  
  testthat::skip_on_cran()
  
  mockery::stub(get_data, 'prep_sql_query', 
                function(...) stop("unexpected query builder used"))
  
  testthat::expect_error(
    tmp <- get_data(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose"),
      limit = 1,
      where = NULL
    ), NA)
  
  testthat::expect_equal(names(tmp), "Dose")
})

testthat::test_that("use sql method then limit within 1:99999 and 'where' is NULL", {
  
  testthat::skip_on_cran()
  
  mockery::stub(get_data, 'prep_nosql_query', 
                function(...) stop("unexpected query builder used"))
  
  testthat::expect_error(
    tmp <- get_data(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose"),
      limit = 100000,
      where = NULL
    ), NA)
  
  testthat::expect_equal(names(tmp), "Dose")  
  
})

testthat::test_that("use sql method then limit within 1:99999 and 'where' is not NULL", {
  
  testthat::skip_on_cran()
  
  mockery::stub(get_data, 'prep_nosql_query', 
                function(...) stop("unexpected query builder used"))
  
  testthat::expect_error(
    tmp <- get_data(
      resource = "42f17a3c-a4db-4965-ba68-3dffe6bca13a",
      fields = c("Dose"),
      limit = 1,
      where = "\"Dose\" = \'Dose 1\'"
    ), NA)
  
  testthat::expect_equal(names(tmp), "Dose")
})
