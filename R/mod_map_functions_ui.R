map_ui_make_scale_choice_list <- function(filter_name) {
  if (filter_name == "all") {
    c("Absolute"="absolute", "Per Capita"="percapita")
  } else {
    c("Absolute"="absolute", "Relative"="relative", "Per Capita"="percapita")
  }
}

map_ui_scale_help <- function() {
  "This controls the color scale of the map.<br/>
  <ul>
    <li><em>Absolute</em>: Raw count of incidents or subjects </li>
    <li><em>Per Capita</em>: Number of incidents per 100,000 residents, per
      year</li>
    <li><em>Relative</em>: When a filter is applied, the proportion of the
      region's incidents or subjects matching the filter.</li>
  </ul>"
}
