## This requires a census API key
library(dplyr)
library(tidycensus)
library(tidyr)
library(tigris)

options(tigris_use_cache=TRUE)
county_map <- counties(state="New Jersey", class="sf")

county_pop <- get_estimates(geography = "county", product = "population") %>%
  separate(NAME, sep=", ", into=c("county", "state")) %>%
  filter(state=="New Jersey", variable=="POP") %>%
  select(county, population=value)

counties <- county_pop %>% pull(county) %>% sort()

municipality_map <- counties %>%
  purrr::map(~county_subdivisions("NJ", county=., class="sf"))
names(municipality_map) <- counties

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


usethis::use_data(counties, county_map, county_pop, municipality_pop,
                  municipality_map, overwrite = TRUE, internal = TRUE)
