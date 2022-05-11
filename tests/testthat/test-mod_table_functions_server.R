library(dplyr)

test_that("table_server_get_region_table filters on a county", {
  filtered_table <- njoaguof::incident %>%
    filter(incident_case_number %in% c("20-04685", "1848-22"))

  region_table <- table_server_get_region_table(filtered_table, "state",
                                                "Ocean County")
  expect_equal(nrow(filtered_table), 7)
  expect_equal(region_table$form_id, c(201045,201066))
})

test_that("table_server_get_region_table filters on a town", {
  filtered_table <- njoaguof::incident %>%
    filter(incident_case_number %in% c("20-04685", "1848-22"))

  region_table <- table_server_get_region_table(filtered_table, "county",
                                                "Newark city")
  expect_equal(nrow(filtered_table), 7)
  expect_equal(region_table$form_id, c(28157,28168,28124,28142,28382 ))
})

test_that("table_server_get_region_table finds the right incident columns", {
  filtered_table <- njoaguof::incident %>%
    filter(incident_case_number %in% c("20-04685", "1848-22"))

  region_table <- table_server_get_region_table(filtered_table, "county",
                                                "Newark city")
  expect_equal(names(region_table)[1:5],
               c("incident_date_1", "agency_name", "officer_age",
                 "officer_race", "officer_gender"))
})

test_that("table_server_get_region_table finds the right subject columns", {
  filtered_table <- njoaguof::subject %>%
    filter(form_id %in% c(17225, 58828)) %>%
    left_join(njoaguof::incident)

  region_table <- table_server_get_region_table(filtered_table, "county",
                                                "Newark city")
  expect_equal(nrow(filtered_table), 6)
  expect_equal(nrow(region_table), 3)
  expect_equal(names(region_table)[1:5],
               c("incident_date_1", "age", "juvenile", "race", "gender"))
})

test_that("table_server_get_header_text works", {
  expect_equal(table_server_get_header_text("incident", "Colt's Neck Township"),
               "Colt's Neck Township incidents")
})
