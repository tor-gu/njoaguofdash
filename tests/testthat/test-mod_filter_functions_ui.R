library(dplyr)
library(stringr)

test_that("filter_ui_make_filter_value_choice_list works on a logical vector", {
  choice_list <- filter_ui_make_filter_value_choice_list(
    njoaguof::incident, "incident", "indoors")
  expect_equal(choice_list, c("True" = TRUE, "False" = FALSE))
})


test_that("filter_ui_make_filter_value_choice_list works on a factor", {
  choice_list <- filter_ui_make_filter_value_choice_list(
    njoaguof::subject, "subject", "type")
  expect_equal(choice_list,
               c("Person", "Animal", "Other", "Unknown Subject(s)"))
})

test_that("filter_ui_make_filter_value_choice_list works on a character", {
  choice_list <- filter_ui_make_filter_value_choice_list(
    njoaguof::incident %>% filter(str_detect(agency_name, "Rockaway")),
    "incident",
    "agency_name")

  expect_equal(choice_list,
               c("Rockaway Boro PD","Rockaway Twp PD" ))
})



test_that("filter_ui_make_filter_choice_list returns the right top-level", {
  expected_subject_top_level <- c("All Subjects","Single Valued","Multi Valued")
  expected_incident_top_level <- c("All Incidents","Single Valued","Multi Valued")

  subject_top_level <- names(filter_ui_make_filter_choice_list("subject"))
  incident_top_level <- names(filter_ui_make_filter_choice_list("incident"))

  expect_equal(subject_top_level, expected_subject_top_level)
  expect_equal(incident_top_level, expected_incident_top_level)
})

