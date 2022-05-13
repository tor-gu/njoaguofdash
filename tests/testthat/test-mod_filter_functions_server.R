library(dplyr)

test_that("filter_server_get_tables gets the state incident table", {
  actual <- filter_server_get_tables("incident", "state", "Morris County")
  expect_null(actual$subject)
  counties_count <- actual$incident_table %>%
    pull(incident_municipality_county) %>%
    unique() %>%
    length()
  expect_equal(counties_count, 22)
})


test_that("filter_server_get_tables gets the state subject table", {
  actual <- filter_server_get_tables("subject", "state", "Morris County")
  incident_counties_count <- actual$incident_table %>%
    pull(incident_municipality_county) %>%
    unique() %>%
    length()
  subject_counties_count <- actual$subject_table %>%
    pull(incident_municipality_county) %>%
    unique() %>%
    length()
  expect_equal(incident_counties_count, 22)
  expect_equal(subject_counties_count, 22)
})

test_that("filter_server_get_tables gets a county incident table", {
  actual <- filter_server_get_tables("incident", "county", "Morris County")
  expect_null(actual$subject)
  counties_count <- actual$incident_table %>%
    pull(incident_municipality_county) %>%
    unique() %>%
    length()
  expect_equal(counties_count, 1)
})


test_that("filter_server_get_tables gets a county subject table", {
  actual <- filter_server_get_tables("subject", "county", "Ocean County")
  incident_counties_count <- actual$incident_table %>%
    pull(incident_municipality_county) %>%
    unique() %>%
    length()
  subject_counties_count <- actual$subject_table %>%
    pull(incident_municipality_county) %>%
    unique() %>%
    length()
  expect_equal(incident_counties_count, 1)
  expect_equal(subject_counties_count, 1)
})

test_that("filter_server_get_summary_table handles county level", {
  tables <- filter_server_get_tables("subject", "county", "Morris County")
  subject_summary <-
    filter_server_get_summary_table(tables, "subject", "county") %>%
    head(3)
  incident_summary <-
    filter_server_get_summary_table(tables, "incident", "county") %>%
    head(3)
  actual <- c("Boonton town", "Butler borough", "Chatham borough")
  expect_equal(subject_summary %>% pull(region), actual)
  expect_equal(incident_summary %>% pull(region), actual)
})


test_that("filter_server_get_summary_table halibrary(njoaguof)
ndles state level", {
  tables <- filter_server_get_tables("subject", "state", "")
  subject_summary <-
    filter_server_get_summary_table(tables, "subject", "state") %>%
    head(3)
  incident_summary <-
    filter_server_get_summary_table(tables, "incident", "state") %>%
    head(3)
  actual <- c("Atlantic County", "Bergen County", "Burlington County")
  expect_equal(subject_summary %>% pull(region) %>% as.character(), actual)
  expect_equal(incident_summary %>% pull(region) %>% as.character(), actual)
})

test_that("filter_server_get_joined_table handles incident/all", {
  tables <- filter_server_get_tables("incident", "county", "Morris County")
  join_table <- filter_server_get_joined_table(tables, "incident", "all")
  expect_equal(names(join_table), names(njoaguof::incident))
})

test_that("filter_server_get_joined_table handles incident/single", {
  tables <- filter_server_get_tables("incident", "county", "Morris County")
  join_table <- filter_server_get_joined_table(tables, "incident", "outdoors")
  expect_equal(names(join_table), names(njoaguof::incident))
})

test_that("filter_server_get_joined_table handles incident/multi", {
  tables <- filter_server_get_tables("incident", "county", "Morris County")
  join_table <- filter_server_get_joined_table(tables, "incident", "planned_contact")
  expect_true("planned_contact" %in% names(join_table))
})


test_that("filter_server_get_joined_table handles subject/all", {
  tables <- filter_server_get_tables("subject", "county", "Morris County")
  join_table <- filter_server_get_joined_table(tables, "subject", "all")
  expected_columns <- c(names(njoaguof::incident), names(njoaguof::subject)) %>%
    unique()
  expect_equal(names(join_table), expected_columns)

})

test_that("filter_server_get_joined_table handles subject/single", {
  tables <- filter_server_get_tables("subject", "county", "Morris County")
  join_table <- filter_server_get_joined_table(tables, "subject", "juvenile")
  expected_columns <- c(names(njoaguof::incident), names(njoaguof::subject)) %>%
    unique()
  expect_equal(names(join_table), expected_columns)
})

test_that("filter_server_get_joined_table handles subject/multi", {
  tables <- filter_server_get_tables("subject", "county", "Morris County")
  join_table <- filter_server_get_joined_table(tables, "subject", "subject_resistance")
  expect_true("subject_resistance" %in% names(join_table))
})

test_that("filter_server_get_filtered_table on incidents", {
  actual <-
    filter_server_get_filtered_table(njoaguof::incident, "incident",
                                     "agency_county", "Union County") %>%
    pull(agency_county) %>% as.character() %>% unique()
  expect_equal(actual, "Union County")
})

test_that("filter_server_get_filtered_table on subjects", {
  actual <-
    filter_server_get_filtered_table(njoaguof::subject, "subject",
                                     "type", "Person") %>%
    pull(type) %>% as.character() %>% unique()
  expect_equal(actual, "Person")
})

test_that("filter_server_get_filter_display_name basic test", {
  actual <- filter_server_get_filter_display_name("subject", "race")
  expected <- "Subject Race"
  expect_equal(actual, expected)
})
