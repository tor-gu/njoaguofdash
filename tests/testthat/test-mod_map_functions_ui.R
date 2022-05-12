test_that("map_ui_make_scale_choice_list works", {
  expect_setequal(
    map_ui_make_scale_choice_list("all"),
    c("absolute", "percapita")
  )
  expect_setequal(
    map_ui_make_scale_choice_list("some_filter"),
    c("absolute", "relative", "percapita")
  )
})

