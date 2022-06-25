
testthat::test_that('no errors and successful run', {
  
  load(testthat::test_path("test_data", "pck.rda"))
  
  load(testthat::test_path("test_data", "pck_res.rda"))
  
  mockery::stub(all_resources, 'all_packages', 
                function(...) pck)
  
  mockery::stub(all_resources, 'package_metadata', 
                function(...) pck_res)
  
  testthat::expect_equal(
    digest::digest(all_resources(
      package_contains = "standard-populations",
      resource_contains = "European"
    )),
    "ba503151d1131d40a31ca93cc8f12423")
})

testthat::test_that('error when resource_contains value not found', {
  
  load(testthat::test_path("test_data", "pck.rda"))
  
  load(testthat::test_path("test_data", "pck_res.rda"))
  
  mockery::stub(all_resources, 'all_packages', 
                function(...) pck)
  
  mockery::stub(all_resources, 'package_metadata', 
                function(...) pck_res)
  
  testthat::expect_error(
    all_resources(
      package_contains = "standard-populations",
      resource_contains = "a_resource_that_doesnt_exist"
    ))
})

testthat::test_that('error when package_contains value not found', {
  
  load(testthat::test_path("test_data", "pck.rda"))
  
  load(testthat::test_path("test_data", "pck_res.rda"))
  
  mockery::stub(all_resources, 'all_packages', 
                function(...) pck)
  
  mockery::stub(all_resources, 'package_metadata', 
                function(...) pck_res)
  
  testthat::expect_error(
    all_resources(
      package_contains = "a_package_that_doesnt_exist",
      resource_contains = "a_resource_that_doesnt_exist"
    ))
})
