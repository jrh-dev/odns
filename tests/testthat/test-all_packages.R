testthat::test_that('no errors and successful return of all packages', {
  
  load(testthat::test_path("test_data", "pck_list_res.rda"))
  
  mockery::stub(all_packages, 'httr::GET', 
                function(...) pck_list_res)
  
  testthat::expect_equal(
    digest::digest(all_packages()),
    "09b729d9e882565eb6a79c21c36917d5"
  )
})

testthat::test_that("error when request fails", {
  
  load(testthat::test_path("test_data", "test_res_fail.rda"))
  
  mockery::stub(all_packages, 'httr::GET', 
                function(...) test_res_fail)
  
  testthat::expect_error(
    digest::digest(all_packages())
    )
})

testthat::test_that('filter functionality works', {
  
  load(testthat::test_path("test_data", "pck_list_res.rda"))
  
  mockery::stub(all_packages, 'httr::GET', 
                function(...) pck_list_res)
  
  testthat::expect_equal(
    digest::digest(all_packages(contains = "standard-populations")),
    "0e676fec7cadbd3a48bd723cf815a19c"
  )
})

