testthat::test_that('no errors and successful return of all packages', {
  
  load(testthat::test_path("test_data", "pck_list_res.rda"))
  
  mockery::stub(all_packages, 'httr::GET', 
                function(...) pck_list_res)
  
  testthat::expect_equal(
    digest::digest(all_packages()),
    "48cb1de7695131e5858fc806dcf60d39"
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
  
  load(testthat::test_path("test_data", "pck_list_res_filt.rda"))
  
  mockery::stub(all_packages, 'httr::GET', 
                function(...) pck_list_res_filt)
  
  testthat::expect_equal(
    digest::digest(all_packages(contains = "standard-populations")),
    "2403954ac06d1566ff4606b1f7c450ac"
  )
})

