
testthat::test_that('no errors and successful run', {
  
  load(testthat::test_path("test_data", "pck_res.rda"))
  
  mockery::stub(all_resources, "httr::GET", function(...) pck_res)
  
  testthat::expect_equal(
    digest::digest(all_resources(
      package_contains = "standard-populations",
      resource_contains = "European"
    )),
    "b8635f356b6b792c5123eb594bbb737c")
})

testthat::test_that('WARNING when arguments leads to 0 row data.frame', {
  
  load(testthat::test_path("test_data", "pck_res.rda"))
  
  mockery::stub(all_resources, "httr::GET", function(...) pck_res)
  
  testthat::expect_warning(
    all_resources(
      package_contains = "a_package_that_doesnt_exist",
      resource_contains = "a_resource_that_doesnt_exist"
    ))
})

