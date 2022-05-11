## This requires a census API key
library(dplyr)
library(tidycensus)
library(tidyr)
library(tigris)

options(tigris_use_cache=TRUE)

# Get the map of counties of NJ (using tigris)
county_map <- counties(state="New Jersey", class="sf")

# Get a population table for the counties of NJ
county_pop <- get_estimates(geography = "county", product = "population") %>%
  separate(NAME, sep=", ", into=c("county", "state")) %>%
  filter(state=="New Jersey", variable=="POP") %>%
  select(county, population=value)

# Get the county names as a vector
counties <- county_pop %>% pull(county) %>% sort()

# Get maps of each county and put them in a named list
municipality_map <- counties %>%
  purrr::map(~county_subdivisions("NJ", county=., class="sf"))
names(municipality_map) <- counties

# Get population tables for each county put them in a named list.
municipality_pop <- counties %>%
  purrr::map(
    ~ tidycensus::get_estimates(geography="county subdivision",
                                state="NJ",
                                county=.,
                                year=2019,
                                variables="POP") %>%
      separate(NAME, sep=", ", into=c("municipality","county","state")) %>%
      select(municipality, county, population=value)
  )
names(municipality_pop) <- counties

# Get the date range in years (we will use this in the yearly percapita
# calculation)
date_range <- range(incident$incident_date_1)
data_range_in_years <- as.integer(date_range[[2]] - date_range[[1]]) / 365.25

# Save all this as internal data
usethis::use_data(counties, county_map, county_pop, municipality_pop,
                  municipality_map, data_range_in_years,
                  overwrite = TRUE, internal = TRUE)


