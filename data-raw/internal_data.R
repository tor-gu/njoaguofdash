## Regenerates R/sysdata.rda -- the maps and population tables the dashboard
## draws on. Run it from the package root:
##
##     source("data-raw/internal_data.R")
##
library(dplyr)
library(purrr)
library(readr)
library(usethis)

options(tigris_use_cache = TRUE)

# Vintages. Keep these two aligned so boundaries and populations describe the
# same year.
PEP_VINTAGE <- 2024
TIGER_YEAR <- 2024

PEP_URL <- paste0(
  "https://www2.census.gov/programs-surveys/popest/datasets/",
  "2020-2024/cities/totals/sub-est2024.csv"
)

# --- Population ------------------------------------------------------------

# SUMLEV 050 is a county; 061 is a minor civil division, which in New Jersey
# means a municipality. Read everything as character: the file uses FIPS codes
# with significant leading zeros.
pep <- read_csv(PEP_URL, col_types = cols(.default = col_character())) %>%
  filter(STNAME == "New Jersey") %>%
  mutate(population = as.integer(POPESTIMATE2024))

county_table <- pep %>%
  filter(SUMLEV == "050") %>%
  select(COUNTY, county = NAME, population)

county_pop <- county_table %>% select(county, population)

# The county names as a sorted vector, used to populate the county selector.
counties <- county_pop %>% pull(county) %>% sort()

municipality_pop_all <- pep %>%
  filter(SUMLEV == "061") %>%
  select(COUNTY, municipality = NAME, population) %>%
  left_join(county_table %>% select(COUNTY, county), by = "COUNTY") %>%
  select(municipality, county, population)

# One population table per county, in a named list.
municipality_pop <- counties %>%
  map(~ municipality_pop_all %>% filter(county == .x))
names(municipality_pop) <- counties

# --- Maps ------------------------------------------------------------------

# Qualify the tigris calls: `counties` above shadows `tigris::counties`.
county_map <- tigris::counties(state = "New Jersey", year = TIGER_YEAR,
                               class = "sf")

municipality_map <- counties %>%
  map(~ tigris::county_subdivisions("NJ", county = .x, year = TIGER_YEAR,
                                    class = "sf"))
names(municipality_map) <- counties

# --- Checks ----------------------------------------------------------------

# The map and the population table are joined on NAMELSAD/region at runtime, so
# a naming drift between the two sources would quietly blank out regions.
stopifnot(
  setequal(county_map$NAMELSAD, county_pop$county),
  all(map2_lgl(municipality_map, municipality_pop,
               ~ all(.y$municipality %in% .x$NAMELSAD)))
)

usethis::use_data(counties, county_map, county_pop, municipality_pop,
                  municipality_map,
                  overwrite = TRUE, internal = TRUE)
