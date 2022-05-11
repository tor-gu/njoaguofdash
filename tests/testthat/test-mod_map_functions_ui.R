test_that("map_ui_make_scale_choice_list works", {
  expect_equal(map_ui_make_scale_choice_list("all"),
               c("absolute","percapita"),
               ignore_attr = TRUE)
  expect_equal(map_ui_make_scale_choice_list("some_filter"),
               c("absolute","relative", "percapita"),
               ignore_attr = TRUE)
})

