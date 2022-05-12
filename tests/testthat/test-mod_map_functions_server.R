test_that("map_server_get_map returns a state map", {
  map <- map_server_get_map("state")
  expect_true("sf" %in% class(map))
  expect_equal(map %>% pull(NAMELSAD) %>% sort(), counties)
})

test_that("map_server_get_map returns a county map", {
  map <- map_server_get_map("county", "Morris County")
  expect_true("sf" %in% class(map))
  actual_towns <- map %>% pull(NAMELSAD) %>% sort() %>% head(3)
  expected_towns <- c("Boonton town","Boonton township","Butler borough")
  expect_equal(actual_towns, expected_towns)
})


test_that("map_server_get_table_summary fills in NAs with 0s -- state", {
  filtered_table <- tibble::tribble(
    ~incident_municipality_county, ~incident_municipality,
    "Morris County",               "Boonton town"
  )
  actual <- map_server_get_table_summary("state", "Morris County", filtered_table)
  expect_equal(actual %>% filter(filtered_count == 1) %>% nrow(), 1)
  expect_equal(actual %>% filter(filtered_count == 0) %>% nrow(), 20)
})

test_that("map_server_get_table_summary fills in NAs with 0s -- county", {
  filtered_table <- tibble::tribble(
    ~incident_municipality_county, ~incident_municipality,
    "Morris County",               "Boonton town"
  )
  actual <- map_server_get_table_summary("county", "Morris County", filtered_table)
  expect_equal(actual %>% filter(filtered_count == 1) %>% nrow(), 1)
  expect_equal(actual %>% filter(filtered_count == 0) %>% nrow(), 38)
})



test_that("map_server_get_region_values works", {
  filtered_summary <- tibble::tribble(
    ~region, ~filtered_count, ~population,
    "A",     1L,               10L,
    "B",     0L,               15L,
    "C",     0L,               15L,
    "D",     NA_integer_,      30L,
  )
  unfiltered_summary <- tibble::tribble(
    ~region, ~region_count,
    "A",     1L,
    "B",     3L,
    "C",     0L,
    "D",     NA,
  )
  actual <- map_server_get_region_values("incident",
                                         filtered_summary,
                                         unfiltered_summary)
  expected <- tibble::tribble(
    ~region, ~absolute_count, ~population, ~region_count, ~relative, ~percapita, ~hover_text,
    "A",     1,               10,          1,             100,        6640,      "A\n1 incidents\n100% of all incidents\n6640 per 100K pop/year",
    "B",     0,               15,          3,               0,           0,      "B\n0 incidents\n0% of all incidents\n0 per 100K pop/year",
    "C",     NA,              15,          0,              NA,          NA,      "C\nNo data",
    "D",     NA,              30,          NA,             NA,          NA,      "D\nNo data",
  )
  expect_equal(actual, expected)
})
