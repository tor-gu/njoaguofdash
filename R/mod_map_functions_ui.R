map_ui_make_scale_choice_list <- function(filter_name) {
  if (filter_name == "all") {
    c("Absolute"="absolute", "Per Capita"="percapita")
  } else {
    c("Absolute"="absolute", "Relative"="relative", "Per Capita"="percapita")
  }
}
