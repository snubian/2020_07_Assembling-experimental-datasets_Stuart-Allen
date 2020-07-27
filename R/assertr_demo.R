# data validation with assertr demo
#
# Stuart Allen, 30/07/2020
#
# https://github.com/ropensci/assertr
# https://cran.r-project.org/web/packages/assertr/vignettes/assertr.html
# https://cran.r-project.org/web/packages/assertr/assertr.pdf


library(tidyverse)
library(assertr)


# =====================================================================================
#
# for demonstration purposes, read in our sample (messy) data and tidy up:
#   
#   - readr::read_csv() to skip unwanted header row(s)
#   - dplyr::select to remove unwanted column(s)
#   - dplyr::rename to give columns more appropriate names
#   - use the pipe operator (%>%) to chain multiple function calls (magrittr, tidyverse)


d <-
  read_csv("data/assertr_sample.csv", skip = 4) %>%
  select(
    -`Leaf size (cm2)`
  ) %>%
  rename(
    treatment_group = Group,
    species_name = Name,
    growth_form = `Growth form`,
    life_form = `life form`,
    height_category = height,
    leaf_area_mm2 = `leaf area mm`,
    growth_season = `growth season`,
    specific_leaf_area_m2kg = SLA,
    dry_matter_content_mg_per_g = `dry matter content mg/g`
  )


# =====================================================================================
#
# assertr::verify() is the simplest of the assertr functions
#
#   - it evaluates a given logical expression against your data and will raise an error
#     if any of the values returned from the expression are FALSE, otherwise it simply
#     returns the data
#
#   - we can start by checking that dry_matter_content_mg_per_g (a continuous value) is
#     always greater than zero


verify(d, dry_matter_content_mg_per_g > 0)


#   - we can use logical operators (&, |) to create more complex expressions, e.g. check
#     that dry_matter_content_mg_per_g is greater than 0 AND less than 400


verify(d, dry_matter_content_mg_per_g > 0 & dry_matter_content_mg_per_g < 400)


# N.B. from here on in we'll use the piping operator %>% to pass the data to the
#      verify() function, as ultimately we want to use %>% to chain together multiple
#      assertr calls, i.e. join together multiple data validation steps
#
#   - any logical expression will work, so we can use is.na() to check for missing data
#     in the treatment_group column


d %>%
  verify(!is.na(treatment_group))


#   - we can use the %in% operator to check that all values of a categorical variable
#     are valid, i.e. in an expected list of values


d %>%
  verify(height_category %in% c("<20cm", "20-40cm", ">40cm"))


# =====================================================================================
#
# assertr::assert() is more powerful and returns helpful information on errors
#
#   - instead of a logical expression it takes a "predicate function" - i.e. a function
#     that returns either TRUE or FALSE - and applies that to each element of the column(s)
#     specified
#
#   - to check that data is within a given range, we can use within_bounds(), an assertr
#     helper function that takes an upper and lower limit, and checks if data falls within
#     those limits


d %>%
  assert(within_bounds(100, 1000), dry_matter_content_mg_per_g)


#   - we can specify multiple columns, comma-separated; so here the within_bounds()
#     predicate function is applied to both dry_matter_content_mg_per_g and and leaf_area_mm2


d %>%
  assert(within_bounds(100, 1000), dry_matter_content_mg_per_g, leaf_area_mm2)


#   - assertr functions use dplyr::select() internally, so we can specify multiple columns or a
#     range of columns using familliar select() syntax
#
#   - here we use assertr's not_na() predicate function to check that the values in a range of
#     columns are not NA


d %>%
  assert(not_na, treatment_group:life_form)


#   - use the in_set() helper function to check that categories are valid, as an alternative
#     to using the %in% operator above


d %>%
  assert(in_set("<20cm", "20-40cm", ">40cm"), height_category)


#   - in_set() works for ordinal (numeric) categorical data also (but don't use in_set() for
#     continuous data, use within_bounds() instead)


d %>%
  assert(in_set(1:7), treatment_group)


#   - the is_uniq() helper function allows us to check that all values in one or more specified
#     columns are unique


d %>%
  assert(is_uniq, species_name)


#   - we can create a custom predicate function for use with assert(), as simple or as complex
#     as required
#
#   - to work with assertr the function must return FALSE if it fails
#
#   - here is a function validSpeciesName(), which checks that species names are of a given format
#
#   - N.B. the function uses a regular expression to define a pattern that the species name must match;
#     regular expressions are a powerful tool when working with character strings, and worth looking
#     into (also a good topic for an R workshop!)


validSpeciesName <-
  function(x) {
    str_detect(x, "^[A-Z][a-z]* [a-z\\-]*$")
  }


#  - we can use our custom function with assert() to detect invalid species names


d %>%
  assert(validSpeciesName, species_name)


# =====================================================================================
#
# assertr::insist() is used mostly with the assertr helper functions within_n_sds() and
# within_n_mads() to check data for outliers, or potential data errors
#
#   - e.g., we can check for data more than 3 standard deviations from the mean


d %>%
  insist(within_n_sds(3), specific_leaf_area_m2kg)


#   - within_n_mads() uses median and median absolute deviation rather than mean and standard deviation,
#     and may be a better approach for detecting outliers


d %>%
  insist(within_n_mads(3), specific_leaf_area_m2kg)


# =====================================================================================
#
# up til now we've been dealing with column-wise data verification
#
# assertr::assert_rows() is a row-wise version of assert(), it takes a "row reduction function"
# and then applies the given predicate function to the result
# 
#   - e.g. the assertr helper function num_row_NAs(), which counts the NA values in each row
#
#   - here we check that the number of NA values in any row is within the bounds 0 and 1


x <- d %>%
  assert_rows(num_row_NAs, within_bounds(0, 1), dplyr::everything())


# =====================================================================================
#
# refer to the assertr documentation for additional functions and use cases, especially
# for outlier detection
#
# =====================================================================================



# =====================================================================================
#
#   - can put together a series of assertr functions, then use this inline with our
#     analysis
#
#   - the analysis will halt if any of our validation checks fail, otherwise the
#     analysis will continue as usual

#   - we can create vectors of valid values for our categorical variables, then refer
#     to these in our assertr functions


validGrowthForms <-
  c(
    "erect forbs",
    "rhizomatous/stoloniferous",
    "rosette/partial rosette forbs",
    "scrambling or mat forbs",
    "tussock grass or sedge"
  )

validLifeForms <-
  c(
    "therophyte",
    "hemicryptophyte",
    "chamaephyte"
  )
  

#   - here is the original code to read in and tidy our data, followed by a series of
#     data validation steps
#
#   - by default execution halts at the first validation error, but if we wrap our assertr
#     functions in a chain_start & chain_end, then ALL the validation steps are completed
#     and a full list of errors is reported


d <-
  read_csv("data/assertr_sample.csv", skip = 4) %>%
  select(
    -`Leaf size (cm2)`
  ) %>%
  rename(
    treatment_group = Group,
    species_name = Name,
    growth_form = `Growth form`,
    life_form = `life form`,
    height_category = height,
    leaf_area_mm2 = `leaf area mm`,
    growth_season = `growth season`,
    specific_leaf_area_m2kg = SLA,
    dry_matter_content_mg_per_g = `dry matter content mg/g`
  ) %>%
  chain_start %>%
  assert(in_set(1:7), treatment_group) %>%
  assert(not_na, treatment_group:life_form) %>%
  assert(validSpeciesName, species_name) %>%
  assert(in_set(validGrowthForms), growth_form) %>%
  assert(in_set(validLifeForms), life_form) %>%
  chain_end


# =====================================================================================
#
#   - we can also abstract our validation steps and reuse them in multiple places in our
#     code without having to repeat all the steps

#   - first read in the data as before


d <-
  read_csv("data/assertr_sample.csv", skip = 4) %>%
  select(
    -`Leaf size (cm2)`
  ) %>%
  rename(
    treatment_group = Group,
    species_name = Name,
    growth_form = `Growth form`,
    life_form = `life form`,
    height_category = height,
    leaf_area_mm2 = `leaf area mm`,
    growth_season = `growth season`,
    specific_leaf_area_m2kg = SLA,
    dry_matter_content_mg_per_g = `dry matter content mg/g`
  )


#   - then create an object called "validate" which is our validation chain (this 
#     kind of R object is called a functional sequence)


validate <-
  . %>%
  chain_start %>%
  assert(in_set(1:7), treatment_group) %>%
  assert(not_na, treatment_group:life_form) %>%
  assert(validSpeciesName, species_name) %>%
  assert(in_set(validGrowthForms), growth_form) %>%
  assert(in_set(validLifeForms), life_form) %>%
  chain_end


#   - we can then easily insert a "validate" step prior to our analysis steps


d %>%
  validate %>%
  group_by(growth_form) %>%
  summarise(sla_mean = mean(specific_leaf_area_m2kg))

