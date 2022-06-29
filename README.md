# odns - access Open Data from NHS Scotland

<!-- badges: start -->

<a href="https://www.repostatus.org/#active"><img src="https://www.repostatus.org/badges/latest/active.svg" alt="Project Status: Active – The project has reached a stable, usable state and is being actively developed." /></a>
[![R-CMD-check](https://github.com/jrh-dev/odns/actions/workflows/check-standard.yaml/badge.svg)](https://github.com/jrh-dev/odns/actions/workflows/check-standard.yaml)
[![test-coverage](https://github.com/jrh-dev/odns/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/jrh-dev/odns/actions/workflows/test-coverage.yaml)

<!-- badges: end -->

`odns` provides a base for exploring and obtaining data available through the [Scottish Health and Social Care Open Data platform](https://www.opendata.nhs.scot/). The package provides a wrapper for the underlying [CKAN](https://ckan.org) API and simplifies the process of accessing the available data with R, allowing users to quickly explore the available data and start using it without having to write complex queries.

## Installation
Install `odns` from CRAN;
```
install.packages("odns")
```

Install `odns` from GitHub;

```
devtools::install_github("https://github.com/jrh-dev/odns")
```

## Usage

### Language of CKAN
CKAN and by extension this package refers to *packages* and *resources*. 

The term *package* refers to a dataset, a collection of *resources*. A *resource*, contains the data itself.

Example of structure;

```
.
├── package_1
│   ├── resource_1
│   ├── resource_2
│   └── resource_3
|
└── package_2
    ├── resource_1
    └── resource_2
```

### Exploring the available data

To view all the packages available;

```
all_packages()
  
#  [1] "18-weeks-referral-to-treatment"                                                
#  [2] "27-30-month-review-statistics"                                                
#  [3] "alcohol-related-hospital-statistics-scotland"
#  [4] "allied-health-professionals-musculoskeletal-waiting-times"
#  [5] "allied-health-professional-vacancies"
#   ...
```

Or, to search for packages whose names contain a certain string;

```
all_packages(contains = "population")

#  [1] "gp-practice-populations" "population-estimates"   
#  [3] "population-projections"  "standard-populations"
```

To view details of the available resources;

```
# view all available resources
all_resources()

#                                     name
#  1 Monthly 18 Weeks RTT by Health Boards
#  2               Review by Council Areas
#                      package_name
#  1 18-weeks-referral-to-treatment
#  2  27-30-month-review-statistics
#                                      id
#  1 f2598c24-bf00-4171-b7ef-a469bbacbf6c
#  2 018ba0e1-6562-43bb-82c5-97b6c6cc22d8
#                              package_id
#  1 aa8b22e8-8a02-484d-a6c8-0a0154a6249d
#  2 f4ee46d4-cda9-4180-b6be-0f0e45ee3c8c
#                 last_modified
#  1 2022-05-31T08:39:46.135064
#  2 2022-04-26T09:06:47.063012
#   ...


# view all resources under packages whose names contain "population"
all_resources(package_contains = "population")

#                                   name            package_name
# 1   GP Practice Populations April 2022 gp-practice-populations
# 2 GP Practice Populations January 2022 gp-practice-populations
#                                     id
# 1 2c701f90-c26d-4963-8062-95b8611e5fd1
# 2 d07debcf-7832-4dc4-afb2-41101d5cc7ff
#                             package_id
# 1 e3300e98-cdd2-4f4e-a24e-06ee14fcc66c
# 2 e3300e98-cdd2-4f4e-a24e-06ee14fcc66c
#                last_modified
# 1 2022-05-10T09:43:24.390241
# 2 2022-02-07T11:13:52.195764

# view all resources, regardless of containing package, whose names contain "European"
all_resources(resource_contains = "european")

#                                   name
#  1        European Standard Population
#  2 European Standard Population by Sex
#            package_name
#  1 standard-populations
#  2 standard-populations
#                                      id
#  1 edee9731-daf7-4e0d-b525-e4c1469b8f69
#  2 29ce4cda-a831-40f4-af24-636196e05c1a
#                              package_id
#  1 4dd86111-7326-48c4-8763-8cc4aa190c3e
#  2 4dd86111-7326-48c4-8763-8cc4aa190c3e
#                 last_modified
#  1 2018-04-05T14:42:35.785110
#  2 2018-04-05T14:45:36.996054

# view all resources under packages whose names contain "population" and where the package name contains contain "european"
all_resources(package_contains = "population", resource_contains = "european")

#                                   name
#  1        European Standard Population
#  2 European Standard Population by Sex
#            package_name
#  1 standard-populations
#  2 standard-populations
#                                      id
#  1 edee9731-daf7-4e0d-b525-e4c1469b8f69
#  2 29ce4cda-a831-40f4-af24-636196e05c1a
#                              package_id
#  1 4dd86111-7326-48c4-8763-8cc4aa190c3e
#  2 4dd86111-7326-48c4-8763-8cc4aa190c3e
#                 last_modified
#  1 2018-04-05T14:42:35.785110
#  2 2018-04-05T14:45:36.996054

```

In the examples above the search strings are case insensitive.

### Viewing package and resource metadata

Package and resource metadata contains useful information about the available data. To view metadata;

```
# view metadata for a package
# using a valid package name
package_metadata(package = "standard-populations")

# using a valid package id
package_metadata(package = "4dd86111-7326-48c4-8763-8cc4aa190c3e")

# view metadata for a resource
# using a valid resource id
resource_metadata(resource="edee9731-daf7-4e0d-b525-e4c1469b8f69")
```

### Importing data to R

To import all resources within a package;

```
# get full data-sets
get_resource(package = "4dd86111-7326-48c4-8763-8cc4aa190c3e")

# get the first 10 rows of each data-set
get_resource(package = "4dd86111-7326-48c4-8763-8cc4aa190c3e", limit = 10L)
```

To import specific resources within a package;

```
get_dataset(
   package = "4dd86111-7326-48c4-8763-8cc4aa190c3e",
   resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
   limit = 5L
   )
```

The `get_data()` function can be used to exact more control over the data returned.

```
# import specified fields from a data set
get_data(
   resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
   fields = c("AgeGroup", "EuropeanStandardPopulation")
 )
```

The `where` argument of `get_data()` can be used to extract more specific subsets of the full resources available by passing the "WHERE" element of a SQL style query.
```
# import specified fields from a data set utilising a SQL style where query
get_data(
   resource = "edee9731-daf7-4e0d-b525-e4c1469b8f69",
   fields = c("AgeGroup", "EuropeanStandardPopulation"),
   where = "\"AgeGroup\" = \'45-49 years\'"
 )
 ```
 
#### Correct formatting for SQL
 
The option provided by the `get_data()` function to specify a `where` argument requires specific formatting for compatibility with the CKAN API. Field names must be double quoted `"`, non-numeric values must be single quoted `'`, and both single and double quotes must be delimited. Example; `where = "\"AgeGroup\" = \'45-49 years\\'"`.